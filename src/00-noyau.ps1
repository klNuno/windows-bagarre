# ---------------------------------------------------------------------------
# Noyau : où on est, élévation, détection machine, outils d'écriture avec retour arrière.
# ---------------------------------------------------------------------------
$Depot = 'https://raw.githubusercontent.com/klNuno/windows-bagarre/main'
$Version = '2026-09-13'
$ErrorActionPreference = 'Continue'

# Lancé depuis un clone (powershell -File bagarre.ps1) : outils et images sont à côté.
# Lancé par "irm ... | iex" : $Here est vide, ils sont téléchargés depuis $Depot au besoin.
$Here = if ($PSCommandPath) { Split-Path -Parent $PSCommandPath } else { $null }

# Admin et thread STA (la fenêtre en a besoin). Sinon on se relance élevé, et on rend la main.
# -Liste et -Capture (modes de test) tournent sans admin.
$EstAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$EstSta = [Threading.Thread]::CurrentThread.GetApartmentState() -eq 'STA'
if (-not $Liste -and -not $Capture -and (-not $EstAdmin -or -not $EstSta)) {
    $relance = if ($Here) { "-File `"$PSCommandPath`"" } else { "-Command `"irm $Depot/bagarre.ps1 | iex`"" }
    try {
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden $relance"
        Write-Host "`n  La fenêtre bagarre s'ouvre en administrateur. Tu peux fermer cette console.`n" -ForegroundColor Green
    } catch {
        Write-Host "`n  Élévation refusée : bagarre a besoin des droits administrateur pour régler Windows.`n" -ForegroundColor Yellow
    }
    return
}

# État et journal : ProgramData en admin (le vrai usage), le profil sinon (modes de test).
$Dossier = if ($EstAdmin) { Join-Path $env:ProgramData 'bagarre' } else { Join-Path $env:LOCALAPPDATA 'bagarre' }
if (-not (Test-Path $Dossier)) { New-Item -Path $Dossier -ItemType Directory -Force | Out-Null }
$EtatFichier = Join-Path $Dossier 'bagarre-avant.json'
$LogFichier = Join-Path $Dossier 'bagarre.log'

# ---------------------------------------------------------------------------
# Détection machine (sert aux valeurs automatiques et aux explications)
# ---------------------------------------------------------------------------
$RamGo = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$Gpu = (Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'NVIDIA|AMD|Radeon|Intel' } | Select-Object -First 1).Name
$EstNvidia = $Gpu -match 'NVIDIA'
$EstPortable = (Get-CimInstance Win32_SystemEnclosure).ChassisTypes | Where-Object { $_ -in 8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32 }
$DisqueSysteme = Get-PhysicalDisk | Where-Object { $_.DeviceId -eq ((Get-Partition -DriveLetter $env:SystemDrive[0]).DiskNumber) } | Select-Object -First 1
$EstHdd = $DisqueSysteme -and $DisqueSysteme.MediaType -eq 'HDD'
$Machine = "$RamGo Go RAM, $Gpu, disque système $(if ($EstHdd) { 'HDD' } else { 'SSD' })$(if ($EstPortable) { ', portable' })"

# ---------------------------------------------------------------------------
# Outils : lire, écrire, mémoriser pour le retour arrière
# ---------------------------------------------------------------------------
$Avant = @{}
if (Test-Path $EtatFichier) {
    $json = Get-Content $EtatFichier -Raw | ConvertFrom-Json
    foreach ($p in $json.PSObject.Properties) { $Avant[$p.Name] = $p.Value }
}

function Log($texte) {
    $ligne = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $texte
    Add-Content -Path $LogFichier -Value $ligne
    Write-Host "   $texte" -ForegroundColor DarkGray
    if ($script:Journal) { $script:Journal.AppendText("$texte`r`n"); $script:Journal.ScrollToEnd(); Rafraichir }
}

