# ---------------------------------------------------------------------------
# Test DNS : mesure les résolveurs depuis chez toi, applique celui que tu choisis
# ---------------------------------------------------------------------------
function Dns-Carte {
    Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Virtual|VMware|Hyper-V|Tailscale|TAP|WireGuard|Bluetooth' } | Sort-Object -Property LinkSpeed -Descending | Select-Object -First 1
}

function Dns-Actuels($adapt) {
    @((Get-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -AddressFamily IPv4).ServerAddresses)
}

# Résout 6 noms courants sur chaque serveur, 3 fois, garde la médiane. Rend une liste Nom / Serveurs / Mediane.
function Dns-Mesurer($adapt) {
    $actuels = Dns-Actuels $adapt
    $candidats = [ordered]@{
        'Actuel (box / FAI)'   = @($actuels)
        'Quad9 (9.9.9.9)'      = @('9.9.9.9', '149.112.112.112')
        'Cloudflare (1.1.1.1)' = @('1.1.1.1', '1.0.0.1')
        'Google (8.8.8.8)'     = @('8.8.8.8', '8.8.4.4')
    }
    $noms = 'youtube.com', 'steampowered.com', 'discord.com', 'twitch.tv', 'epicgames.com', 'wikipedia.org'
    $resultats = @()
    foreach ($nom in $candidats.Keys) {
        $serveur = $candidats[$nom][0]
        if (-not $serveur) { continue }
        $temps = @()
        foreach ($tour in 1..3) {
            foreach ($d in $noms) {
                $t = Measure-Command { try { Resolve-DnsName -Name $d -Server $serveur -Type A -DnsOnly -NoHostsFile -ErrorAction Stop | Out-Null } catch {} }
                $temps += $t.TotalMilliseconds
            }
        }
        $tri = $temps | Sort-Object
        $mediane = [math]::Round($tri[[int]($tri.Count / 2)], 1)
        $resultats += [pscustomobject]@{ Nom = $nom; Serveurs = $candidats[$nom]; Mediane = $mediane; Actuel = ($nom -like 'Actuel*') }
        Log ("dns       {0,-22} {1,7} ms" -f $nom, $mediane)
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
