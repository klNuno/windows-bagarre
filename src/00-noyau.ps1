# ---------------------------------------------------------------------------
# Noyau : où on est, élévation, détection machine, outils d'écriture avec retour arrière.
# ---------------------------------------------------------------------------
$Depot = 'https://raw.githubusercontent.com/klNuno/windows-bagarre/main'
$Version = '2026-09-13'
$ErrorActionPreference = 'Continue'

# État partagé avec les gestionnaires d'événements de la fenêtre. Une table, jamais $script: :
# selon le lancement (-File, "irm | iex", scriptblock) le préfixe $script: ne désigne pas la même portée,
# alors qu'une lecture sans préfixe et une écriture dans cette table marchent dans les trois cas.
# Simulation : quand $Bagarre.Simulation est vrai, les fonctions d'écriture n'écrivent rien et notent dans $Bagarre.Verif
# si la valeur en place est déjà celle visée. C'est ainsi que la fenêtre détecte ce qui est déjà fait.
$Bagarre = @{ Langue = 'fr'; L = $null; ConsoleN = 0; DnsAdapt = $null; DnsResultats = @(); Simulation = $false; Verif = $null; Cartes = @() }

# Lancé depuis un clone (powershell -File bagarre.ps1) : outils et images sont à côté.
# Lancé par "irm ... | iex" : $Here est vide, ils sont téléchargés depuis $Depot au besoin.
$Here = if ($Depuis) { $Depuis } elseif ($PSCommandPath -and (Test-Path (Join-Path (Split-Path -Parent $PSCommandPath) 'outils'))) { Split-Path -Parent $PSCommandPath } else { $null }

