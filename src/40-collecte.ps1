# ---------------------------------------------------------------------------
# Audit IA : photographie du PC dans un rapport texte anonymisé (ex collecte.ps1). Ne modifie rien.
# ---------------------------------------------------------------------------
function Collecter-Rapport($Sortie) {
$ErrorActionPreference = 'SilentlyContinue'
$Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$sb = New-Object System.Text.StringBuilder
function Titre($t) { [void]$sb.AppendLine(''); [void]$sb.AppendLine("=== $t ==="); Write-Host "  $t" }
function Ligne($t) { [void]$sb.AppendLine([string]$t) }
function Bloc($obj) { if ($null -ne $obj) { ($obj | Out-String -Width 200).TrimEnd() -split "`r?`n" | ForEach-Object { Ligne $_ } } }
function Reg($chemin, $nom) {
    $v = (Get-ItemProperty -Path $chemin -Name $nom).$nom
    if ($null -eq $v) { 'absent' } else { $v }
}
# Valeur vide = commande qui demande l'administrateur (ou objet absent)
function Val($v) { if ($null -eq $v -or [string]$v -eq '') { if ($Admin) { 'inconnu' } else { 'inconnu (admin requis)' } } else { [string]$v } }
# Commande qui lève une exception sans admin : on l'attrape et on passe par Val
function Essai([scriptblock]$bloc) { $v = $null; try { $v = & $bloc } catch { $v = $null }; Val $v }
function Ou($v) { if ($null -eq $v) { 'absent' } else { [string]$v } }

Write-Host ''
Write-Host '  Collecte en cours, environ 30 secondes.' -ForegroundColor Cyan
Ligne "RAPPORT PC pour audit IA, généré le $(Get-Date -Format 'yyyy-MM-dd HH:mm'), admin=$Admin"
Ligne 'Rien de personnel : pas de nom de compte, pas de mot de passe, pas de clé de licence.'

Titre 'Système'
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
Ligne "Windows : $($os.Caption) $($os.Version) build $($os.BuildNumber), installé le $($os.InstallDate.ToString('yyyy-MM-dd'))"
Ligne "Version affichée : $(Reg 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' 'DisplayVersion')"
Ligne "Machine : $($cs.Manufacturer) $($cs.Model), type $($cs.PCSystemType) (1 = fixe, 2 = portable)"
Ligne "Carte mère : $((Get-CimInstance Win32_BaseBoard).Manufacturer) $((Get-CimInstance Win32_BaseBoard).Product), BIOS $((Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion) du $((Get-CimInstance Win32_BIOS).ReleaseDate.ToString('yyyy-MM-dd'))"
$cpu = Get-CimInstance Win32_Processor
Ligne "CPU : $($cpu.Name), $($cpu.NumberOfCores) cœurs / $($cpu.NumberOfLogicalProcessors) threads, $($cpu.MaxClockSpeed) MHz"
Ligne "RAM : $([math]::Round($cs.TotalPhysicalMemory / 1GB)) Go, $(($mem = Get-CimInstance Win32_PhysicalMemory) | Measure-Object | Select-Object -ExpandProperty Count) barrettes à $($mem[0].Speed) MT/s"
Ligne "Uptime : $([math]::Round(((Get-Date) - $os.LastBootUpTime).TotalHours, 1)) h"
Ligne "Sécurité : HVCI (intégrité mémoire) = $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' 'Enabled'), Secure Boot = $(Essai { Confirm-SecureBootUEFI })"
Ligne "Virtualisation : Hyper-V présent = $(Essai { (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All).State }), VirtualMachinePlatform = $(Essai { (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State })"

Titre 'GPU et écrans'
Get-CimInstance Win32_VideoController | ForEach-Object { Ligne "GPU : $($_.Name), pilote $($_.DriverVersion) du $($_.DriverDate.ToString('yyyy-MM-dd')), $($_.CurrentHorizontalResolution)x$($_.CurrentVerticalResolution) @ $($_.CurrentRefreshRate) Hz" }
$nvKey = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}' | Where-Object { (Get-ItemProperty $_.PSPath).DriverDesc -match 'NVIDIA' } | Select-Object -First 1
if ($nvKey) {
    $p = Get-ItemProperty $nvKey.PSPath
    Ligne "NVIDIA VRAM : $([math]::Round($p.'HardwareInformation.qwMemorySize' / 1GB)) Go"
    Ligne "NVIDIA clé pilote : DisableDynamicPstate=$(Ou $p.DisableDynamicPstate) RMHdcpKeyglobZero=$(Ou $p.RMHdcpKeyglobZero) (1 = HDCP coupé) MPO(OverlayTestMode)=$(Reg 'HKLM:\SOFTWARE\Microsoft\Windows\Dwm' 'OverlayTestMode') (5 = MPO coupé)"
}
Ligne "NVIDIA services : $((Get-Service Nv* | ForEach-Object { "$($_.Name)=$($_.StartType)/$($_.Status)" }) -join ', ')"
Ligne "NVIDIA App / GFE installé : $([bool](Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object { $_.DisplayName -match 'NVIDIA (App|GeForce Experience)' }))"
Ligne "Panneau NVIDIA (Store) : $([bool](Get-AppxPackage NVIDIACorp.NVIDIAControlPanel))"
Ligne "Optimisations jeux fenêtrés / HAGS : DirectXUserGlobalSettings = $(Reg 'HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences' 'DirectXUserGlobalSettings'), HwSchMode = $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' 'HwSchMode') (2 = HAGS activé)"
Ligne "Game DVR : AppCaptureEnabled=$(Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled') AllowGameDVR(policy)=$(Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' 'AllowGameDVR') GameMode(AutoGameModeEnabled)=$(Reg 'HKCU:\SOFTWARE\Microsoft\GameBar' 'AutoGameModeEnabled')"

