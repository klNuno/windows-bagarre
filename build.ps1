#Requires -Version 5.1
# build.ps1 : assemble src/*.ps1 et textes/*.txt en un seul bagarre.ps1 (UTF-8 sans BOM), celui que "irm | iex" telecharge.
# A lancer apres chaque modification d'une source. bagarre.ps1 est commite et jamais edite a la main.
$ErrorActionPreference = 'Stop'
$racine = Split-Path -Parent $MyInvocation.MyCommand.Path
$utf8 = New-Object Text.UTF8Encoding $false   # sans BOM : voir l'en-tete du fichier genere
$sb = New-Object Text.StringBuilder
[void]$sb.AppendLine('#Requires -Version 5.1')
[void]$sb.AppendLine('param([switch]$Liste, [string]$Capture, [switch]$Essai, [switch]$Vieux, [switch]$Amd, [string]$Depuis)  # -Liste : le catalogue en texte, sans rien appliquer. -Capture dossier : chaque onglet en PNG, sans fenetre. -Essai : ouvre la fenetre invisible 1,5 s et note son etat. -Vieux : force l avertissement "installation pas recente". -Amd : simule une carte AMD dediee. -Depuis : dossier du clone (pose par la relance admin).')
[void]$sb.AppendLine('# bagarre.ps1 : GENERE par build.ps1 a partir de src/ et textes/. Ne pas editer ce fichier, edite les sources.')
[void]$sb.AppendLine('# UTF-8 SANS BOM : "irm" garde le BOM dans le texte et PowerShell le prend pour une commande. Pour le lancer en local :')
[void]$sb.AppendLine('#   & ([scriptblock]::Create([IO.File]::ReadAllText("bagarre.ps1", [Text.Encoding]::UTF8))) -Liste')
[void]$sb.AppendLine('')

$noyau = [IO.File]::ReadAllText((Join-Path $racine 'src\00-noyau.ps1'), [Text.Encoding]::UTF8)
$depot = [regex]::Match($noyau, "(?m)^\`$Depot = '([^']+)'").Groups[1].Value
if (-not $depot) { throw 'Depot introuvable dans src/00-noyau.ps1' }

# textes/<langue>/<nom>.txt -> $Textes[<langue>][<nom>]
[void]$sb.AppendLine('$Textes = @{}')
foreach ($d in Get-ChildItem (Join-Path $racine 'textes') -Directory | Sort-Object Name) {
    [void]$sb.AppendLine("`$Textes['$($d.Name)'] = @{}")
    foreach ($f in Get-ChildItem $d.FullName -Filter *.txt | Sort-Object Name) {
        $t = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8).TrimEnd() -replace '\{\{DEPOT\}\}', $depot
        if ($t -match "(?m)^'@") { throw "$($d.Name)/$($f.Name) contient une ligne qui commence par '@, interdit dans une here-string" }
        [void]$sb.AppendLine("`$Textes['$($d.Name)']['$($f.BaseName)'] = @'")
        [void]$sb.AppendLine($t)
        [void]$sb.AppendLine("'@")
    }
}
# images/logos/*.png et images/stop-it.gif -> $Logos[<nom>] en base64 (petites images, decodees en BitmapImage par la fenetre)
[void]$sb.AppendLine('$Logos = @{}')
$images = @(Get-ChildItem (Join-Path $racine 'images\logos') -Filter *.png | Sort-Object Name) + @(Get-Item (Join-Path $racine 'images\stop-it.gif'))
foreach ($f in $images) {
    [void]$sb.AppendLine("`$Logos['$($f.BaseName)'] = '$([Convert]::ToBase64String([IO.File]::ReadAllBytes($f.FullName)))'")
}
foreach ($f in Get-ChildItem (Join-Path $racine 'src') -Filter *.ps1 | Sort-Object Name) {
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("# ===== $($f.Name) =====")
    [void]$sb.AppendLine([IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8).TrimEnd())
}

$sortie = Join-Path $racine 'bagarre.ps1'
[IO.File]::WriteAllText($sortie, $sb.ToString(), $utf8)

# ParseInput sur le texte en memoire : ParseFile lirait le fichier sans BOM en ANSI sur PowerShell 5.1
$erreurs = $null
[void][Management.Automation.Language.Parser]::ParseInput($sb.ToString(), [ref]$null, [ref]$erreurs)
if ($erreurs) {
    $erreurs | ForEach-Object { Write-Host "ERREUR ligne $($_.Extent.StartLineNumber) : $($_.Message)" -ForegroundColor Red }
    exit 1
}
Write-Host "bagarre.ps1 : $((Get-Content $sortie).Count) lignes, depot $depot"