# Admin et thread STA (la fenêtre en a besoin). Sinon on se relance élevé, et on rend la main.
# -Liste et -Capture (modes de test) tournent sans admin.
# La relance passe par une copie locale du script (UTF-8 avec BOM, lisible par -File) : pas de "irm | iex" ni de
# fenêtre cachée sur la ligne de commande élevée, Defender classe ce motif en cheval de Troie (Commando.A!ml, vu le 2026-09-13).
$EstAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$EstSta = [Threading.Thread]::CurrentThread.GetApartmentState() -eq 'STA'
if (-not $Liste -and -not $Capture -and -not $Essai -and (-not $EstAdmin -or -not $EstSta)) {
    try {
        $texte = if ($PSCommandPath) { [IO.File]::ReadAllText($PSCommandPath, [Text.Encoding]::UTF8) } else { irm "$Depot/bagarre.ps1" }
        $copie = Join-Path $env:TEMP 'bagarre\bagarre.ps1'
        if (-not (Test-Path (Split-Path $copie))) { New-Item -Path (Split-Path $copie) -ItemType Directory -Force | Out-Null }
        [IO.File]::WriteAllText($copie, ([string]$texte).TrimStart([char]0xFEFF), (New-Object Text.UTF8Encoding $true))
        $arguments = "-NoProfile -ExecutionPolicy Bypass -STA -File `"$copie`""
        if ($Here) { $arguments += " -Depuis `"$Here`"" }
        Start-Process powershell -Verb RunAs -ArgumentList $arguments
        Write-Host "`n  La fenêtre bagarre s'ouvre en administrateur (une console l'accompagne, laisse-la). Tu peux fermer celle-ci.`n" -ForegroundColor Green
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

# Langue de la fenêtre : celle choisie la dernière fois, sinon celle de Windows (français ou anglais).
$LangueFichier = Join-Path $Dossier 'langue.txt'
$Bagarre.Langue = if ((Test-Path $LangueFichier) -and ((Get-Content $LangueFichier -Raw).Trim() -in 'fr', 'en')) { (Get-Content $LangueFichier -Raw).Trim() }
          elseif ((Get-Culture).TwoLetterISOLanguageName -eq 'fr') { 'fr' } else { 'en' }

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
# Âge de l'installation de Windows : au-delà d'un mois la fenêtre propose de se protéger avant de toucher (point de restauration, sauvegarde).
$InstallDate = try { (Get-CimInstance Win32_OperatingSystem).InstallDate } catch { $null }
$InstallJours = if ($InstallDate) { [int]((Get-Date) - $InstallDate).TotalDays } else { 0 }

# ---------------------------------------------------------------------------
# Outils : lire, écrire, mémoriser pour le retour arrière
# ---------------------------------------------------------------------------
$Avant = @{}
if (Test-Path $EtatFichier) {
    $json = Get-Content $EtatFichier -Raw | ConvertFrom-Json
    foreach ($p in $json.PSObject.Properties) { $Avant[$p.Name] = $p.Value }
}

function Log($texte) {
    if ($Bagarre.Simulation) { return }
    $ligne = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $texte
    Add-Content -Path $LogFichier -Value $ligne
    Write-Host "   $texte" -ForegroundColor DarkGray
    if ($Journal) { $Journal.AppendText("$texte`r`n"); $Journal.ScrollToEnd(); Rafraichir }
}

# Laisse la fenêtre se redessiner pendant une action longue (tout tourne sur le thread de la fenêtre).
function Rafraichir {
    if ($Fenetre) { $Fenetre.Dispatcher.Invoke([Action] {}, [Windows.Threading.DispatcherPriority]::Background) }
}

function Memoriser($cle, $valeur) {
    if ($Bagarre.Simulation) { return }
    if (-not $Avant.ContainsKey($cle)) { $Avant[$cle] = $valeur }
}

function SauverEtat {
    $Avant | ConvertTo-Json -Depth 4 | Set-Content -Path $EtatFichier -Encoding UTF8
}

function Reg-Lire($chemin, $nom) {
    try { (Get-ItemProperty -Path $chemin -Name $nom -ErrorAction Stop).$nom } catch { $null }
}

function Reg-Ecrire($chemin, $nom, $valeur, $type = 'DWord') {
    if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add(([string](Reg-Lire $chemin $nom)) -eq [string]$valeur); return }
    $id = "reg|$chemin|$nom"
    Memoriser $id @{ chemin = $chemin; nom = $nom; valeur = (Reg-Lire $chemin $nom); type = $type }
    if (-not (Test-Path $chemin)) { New-Item -Path $chemin -Force | Out-Null }
    New-ItemProperty -Path $chemin -Name $nom -Value $valeur -PropertyType $type -Force | Out-Null
    Log "registre  $chemin\$nom = $valeur"
}

function Reg-Supprimer($chemin, $nom) {
    if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add($null -eq (Reg-Lire $chemin $nom)); return }
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
    if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add($start -eq 4); return }
    Memoriser "svc|$nom" @{ nom = $nom; start = $start }
    if ($svc.Status -eq 'Running') { Stop-Service -Name $nom -Force -ErrorAction SilentlyContinue }
    # Écriture directe du type de démarrage : Set-Service refuse certains services protégés.
    Set-ItemProperty -Path $chemin -Name 'Start' -Value 4 -ErrorAction SilentlyContinue
    Log "service   $nom désactivé ($description)"
}

# Service en démarrage manuel (il ne part plus tout seul, mais reste disponible)
function Service-Manuel($nom, $description) {
    $svc = Get-Service -Name $nom -ErrorAction SilentlyContinue
    if (-not $svc) { return }
    $chemin = "HKLM:\SYSTEM\CurrentControlSet\Services\$nom"
    $start = Reg-Lire $chemin 'Start'
    if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add($start -eq 3); return }
    Memoriser "svc|$nom" @{ nom = $nom; start = $start }
    Set-ItemProperty -Path $chemin -Name 'Start' -Value 3 -ErrorAction SilentlyContinue
    Log "service   $nom en manuel ($description)"
}

