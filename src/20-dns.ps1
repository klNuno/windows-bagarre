# ---------------------------------------------------------------------------
# Test DNS : mesure les résolveurs depuis chez toi, applique celui que tu choisis, avec un secours,
# le chiffrement (DNS over HTTPS) et l'IPv6 si la connexion en a.
# ---------------------------------------------------------------------------
function Dns-Carte {
    Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Virtual|VMware|Hyper-V|Tailscale|TAP|WireGuard|Bluetooth' } | Sort-Object -Property LinkSpeed -Descending | Select-Object -First 1
}

# Les serveurs que la carte utilise (statiques ou reçus de la box). En IPv6, Windows rend fec0:0:0:ffff::1..3
# quand rien n'est configuré : ce sont des adresses de site obsolètes, pas des serveurs, on les retire.
function Dns-Actuels($adapt, $famille = 'IPv4') {
    @((Get-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -AddressFamily $famille).ServerAddresses | Where-Object { $_ -and $_ -notmatch '^fec0:' })
}

# Les serveurs posés à la main (vide = DHCP). C'est ce qu'on mémorise pour Tout remettre : Get-DnsClientServerAddress
# rend aussi ceux de la box, et les remettre en statique aurait figé la box.
function Dns-Statique($adapt, $famille = 'IPv4') {
    $racine = if ($famille -eq 'IPv6') { 'Tcpip6' } else { 'Tcpip' }
    $v = Reg-Lire "HKLM:\SYSTEM\CurrentControlSet\Services\$racine\Parameters\Interfaces\$($adapt.InterfaceGuid)" 'NameServer'
    @(([string]$v) -split '[,\s]+' | Where-Object { $_ })
}

# La connexion a-t-elle une adresse IPv6 publique (2000::/3) ? Sans ça, un DNS en IPv6 ne répond pas.
function Dns-AIpv6($adapt) {
    [bool](Get-NetIPAddress -InterfaceIndex $adapt.ifIndex -AddressFamily IPv6 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -match '^[23]' })
}