Ligne "Pilote inpoutx64.sys présent (MSI Util / outils d accès matériel, bloqué par KB5121003) : $(Test-Path "$env:SystemRoot\System32\drivers\inpoutx64.sys")"

Titre 'Interruptions MSI des périphériques PCI (GPU, réseau, USB, stockage)'
Get-CimInstance Win32_PnPEntity | Where-Object { $_.PNPClass -in 'Display', 'Net', 'USB', 'SCSIAdapter', 'HDC', 'MEDIA' -and $_.DeviceID -like 'PCI\*' } | ForEach-Object {
    $k = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.DeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
    $msi = if (Test-Path $k) { Reg $k 'MSISupported' } else { 'pas de clé' }
    $prio = Reg "HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.DeviceID)\Device Parameters\Interrupt Management\Affinity Policy" 'DevicePriority'
    Ligne "$($_.PNPClass.PadRight(12)) MSI=$msi prio=$prio  $($_.Name)"
}

Titre 'Disques'
Get-PhysicalDisk | ForEach-Object { Ligne "$($_.FriendlyName) : $($_.MediaType) $($_.BusType) $([math]::Round($_.Size / 1GB)) Go, santé $($_.HealthStatus)" }
Get-Volume | Where-Object DriveLetter | ForEach-Object { Ligne "$($_.DriveLetter): $($_.FileSystem) $([math]::Round($_.SizeRemaining / 1GB)) Go libres sur $([math]::Round($_.Size / 1GB))" }
Ligne "Fichier d échange : $((Get-CimInstance Win32_PageFileUsage | ForEach-Object { "$($_.Name) $($_.AllocatedBaseSize) Mo" }) -join ', ') ; géré auto = $((Get-CimInstance Win32_ComputerSystem).AutomaticManagedPagefile)"
Ligne "Veille prolongée : HibernateEnabled = $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' 'HibernateEnabled'), démarrage rapide HiberbootEnabled = $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' 'HiberbootEnabled')"
Ligne "Stockage réservé : $(Essai { (Get-WindowsReservedStorageState).ReservedStorageState })"
Ligne "TRIM : $(fsutil behavior query DisableDeleteNotify)"