function Tache-Couper($chemin, $nom) {
    $t = Get-ScheduledTask -TaskPath $chemin -TaskName $nom -ErrorAction SilentlyContinue
    if (-not $t) { return }
    if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add([string]$t.State -eq 'Disabled'); return }
    Memoriser "task|$chemin$nom" @{ chemin = $chemin; nom = $nom; etat = [string]$t.State }
    Disable-ScheduledTask -TaskPath $chemin -TaskName $nom -ErrorAction SilentlyContinue | Out-Null
    Log "tâche     $chemin$nom désactivée"
}

# Cartes réseau physiques actives (pas les cartes virtuelles VPN / VMware / Bluetooth).
# La liste est gardée après le premier appel : changer une propriété avancée réinitialise la carte, qui n'est plus "Up"
# pendant une ou deux secondes, et les items réseau suivants ne voyaient aucune carte (vu sur le PC du mainteneur le 2026-09-13).
function Cartes-Reseau {
    if ($Bagarre.Cartes.Count -eq 0) {
        $Bagarre.Cartes = @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Bluetooth|Virtual|VMware|Hyper-V|TAP|WireGuard|Tailscale' })
    }
    $Bagarre.Cartes
}

# Attend que la carte soit revenue après une réinitialisation (au plus 15 s), la fenêtre reste vivante pendant ce temps.
function Net-Attendre($carte) {
    for ($i = 0; $i -lt 30; $i++) {
        $a = Get-NetAdapter -Name $carte.Name -ErrorAction SilentlyContinue
        if ($a -and $a.Status -eq 'Up') { return }
        Start-Sleep -Milliseconds 500
        Rafraichir
    }
}

function Net-Liaison-Couper($carte, $composant, $description) {
    $b = Get-NetAdapterBinding -Name $carte.Name -ComponentID $composant -ErrorAction SilentlyContinue
    if (-not $b) { Log "réseau    $($carte.Name) : $description introuvable, ignoré"; return }
    if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add(-not [bool]$b.Enabled); return }
    Memoriser "netb|$($carte.Name)|$composant" @{ carte = $carte.Name; composant = $composant; actif = [bool]$b.Enabled }
    Disable-NetAdapterBinding -Name $carte.Name -ComponentID $composant -ErrorAction SilentlyContinue
    Log "réseau    $($carte.Name) : $description décoché"
}

function Net-Propriete-Regler($carte, $motif, $valeur, $description) {
    $props = Get-NetAdapterAdvancedProperty -Name $carte.Name -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match $motif }
    foreach ($p in $props) {
        $choix = $p.ValidDisplayValues | Where-Object { $_ -match $valeur } | Select-Object -First 1
        if (-not $choix) { continue }   # la propriété n'a pas cette valeur (autre pilote, autre libellé) : rien à faire
        if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add([string]$p.DisplayValue -eq [string]$choix); continue }
        if ([string]$p.DisplayValue -eq [string]$choix) { Log "réseau    $($carte.Name) : $($p.DisplayName) déjà sur $choix"; continue }
        Memoriser "netadv|$($carte.Name)|$($p.RegistryKeyword)" @{ carte = $carte.Name; mot = $p.RegistryKeyword; valeur = [string]$p.RegistryValue }
        Set-NetAdapterAdvancedProperty -Name $carte.Name -RegistryKeyword $p.RegistryKeyword -DisplayValue $choix -ErrorAction SilentlyContinue
        Log "réseau    $($carte.Name) : $($p.DisplayName) = $choix ($description)"
        Net-Attendre $carte
    }
}