# Les résolveurs testés, dans l'ordre d'affichage. Cle sert au logo et à la note traduite, Serveurs[0] est celui mesuré.
# Adresses relevées le 2026-09-14 sur les pages officielles : joindns4.eu/for-public (Protective), developers.cloudflare.com,
# developers.google.com/speed/public-dns, quad9.net, adguard-dns.io (Default), opendns.com/setupguide (IPv6 non publié,
# donc absent), docs.controld.com/docs/free-dns (p1, malware). Mullvad et dns0.eu retirés : ne répondaient pas chez le mainteneur.
function Dns-Candidats($adapt) {
    @(
        @{ Cle = 'actuel';     Nom = 'Actuel (box / FAI)'; Serveurs = @(Dns-Actuels $adapt);                  Ipv6 = @(Dns-Actuels $adapt 'IPv6');                          Doh = $null }
        @{ Cle = 'quad9';      Nom = 'Quad9';              Serveurs = @('9.9.9.9', '149.112.112.112');       Ipv6 = @('2620:fe::fe', '2620:fe::9');                        Doh = 'https://dns.quad9.net/dns-query' }
        @{ Cle = 'cloudflare'; Nom = 'Cloudflare';         Serveurs = @('1.1.1.1', '1.0.0.1');               Ipv6 = @('2606:4700:4700::1111', '2606:4700:4700::1001');     Doh = 'https://cloudflare-dns.com/dns-query' }
        @{ Cle = 'google';     Nom = 'Google';             Serveurs = @('8.8.8.8', '8.8.4.4');               Ipv6 = @('2001:4860:4860::8888', '2001:4860:4860::8844');     Doh = 'https://dns.google/dns-query' }
        @{ Cle = 'dns4eu';     Nom = 'DNS4EU';             Serveurs = @('86.54.11.1', '86.54.11.201');       Ipv6 = @('2a13:1001::86:54:11:1', '2a13:1001::86:54:11:201'); Doh = 'https://protective.joindns4.eu/dns-query' }
        @{ Cle = 'adguard';    Nom = 'AdGuard DNS';        Serveurs = @('94.140.14.14', '94.140.15.15');     Ipv6 = @('2a10:50c0::ad1:ff', '2a10:50c0::ad2:ff');           Doh = 'https://dns.adguard-dns.com/dns-query' }
        @{ Cle = 'opendns';    Nom = 'OpenDNS';            Serveurs = @('208.67.222.222', '208.67.220.220'); Ipv6 = @();                                                   Doh = 'https://dns.opendns.com/dns-query' }
        @{ Cle = 'controld';   Nom = 'Control D';          Serveurs = @('76.76.2.1', '76.76.10.1');          Ipv6 = @('2606:1a40::1', '2606:1a40:1::1');                   Doh = 'https://freedns.controld.com/p1' }
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

# Un candidat en objet de résultat (la fenêtre les remplit au fur et à mesure, Mediane = $null tant que ce n'est pas mesuré)
function Dns-Resultat($c) {
    [pscustomobject]@{ Cle = $c.Cle; Nom = $c.Nom; Serveurs = $c.Serveurs; Ipv6 = $c.Ipv6; Doh = $c.Doh; Mediane = $null; Actuel = ($c.Cle -eq 'actuel') }
}

# Tous les candidats d'un coup (le journal, la fenêtre mesure un par un pour afficher au fur et à mesure)
function Dns-Mesurer($adapt) {
    $resultats = @()
    foreach ($c in (Dns-Candidats $adapt)) {
        if (-not $c.Serveurs[0]) { continue }
        $r = Dns-Resultat $c
        $r.Mediane = Dns-Mesurer-Un $c.Serveurs[0]
        $resultats += $r
        Log ("dns       {0,-20} {1,7} ms" -f $c.Nom, $r.Mediane)
    }
    $resultats
}

# La liste à poser : la première adresse du principal, puis le secours. Le même résolveur en secours = sa deuxième
# adresse, un autre = sa première. $champ vaut Serveurs (IPv4) ou Ipv6.
function Dns-Serveurs($principal, $secours, $champ) {
    $liste = @()
    if ($principal.$champ.Count -gt 0) { $liste += $principal.$champ[0] }
    if ($secours) {
        $s = if ($secours.Cle -eq $principal.Cle) { if ($principal.$champ.Count -gt 1) { $principal.$champ[1] } } else { $secours.$champ[0] }
        if ($s -and $s -notin $liste) { $liste += $s }
    }
    @($liste)
}

# Un serveur dans la liste DoH connue de Windows (Get-DnsClientDohServerAddress), avec le passage automatique en HTTPS
# et le repli en clair si le HTTPS échoue. Ce que Microsoft documente pour ce cmdlet ; le drapeau par interface que
# posent les Paramètres n'est pas documenté, on ne le touche pas. Rend ce qu'il y avait avant, pour Tout remettre.
function Dns-Doh-Poser($ip, $modele) {
    $avant = Get-DnsClientDohServerAddress -ServerAddress $ip -ErrorAction SilentlyContinue
    if ($avant) {
        $etat = @{ ip = $ip; existait = $true; modele = $avant.DohTemplate; auto = [bool]$avant.AutoUpgrade; repli = [bool]$avant.AllowFallbackToUdp }
        Set-DnsClientDohServerAddress -ServerAddress $ip -DohTemplate $modele -AutoUpgrade $true -AllowFallbackToUdp $true -ErrorAction Stop | Out-Null
    } else {
        $etat = @{ ip = $ip; existait = $false }
        Add-DnsClientDohServerAddress -ServerAddress $ip -DohTemplate $modele -AutoUpgrade $true -AllowFallbackToUdp $true -ErrorAction Stop | Out-Null
    }
    $etat
}

# Le cmdlet DoH n'existe que sur Windows 11 (et Server 2022) : sur un Windows 10 la case est grisée.
function Dns-Doh-Possible { [bool](Get-Command Add-DnsClientDohServerAddress -ErrorAction SilentlyContinue) }

# Pose principal + secours sur la carte, en IPv4, en IPv6 si demandé (et si le résolveur en a), et déclare les serveurs
# en DoH si demandé. Principal = la box : on remet la carte en automatique, le reste ne s'applique pas.
# Mémorisé pour Tout remettre : les serveurs statiques d'avant (v4 et v6, vides = DHCP) et l'état DoH de chaque adresse touchée.
function Dns-Appliquer($adapt, $principal, $secours, $doh, $ipv6) {
    Memoriser "dns|$($adapt.ifIndex)" @{ ifIndex = $adapt.ifIndex; serveurs = @(Dns-Statique $adapt); serveurs6 = @(Dns-Statique $adapt 'IPv6'); doh = @() }
    $etat = $Avant["dns|$($adapt.ifIndex)"]
    if ($principal.Actuel) {
        Set-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -ResetServerAddresses
        Clear-DnsClientCache
        SauverEtat
        Log "dns       $($adapt.Name) = automatique ($($principal.Nom))"
        return
    }
    $v4 = Dns-Serveurs $principal $secours 'Serveurs'
    $v6 = if ($ipv6) { Dns-Serveurs $principal $secours 'Ipv6' } else { @() }
    Set-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -ResetServerAddresses
    Set-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -ServerAddresses (@($v4) + @($v6))
    $dohFait = @()
    if ($doh -and (Dns-Doh-Possible)) {
        $touches = @()
        foreach ($r in @($principal, $secours)) {
            if (-not $r -or -not $r.Doh) { continue }
            foreach ($ip in (@($r.Serveurs) + @($r.Ipv6))) { if ($ip -in (@($v4) + @($v6)) -and $ip -notin $touches) { $touches += $ip; $dohFait += ,@($ip, $r.Doh) } }
        }
        $etats = @()
        foreach ($paire in $dohFait) {
            try { $etats += Dns-Doh-Poser $paire[0] $paire[1] } catch { Log "dns       DoH $($paire[0]) : $_" }
        }
        # Memoriser ne garde que le premier passage ; l'état DoH s'ajoute à celui-ci sans écraser ce qui y était déjà.
        # Relu depuis le JSON, l'état est un objet et non une table, et ceux d'avant le 2026-09-14 n'ont pas de champ doh.
        if ($etat -isnot [hashtable] -and -not $etat.PSObject.Properties['doh']) { $etat | Add-Member -NotePropertyName doh -NotePropertyValue @() }
        $deja = @($etat.doh | ForEach-Object { $_.ip })
        $etat.doh = @($etat.doh) + @($etats | Where-Object { $_.ip -notin $deja })
    }
    Clear-DnsClientCache
    SauverEtat
    $detail = $v4 -join ', '
    if ($v6.Count -gt 0) { $detail += ' + ' + ($v6 -join ', ') }
    if ($dohFait.Count -gt 0) { $detail += ', DoH' }
    $noms = if ($secours -and $secours.Cle -ne $principal.Cle) { "$($principal.Nom) puis $($secours.Nom)" } else { $principal.Nom }
    Log "dns       $($adapt.Name) = $detail ($noms)"
}