Titre 'Alimentation'
Ligne "Plan actif : $(powercfg /getactivescheme)"
# Lecture dans le registre : marche aussi pour les réglages cachés que powercfg /query n'affiche pas
$schema = ((powercfg /getactivescheme) -replace '.*:\s*([0-9a-f-]{36}).*', '$1')
function Pwr($sub, $set) {
    $k = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\$schema\$sub\$set"
    if (-not (Test-Path $k)) { return 'défaut du plan (pas de valeur propre)' }
    $p = Get-ItemProperty $k
    "AC=$($p.ACSettingIndex) DC=$($p.DCSettingIndex)"
}
Ligne "Core parking (CPMINCORES, 100 = pas de parking) : $(Pwr '54533251-82be-4824-96c1-47b60b740d00' '0cc5b647-c1df-4637-891a-dec35c318583')"
Ligne "Processeur min (%) : $(Pwr '54533251-82be-4824-96c1-47b60b740d00' '893dee8e-2bef-41e0-89c6-b55d0929964c')"
Ligne "USB suspension sélective : $(Pwr '2a737441-1930-4402-8d77-b2bebba308a3' '48e6b7a6-50f5-4782-a5d4-53bb50f7e81d')"
Ligne "PCIe ASPM : $(Pwr '501a4d13-42af-4429-9fd1-a8218c268e20' 'ee12f906-d277-404b-b6da-e5fa1a576df5')"
Ligne "Power Throttling off : $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' 'PowerThrottlingOff')"
Ligne "bcdedit : $(Val (((bcdedit /enum '{current}' | Select-String 'bootmenupolicy|disabledynamictick|useplatformclock|useplatformtick|tscsyncpolicy') -replace '\s+', ' ') -join ' ; '))"

Titre 'Timer et planificateur'
Ligne "GlobalTimerResolutionRequests : $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' 'GlobalTimerResolutionRequests')"
$tt = Get-ScheduledTask -TaskName 'bagarre timer'
Ligne "Tâche 'bagarre timer' : $(if ($tt) { $tt.State } else { 'absente' })"
Ligne "Processus timer en cours : $((Get-Process SetTimerResolution, TimerResolution, ISLC, ProcessLasso | ForEach-Object Name) -join ', ')"
Ligne "Win32PrioritySeparation : $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl' 'Win32PrioritySeparation') (2 = défaut, 38 = 0x26)"
Ligne "SvcHostSplitThresholdInKB : $(Reg 'HKLM:\SYSTEM\CurrentControlSet\Control' 'SvcHostSplitThresholdInKB') (défaut 380000)"
Ligne "Processus en cours : $((Get-Process).Count), dont svchost : $((Get-Process svchost).Count)"
Ligne "Top 10 CPU maintenant :"
Bloc (Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, @{n = 'CPUsec'; e = { [math]::Round($_.CPU) } }, @{n = 'RAMMo'; e = { [math]::Round($_.WorkingSet64 / 1MB) } } | Format-Table -AutoSize)

Titre 'Souris et clavier'
$m = Get-ItemProperty 'HKCU:\Control Panel\Mouse'
Ligne "Accélération : MouseSpeed=$($m.MouseSpeed) Threshold1=$($m.MouseThreshold1) Threshold2=$($m.MouseThreshold2) (0/0/0 = coupée), sensibilité Windows MouseSensitivity=$($m.MouseSensitivity) (10 = 6/11), RawMouseThrottleDuration=$($m.RawMouseThrottleDuration)"
Ligne "Files d attente : souris MouseDataQueueSize=$(Reg 'HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters' 'MouseDataQueueSize') clavier KeyboardDataQueueSize=$(Reg 'HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters' 'KeyboardDataQueueSize')"
Ligne "Souris USB : $((Get-CimInstance Win32_PointingDevice | ForEach-Object Name) -join ', ')"