# Alias powercfg (SUB_PROCESSOR, PERFBOOSTMODE...) -> GUID, d'après "powercfg /aliases". Un GUID passe tel quel.
function Powercfg-Guid($nom) {
    if ($nom -match '^[0-9a-f]{8}-') { return $nom }
    if (-not $Bagarre.ContainsKey('PowercfgAlias')) {
        $t = @{}
        foreach ($l in (powercfg /aliases 2>$null)) { if ($l -match '^\s*([0-9a-f-]{36})\s+(\S+)') { $t[$Matches[2]] = $Matches[1] } }
        $Bagarre.PowercfgAlias = $t
    }
    if ($Bagarre.PowercfgAlias[$nom]) { $Bagarre.PowercfgAlias[$nom] } else { $nom }
}

# Les réglages cachés (PERFBOOSTMODE, CPMINCORES) ne sortent pas de "powercfg /query" : leur valeur est lue dans le registre
# du plan actif, et si la clé n'existe pas c'est le défaut de Windows (mémorisé comme $null, la restauration supprime la clé).
function Powercfg-Regler($sousGroupe, $reglage, $valeur, $description) {
    $id = "pwr|$sousGroupe|$reglage"
    $plan = ((powercfg /getactivescheme 2>$null) -join ' ') -replace '.*?([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'
    $cle = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\$plan\$(Powercfg-Guid $sousGroupe)\$(Powercfg-Guid $reglage)"
    $lu = (powercfg /query SCHEME_CURRENT $sousGroupe $reglage 2>$null | Select-String 'Index du paramètre d.alimentation CA actuel|Current AC Power Setting Index')
    $avantVal = if ($lu) { [Convert]::ToInt32(($lu -split ':')[-1].Trim(), 16) }
                elseif (Test-Path $cle) { (Get-ItemProperty $cle -ErrorAction SilentlyContinue).ACSettingIndex }
                else { $null }
    if ($Bagarre.Simulation) { [void]$Bagarre.Verif.Add(($null -ne $avantVal) -and ($avantVal -eq [int]$valeur)); return }
    Memoriser $id @{ sousGroupe = $sousGroupe; reglage = $reglage; valeur = $avantVal; cle = $cle }
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

# Les petites images embarquées par build.ps1 ($Logos, base64) en BitmapImage, une seule fois chacune.
$LogoCache = @{}
function Logo-Image($nom) {
    if ($LogoCache.ContainsKey($nom)) { return $LogoCache[$nom] }
    $bi = $null
    if ($Logos[$nom]) {
        try {
            $flux = New-Object IO.MemoryStream (, [Convert]::FromBase64String($Logos[$nom]))
            $bi = New-Object Windows.Media.Imaging.BitmapImage
            $bi.BeginInit(); $bi.StreamSource = $flux; $bi.CacheOption = 'OnLoad'; $bi.EndInit(); $bi.Freeze()
        } catch { $bi = $null }
    }
    $LogoCache[$nom] = $bi
    $bi
}

# Lance une commande PowerShell dans une console à part (visible, admin comme nous), qui reste ouverte.
# Sert à tout ce qui est interactif ou bavard : winget, Win11Debloat, WinUtil, DISM.
# La commande passe par un petit .ps1 dans le dossier bagarre, pas par -EncodedCommand (motif suspect pour Defender).
$Bagarre.ConsoleN = 0
function Console-Lancer($titre, $commande) {
    $Bagarre.ConsoleN++
    $texte = "`$Host.UI.RawUI.WindowTitle = 'bagarre : $titre'`r`nWrite-Host ''`r`nWrite-Host '  $titre' -ForegroundColor Cyan`r`nWrite-Host ''`r`n$commande`r`n"
    $fichier = Join-Path $Dossier ("console-{0}.ps1" -f $Bagarre.ConsoleN)
    [IO.File]::WriteAllText($fichier, $texte, (New-Object Text.UTF8Encoding $true))
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -File `"$fichier`"" | Out-Null
    Log "console   $titre"
}

function Winget-Installer($titre, [string[]]$ids) {
    $cmd = ($ids | ForEach-Object { "winget install --id '$_' -e --accept-package-agreements --accept-source-agreements" }) -join '; '
    Console-Lancer $titre $cmd
}