# Laisse la fenêtre se redessiner pendant une action longue (tout tourne sur le thread de la fenêtre).
function Rafraichir {
    if ($script:Fenetre) { $script:Fenetre.Dispatcher.Invoke([Action] {}, [Windows.Threading.DispatcherPriority]::Background) }
}

function Memoriser($cle, $valeur) {
    if (-not $Avant.ContainsKey($cle)) { $Avant[$cle] = $valeur }
}

function SauverEtat {
    $Avant | ConvertTo-Json -Depth 4 | Set-Content -Path $EtatFichier -Encoding UTF8
}

function Reg-Lire($chemin, $nom) {
    try { (Get-ItemProperty -Path $chemin -Name $nom -ErrorAction Stop).$nom } catch { $null }
}

function Reg-Ecrire($chemin, $nom, $valeur, $type = 'DWord') {
    $id = "reg|$chemin|$nom"
    Memoriser $id @{ chemin = $chemin; nom = $nom; valeur = (Reg-Lire $chemin $nom); type = $type }
    if (-not (Test-Path $chemin)) { New-Item -Path $chemin -Force | Out-Null }
    New-ItemProperty -Path $chemin -Name $nom -Value $valeur -PropertyType $type -Force | Out-Null
    Log "registre  $chemin\$nom = $valeur"
}

function Reg-Supprimer($chemin, $nom) {
    $id = "reg|$chemin|$nom"
    Memoriser $id @{ chemin = $chemin; nom = $nom; valeur = (Reg-Lire $chemin $nom); type = 'DWord' }
    Remove-ItemProperty -Path $chemin -Name $nom -ErrorAction SilentlyContinue
    Log "registre  $chemin\$nom supprimé"
}

function Service-Couper($nom, $description) {
    $svc = Get-Service -Name $nom -ErrorAction SilentlyContinue
    if (-not $svc) { Log "service   $nom absent sur cette machine, ignoré"; return }
    $chemin = "HKLM:\SYSTEM\CurrentControlSet\Services\$nom"
    $start = Reg-Lire $chemin 'Start'
    Memoriser "svc|$nom" @{ nom = $nom; start = $start }
    if ($svc.Status -eq 'Running') { Stop-Service -Name $nom -Force -ErrorAction SilentlyContinue }
    # Écriture directe du type de démarrage : Set-Service refuse certains services protégés.
    Set-ItemProperty -Path $chemin -Name 'Start' -Value 4 -ErrorAction SilentlyContinue
    Log "service   $nom désactivé ($description)"
}

function Tache-Couper($chemin, $nom) {
    $t = Get-ScheduledTask -TaskPath $chemin -TaskName $nom -ErrorAction SilentlyContinue
    if (-not $t) { return }
    Memoriser "task|$chemin$nom" @{ chemin = $chemin; nom = $nom; etat = [string]$t.State }
    Disable-ScheduledTask -TaskPath $chemin -TaskName $nom -ErrorAction SilentlyContinue | Out-Null
    Log "tâche     $chemin$nom désactivée"
}

# Cartes réseau physiques actives (pas les cartes virtuelles VPN / VMware / Bluetooth)
function Cartes-Reseau {
    Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Bluetooth|Virtual|VMware|Hyper-V|TAP|WireGuard|Tailscale' }
}

function Net-Liaison-Couper($carte, $composant, $description) {
    $b = Get-NetAdapterBinding -Name $carte.Name -ComponentID $composant -ErrorAction SilentlyContinue
    if (-not $b) { return }
    Memoriser "netb|$($carte.Name)|$composant" @{ carte = $carte.Name; composant = $composant; actif = [bool]$b.Enabled }
    Disable-NetAdapterBinding -Name $carte.Name -ComponentID $composant -ErrorAction SilentlyContinue
    Log "réseau    $($carte.Name) : $description décoché"
}