Titre 'Réseau'
Get-NetAdapter -Physical | ForEach-Object {
    $a = $_
    Ligne "Carte : $($a.Name) ($($a.InterfaceDescription)), $($a.Status), $($a.LinkSpeed), pilote $($a.DriverVersionString) du $($a.DriverDate)"
    if ($a.Status -ne 'Up') { return }
    $pm = Get-NetAdapterPowerManagement -Name $a.Name
    Ligne "  Peut être éteinte par Windows : $(Val $pm.AllowComputerToTurnOffDevice)"
    Get-NetAdapterAdvancedProperty -Name $a.Name | Where-Object { $_.DisplayName -match 'Energy|Green|Power Sav|Interrupt Moderation|Receive Buffers|Transmit Buffers|Jumbo|Flow Control|Speed|RSS|Offload' } | ForEach-Object { Ligne "  $($_.DisplayName) = $($_.DisplayValue)" }
    Get-NetAdapterBinding -Name $a.Name | ForEach-Object { Ligne "  liaison $($_.ComponentID) $($_.DisplayName) = $($_.Enabled)" }
    $g = $a.InterfaceGuid
    Ligne "  Nagle : TcpAckFrequency=$(Reg "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$g" 'TcpAckFrequency') TCPNoDelay=$(Reg "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$g" 'TCPNoDelay')"
}
Ligne "DNS : $((Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object ServerAddresses | ForEach-Object { "$($_.InterfaceAlias)=$($_.ServerAddresses -join '/')" }) -join ' ; ')"
Ligne "Latence vers 1.1.1.1 : $((Test-Connection 1.1.1.1 -Count 4 | Measure-Object ResponseTime -Average).Average) ms (moyenne sur 4)"
$tcp = Get-NetTCPSetting -SettingName Internet
Ligne "TCP global : AutoTuning=$($tcp.AutoTuningLevelLocal) Congestion=$($tcp.CongestionProvider) ECN=$($tcp.EcnCapability)"
Ligne "Optimisation de la distribution (DODownloadMode) : $(Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' 'DODownloadMode') (policy) / $(Reg 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' 'DODownloadMode') (config)"

Titre 'Vie privée et bloat'
Ligne "AllowTelemetry (policy) : $(Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'AllowTelemetry')"
Ligne "Copilot coupé (TurnOffWindowsCopilot) : $(Reg 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' 'TurnOffWindowsCopilot'), Recall (DisableAIDataAnalysis) : $(Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI' 'DisableAIDataAnalysis'), Widgets (AllowNewsAndInterests) : $(Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' 'AllowNewsAndInterests')"
Ligne "Identifiant pub : $(Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' 'Enabled'), Bing dans Démarrer : $(Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' 'BingSearchEnabled')"
Ligne "Windows Update pilotes exclus : $(Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' 'ExcludeWUDriversInQualityUpdate'), DriverSearching : $(Reg 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' 'SearchOrderConfig')"
Ligne "Applis Store (hors framework) : $((Get-AppxPackage | Where-Object { -not $_.IsFramework -and $_.SignatureKind -eq 'Store' }).Count)"
Ligne "Applis Store connues pour être du bloat encore présentes :"
Get-AppxPackage | Where-Object { $_.Name -match 'Xbox|Bing|Clipchamp|Teams|Todos|Solitaire|ZuneMusic|ZuneVideo|People|GetHelp|Getstarted|Copilot|OutlookForWindows|LinkedIn|QuickAssist|PowerAutomate|Cortana|3DViewer|MixedReality|Maps|FeedbackHub|WindowsAlarms|YourPhone|Family' } | ForEach-Object { Ligne "  $($_.Name)" }
$progs = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object { $_.DisplayName -and -not $_.SystemComponent }
$jeux = $progs | Where-Object { $_.UninstallString -match 'steam|epicgames|GOG|Ubisoft|Battle\.net|EA Desktop' }
Ligne "Jeux (Steam / Epic / GOG / Ubisoft / EA) : $($jeux.Count), non listés"
Ligne "Programmes installés (hors jeux et hors composants Windows) :"
$progs | Where-Object { $jeux.DisplayName -notcontains $_.DisplayName -and $_.DisplayName -notmatch '^(Microsoft Visual C\+\+|Microsoft \.NET|Windows SDK|Microsoft Edge|Microsoft Update Health|Microsoft OneDrive)' } | Sort-Object DisplayName -Unique | ForEach-Object { Ligne "  $($_.DisplayName) $($_.DisplayVersion)" }

Titre 'Démarrage automatique'
Get-CimInstance Win32_StartupCommand | ForEach-Object { Ligne "$($_.Location) : $($_.Name) = $($_.Command)" }
function Cles-Run($chemin) { @((Get-ItemProperty $chemin).PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object { $_.Name }) -join ', ' }
Ligne "Run (HKLM) : $(Cles-Run 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run')"
Ligne "Run (HKCU) : $(Cles-Run 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run')"
Ligne "StartupDelayInMSec : $(Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize' 'StartupDelayInMSec')"

