# ---------------------------------------------------------------------------
# Test DNS : mesure les résolveurs depuis chez toi, applique celui que tu choisis
# ---------------------------------------------------------------------------
function Dns-Carte {
    Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Virtual|VMware|Hyper-V|Tailscale|TAP|WireGuard|Bluetooth' } | Sort-Object -Property LinkSpeed -Descending | Select-Object -First 1
}

function Dns-Actuels($adapt) {
    @((Get-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -AddressFamily IPv4).ServerAddresses)
}

# Les résolveurs testés, dans l'ordre d'affichage. Cle sert au logo et à la note traduite, Serveurs[0] est celui mesuré.
function Dns-Candidats($adapt) {
    @(
        @{ Cle = 'actuel';     Nom = 'Actuel (box / FAI)';   Serveurs = @(Dns-Actuels $adapt) }
        @{ Cle = 'quad9';      Nom = 'Quad9';                Serveurs = @('9.9.9.9', '149.112.112.112') }
        @{ Cle = 'cloudflare'; Nom = 'Cloudflare';           Serveurs = @('1.1.1.1', '1.0.0.1') }
        @{ Cle = 'google';     Nom = 'Google';               Serveurs = @('8.8.8.8', '8.8.4.4') }
        @{ Cle = 'adguard';    Nom = 'AdGuard DNS';          Serveurs = @('94.140.14.14', '94.140.15.15') }
        @{ Cle = 'opendns';    Nom = 'OpenDNS';              Serveurs = @('208.67.222.222', '208.67.220.220') }
        @{ Cle = 'mullvad';    Nom = 'Mullvad';              Serveurs = @('194.242.2.2') }
        @{ Cle = 'dns0';       Nom = 'dns0.eu';              Serveurs = @('193.110.81.0', '185.253.5.0') }
        @{ Cle = 'controld';   Nom = 'Control D';            Serveurs = @('76.76.2.0', '76.76.10.0') }
    )
}

# Résout 6 noms courants sur un serveur, 3 tours, garde la médiane en ms (nombre, jamais une chaîne : la virgule
# décimale française cassait la conversion). Un serveur injoignable au premier tour n'a pas droit aux deux autres.
function Dns-Mesurer-Un($serveur) {
    $noms = 'youtube.com', 'steampowered.com', 'discord.com', 'twitch.tv', 'epicgames.com', 'wikipedia.org'
    $temps = @()
    foreach ($tour in 1..3) {
        foreach ($d in $noms) {
            $t = Measure-Command { try { Resolve-DnsName -Name $d -Server $serveur -Type A -DnsOnly -NoHostsFile -ErrorAction Stop | Out-Null } catch {} }
            $temps += [double]$t.TotalMilliseconds
            Rafraichir
        }
        $tri = @($temps | Sort-Object)
        if ($tour -eq 1 -and $tri[[int]($tri.Count / 2)] -gt 800) { break }
    }
    $tri = @($temps | Sort-Object)
    [math]::Round([double]$tri[[int]($tri.Count / 2)], 1)
}

# Tous les candidats d'un coup (le journal, la fenêtre mesure un par un pour afficher au fur et à mesure)
function Dns-Mesurer($adapt) {
    $resultats = @()
    foreach ($c in (Dns-Candidats $adapt)) {
        if (-not $c.Serveurs[0]) { continue }
        $mediane = Dns-Mesurer-Un $c.Serveurs[0]
        $resultats += [pscustomobject]@{ Cle = $c.Cle; Nom = $c.Nom; Serveurs = $c.Serveurs; Mediane = $mediane; Actuel = ($c.Cle -eq 'actuel') }
        Log ("dns       {0,-20} {1,7} ms" -f $c.Nom, $mediane)
    }
    $resultats
}

function Dns-Appliquer($adapt, $r) {
    Memoriser "dns|$($adapt.ifIndex)" @{ ifIndex = $adapt.ifIndex; serveurs = (Dns-Actuels $adapt) }
    if ($r.Actuel) { Set-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -ResetServerAddresses }
    else { Set-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -ServerAddresses $r.Serveurs }
    SauverEtat
    Log "dns       $($adapt.Name) = $($r.Serveurs -join ', ') ($($r.Nom))"
}
