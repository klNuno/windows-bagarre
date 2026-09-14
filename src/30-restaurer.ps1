# ---------------------------------------------------------------------------
# Retour arrière et application
# ---------------------------------------------------------------------------
function Tout-Restaurer {
    if ($Avant.Count -eq 0) { Log (Msg 'rienRestaurer'); return }
    Log ((Msg 'restauration') -f $Avant.Count)
    foreach ($id in @($Avant.Keys)) {
        $v = $Avant[$id]
        try {
            switch -Wildcard ($id) {
                'reg|*' {
                    if ($null -eq $v.valeur) { Remove-ItemProperty -Path $v.chemin -Name $v.nom -ErrorAction SilentlyContinue }
                    else { New-ItemProperty -Path $v.chemin -Name $v.nom -Value $v.valeur -PropertyType $v.type -Force | Out-Null }
                }
                'svc|*' {
                    if ($null -ne $v.start) { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$($v.nom)" -Name 'Start' -Value $v.start }
                }
                'pwr|*' {
                    if ($null -ne $v.valeur) {
                        powercfg /setacvalueindex SCHEME_CURRENT $v.sousGroupe $v.reglage $v.valeur | Out-Null
                        powercfg /setdcvalueindex SCHEME_CURRENT $v.sousGroupe $v.reglage $v.valeur | Out-Null
                    } elseif ($v.cle -and (Test-Path $v.cle)) {
                        Remove-Item -Path $v.cle -Recurse -Force -ErrorAction SilentlyContinue   # pas de valeur avant = défaut Windows
                    }
                }
                'cmd|hibernation' { if ($v.actif) { powercfg /h on | Out-Null } }
                'cmd|bootmenupolicy' { if ($v.valeur) { bcdedit /set '{current}' bootmenupolicy $v.valeur | Out-Null } }
                'cmd|dyntick' { if ($v.valeur) { bcdedit /set '{current}' disabledynamictick $v.valeur | Out-Null } else { bcdedit /deletevalue '{current}' disabledynamictick 2>$null | Out-Null } }
                'cmd|reserve' { if ($v.etat -eq 'Enabled') { Set-WindowsReservedStorageState -State Enabled -ErrorAction SilentlyContinue | Out-Null } }
                'cmd|menuclassique' {
                    if (-not $v.existait) { Remove-Item -Path 'HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' -Recurse -Force -ErrorAction SilentlyContinue }
                    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
                }
                'cmd|corbeille' {
                    if (-not $v.existait) { Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}' -Recurse -Force -ErrorAction SilentlyContinue }
                }
                'cmd|timer' {   # l'item n'existe plus (retiré le 2026-09-14), on garde le retour arrière pour ceux qui l'avaient coché

                    if (-not $v.existait) { schtasks /Delete /TN 'bagarre timer' /F 2>$null | Out-Null }
                    Get-Process SetTimerResolution -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                }
                'task|*' { if ($v.etat -ne 'Disabled') { Enable-ScheduledTask -TaskPath $v.chemin -TaskName $v.nom -ErrorAction SilentlyContinue | Out-Null } }
                'netpm|*' { if ($v.valeur -eq 'Enabled') { Enable-NetAdapterPowerManagement -Name $v.carte -ErrorAction SilentlyContinue } }
                'netadv|*' { Set-NetAdapterAdvancedProperty -Name $v.carte -RegistryKeyword $v.mot -RegistryValue $v.valeur -ErrorAction SilentlyContinue }
                'netb|*' { if ($v.actif) { Enable-NetAdapterBinding -Name $v.carte -ComponentID $v.composant -ErrorAction SilentlyContinue } }
                'dns|*' {
                    # serveurs = statiques IPv4 d'avant, serveurs6 = IPv6 (absents dans les états d'avant le 2026-09-14), vides = DHCP
                    $liste = @($v.serveurs) + @($v.serveurs6) | Where-Object { $_ }
                    Set-DnsClientServerAddress -InterfaceIndex $v.ifIndex -ResetServerAddresses
                    if ($liste.Count -gt 0) { Set-DnsClientServerAddress -InterfaceIndex $v.ifIndex -ServerAddresses $liste }
                    foreach ($d in @($v.doh)) {
                        if (-not $d -or -not $d.ip) { continue }
                        if ($d.existait) { Set-DnsClientDohServerAddress -ServerAddress $d.ip -DohTemplate $d.modele -AutoUpgrade ([bool]$d.auto) -AllowFallbackToUdp ([bool]$d.repli) -ErrorAction SilentlyContinue | Out-Null }
                        else { Remove-DnsClientDohServerAddress -ServerAddress $d.ip -ErrorAction SilentlyContinue | Out-Null }
                    }
                    Clear-DnsClientCache
                }
            }
            Log ((Msg 'restaure') -f $id)
        } catch { Log ((Msg 'echecRestauration') -f $id, $_) }
    }
    powercfg /setactive SCHEME_CURRENT | Out-Null
    $Avant.Clear()
    Remove-Item $EtatFichier -ErrorAction SilentlyContinue
    Log (Msg 'finRestauration')
}

function Appliquer-Items($liste) {
    $liste = @($liste)
    if ($liste.Count -eq 0) { Log (Msg 'rienCoche'); return }
    Log ((Msg 'application') -f $liste.Count)
    $barre = if ($Ctl) { $Ctl.Progression } else { $null }
    if ($barre) { $barre.Value = 0; $barre.Visibility = 'Visible' }
    $n = 0
    foreach ($it in $liste) {
        Log "> $($it.Titre)"
        try { & $it.Appliquer } catch { Log ((Msg 'echecItem') -f $it.Id, $_) }
        SauverEtat
        $n++
        if ($barre) { $barre.Value = 100 * $n / $liste.Count; Rafraichir }
    }
    if ($barre) { $barre.Visibility = 'Collapsed' }
    Log ((Msg 'finApplication') -f $EtatFichier, $LogFichier)
}