Titre 'Services : ceux qui tournent en automatique (hors Microsoft de base) et ceux que le pack coupe'
$pack = 'DiagTrack', 'dmwappushservice', 'lfsvc', 'PhoneSvc', 'MapsBroker', 'RetailDemo', 'WerSvc', 'Fax', 'PcaSvc', 'XblAuthManager', 'XblGameSave', 'XboxNetApiSvc', 'edgeupdate', 'edgeupdatem', 'WMPNetworkSvc', 'wisvc', 'DPS', 'WdiServiceHost', 'WdiSystemHost', 'CDPSvc', 'Spooler', 'WSearch', 'SysMain', 'BITS', 'bthserv', 'BTAGService', 'NvTelemetryContainer'
Get-Service | Where-Object { $_.Name -in $pack } | ForEach-Object { Ligne "pack  $($_.Name.PadRight(22)) $($_.StartType)/$($_.Status)" }
Ligne '---'
Get-CimInstance Win32_Service | Where-Object { $_.StartMode -eq 'Auto' -and $_.PathName -notmatch 'svchost|\\Windows\\' } | ForEach-Object { Ligne "auto  $($_.Name.PadRight(22)) $($_.State.PadRight(8)) $($_.PathName)" }

Titre 'Tâches planifiées de télémétrie'
'\Microsoft\Windows\Application Experience\', '\Microsoft\Windows\Customer Experience Improvement Program\', '\Microsoft\Windows\DiskDiagnostic\', '\Microsoft\Windows\Feedback\Siuf\', '\Microsoft\Windows\Windows Error Reporting\' | ForEach-Object {
    Get-ScheduledTask -TaskPath $_ | ForEach-Object { Ligne "$($_.TaskPath)$($_.TaskName) = $($_.State)" }
}

Titre 'Defender'
$mp = Get-MpPreference
if ($mp) {
    Ligne "Exclusions dossiers : $(($mp.ExclusionPath) -join ' ; ')"
    Ligne "Exclusions processus : $(($mp.ExclusionProcess) -join ' ; ')"
    Ligne "Analyse planifiée : jour $($mp.ScanScheduleDay) à $($mp.ScanScheduleTime), CPU max $($mp.ScanAvgCPULoadFactor) %"
} else { Ligne 'Get-MpPreference indisponible (pas admin ou autre antivirus).' }
Ligne "Autre antivirus : $((Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct | ForEach-Object displayName) -join ', ')"

Titre 'Script bagarre'
if (Test-Path $EtatFichier) {
    $etat = Get-Content $EtatFichier -Raw | ConvertFrom-Json
    Ligne "bagarre-avant.json trouvé ($((Get-Item $EtatFichier).LastWriteTime.ToString('yyyy-MM-dd HH:mm'))), réglages appliqués : $(($etat.PSObject.Properties | ForEach-Object Name) -join ', ')"
} else { Ligne 'bagarre-avant.json introuvable : le script à cocher n a pas été appliqué sur ce PC, ou a été restauré.' }

Titre 'Événements récents (erreurs système et WHEA, 7 jours)'
Get-WinEvent -FilterHashtable @{ LogName = 'System'; Level = 1, 2; StartTime = (Get-Date).AddDays(-7) } -MaxEvents 300 | Group-Object ProviderName | Sort-Object Count -Descending | Select-Object -First 15 | ForEach-Object { Ligne "$($_.Count.ToString().PadLeft(4)) x $($_.Name) : $(($_.Group[0].Message -split "`n")[0].Substring(0, [math]::Min(120, ($_.Group[0].Message -split "`n")[0].Length)))" }

# Anonymisation : nom du compte Windows et SID retirés
$texte = $sb.ToString() -replace '(?i)C:\\Users\\[^\\"]+', 'C:\Users\<toi>' -replace 'HKU\\S-1-5-21-[\d-]+', 'HKCU' -replace [regex]::Escape($env:USERNAME), '<toi>'
[IO.File]::WriteAllText($Sortie, $texte, (New-Object System.Text.UTF8Encoding $true))
Log "Rapport écrit : $Sortie ($([math]::Round((Get-Item $Sortie).Length / 1KB)) Ko)"
}