function Net-Propriete-Regler($carte, $motif, $valeur, $description) {
    $props = Get-NetAdapterAdvancedProperty -Name $carte.Name -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match $motif }
    foreach ($p in $props) {
        $choix = $p.ValidDisplayValues | Where-Object { $_ -match $valeur } | Select-Object -First 1
        if (-not $choix) { Log "réseau    $($carte.Name) : $($p.DisplayName) n a pas de valeur '$valeur', ignoré"; continue }
        Memoriser "netadv|$($carte.Name)|$($p.RegistryKeyword)" @{ carte = $carte.Name; mot = $p.RegistryKeyword; valeur = [string]$p.RegistryValue }
        Set-NetAdapterAdvancedProperty -Name $carte.Name -RegistryKeyword $p.RegistryKeyword -DisplayValue $choix -ErrorAction SilentlyContinue
        Log "réseau    $($carte.Name) : $($p.DisplayName) = $choix ($description)"
    }
}

function Powercfg-Regler($sousGroupe, $reglage, $valeur, $description) {
    $id = "pwr|$sousGroupe|$reglage"
    $lu = (powercfg /query SCHEME_CURRENT $sousGroupe $reglage 2>$null | Select-String 'Index du paramètre d.alimentation CA actuel|Current AC Power Setting Index')
    $avantVal = if ($lu) { [Convert]::ToInt32(($lu -split ':')[-1].Trim(), 16) } else { $null }
    Memoriser $id @{ sousGroupe = $sousGroupe; reglage = $reglage; valeur = $avantVal }
    powercfg /setacvalueindex SCHEME_CURRENT $sousGroupe $reglage $valeur | Out-Null
    powercfg /setdcvalueindex SCHEME_CURRENT $sousGroupe $reglage $valeur | Out-Null
    powercfg /setactive SCHEME_CURRENT | Out-Null
    Log "alim      $description = $valeur"
}


# ---------------------------------------------------------------------------
# Fichiers du dépôt (outils, images) et lancement de commandes dans leur propre console
# ---------------------------------------------------------------------------
# Rend le chemin local d'un outil du dossier outils/ : copié depuis le clone, ou téléchargé depuis $Depot.
function Outil-Obtenir($nom) {
    $dest = Join-Path $Dossier $nom
    if ($Here -and (Test-Path (Join-Path $Here "outils\$nom"))) { Copy-Item (Join-Path $Here "outils\$nom") $dest -Force; return $dest }
    if (Test-Path $dest) { return $dest }
    try {
        Invoke-WebRequest -Uri "$Depot/outils/$nom" -OutFile $dest -UseBasicParsing -ErrorAction Stop
        Log "téléchargé $nom dans $Dossier"
        return $dest
    } catch { Log "ÉCHEC téléchargement de $nom : $_"; return $null }
}

function Ouvrir($url) { Start-Process $url | Out-Null }

function Image-Ouvrir($nom) {
    if ($Here -and (Test-Path (Join-Path $Here "images\$nom"))) { Ouvrir (Join-Path $Here "images\$nom") } else { Ouvrir "$Depot/images/$nom" }
}

# Lance une commande PowerShell dans une console à part (visible, admin comme nous), qui reste ouverte.
# Sert à tout ce qui est interactif ou bavard : winget, Win11Debloat, WinUtil, DISM.
function Console-Lancer($titre, $commande) {
    $texte = "`$Host.UI.RawUI.WindowTitle = 'bagarre : $titre'; Write-Host ''; Write-Host '  $titre' -ForegroundColor Cyan; Write-Host ''; $commande"
    $enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($texte))
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -EncodedCommand $enc" | Out-Null
    Log "console   $titre"
}

function Winget-Installer($titre, [string[]]$ids) {
    $cmd = ($ids | ForEach-Object { "winget install --id '$_' -e --accept-package-agreements --accept-source-agreements" }) -join '; '
    Console-Lancer $titre $cmd
}
