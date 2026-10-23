# ---------------------------------------------------------------------------
# Garde-fou : le texte du script collé dans une console, au lieu de la ligne "irm | iex" (un ami l'a copié depuis le
# lien ouvert dans son navigateur, 2026-10-23). La console exécute alors chaque ligne seule : un elseif en début de
# ligne devient une commande inconnue, la langue reste vide et la fenêtre s'ouvre cassée.
# Une ligne collée est seule sur la pile d'appels et son texte est court. "irm | iex" et un scriptblock ajoutent un
# cadre, -File et un collage d'un seul bloc (Ctrl+V dans conhost, ISE) portent le script entier.
# build.ps1 pose ce fichier juste après param, avant toute action : la relance admin partirait aussi en morceaux.
# ---------------------------------------------------------------------------
if ((Get-PSCallStack).Count -le 1 -and "$($MyInvocation.MyCommand.ScriptBlock)".Length -lt 20000) {
    $ligne = 'irm {{DEPOT}} | iex'
    if (-not [Console]::IsInputRedirected) {
        # Le reste du collage attend en deux endroits : la file privée de PSReadLine, qui lit d'avance tout ce qui est
        # disponible (2.0.0, celui de Windows), et le tampon d'entrée de la console. On jette les deux jusqu'à 1,5 s
        # sans touche, sinon la ligne suivante du collage repart dès le retour au prompt. La file est affectée dans le
        # try et pas rendue par lui : rendue, PowerShell l'énumère et $file devient une copie qu'on ne vide jamais.
        $file = $null
        try {
            $bf = [Reflection.BindingFlags]'NonPublic, Static, Instance'
            $prl = 'Microsoft.PowerShell.PSConsoleReadLine' -as [type]
            $file = $prl.GetField('_queuedKeys', $bf).GetValue($prl.GetField('_singleton', $bf).GetValue($null))
        } catch {}
        $calme = [Diagnostics.Stopwatch]::StartNew(); $total = [Diagnostics.Stopwatch]::StartNew()
        while ($calme.ElapsedMilliseconds -lt 1500 -and $total.Elapsed.TotalSeconds -lt 30) {
            if (($null -ne $file -and $file.Count) -or [Console]::KeyAvailable) {
                if ($null -ne $file) { $file.Clear() }
                $Host.UI.RawUI.FlushInputBuffer(); $calme.Restart()
            } else { Start-Sleep -Milliseconds 100 }
        }
    }
    # Le presse-papiers contient encore le script : un deuxième Ctrl+V referait la même erreur. tests\colle.ps1 pose
    # BAGARRE_TEST pour ne pas écraser celui du mainteneur.
    if (-not $env:BAGARRE_TEST) { try { Set-Clipboard $ligne } catch {} }
    Write-Host ''
    if ((Get-UICulture).TwoLetterISOLanguageName -eq 'fr') {
        Write-Host '  La console a reçu le script lui-même et le lance ligne par ligne, ce qui le casse.' -ForegroundColor Red
        Write-Host '  Colle seulement cette ligne, elle est déjà dans ton presse-papiers :'
    } else {
        Write-Host '  The console received the script itself and runs it line by line, which breaks it.' -ForegroundColor Red
        Write-Host '  Paste only this line, it is already in your clipboard:'
    }
    Write-Host "  $ligne`n" -ForegroundColor Yellow
    # Script envoyé sur l'entrée standard ("irm | powershell") : rien à vider, on quitte avant la ligne suivante.
    if ([Console]::IsInputRedirected) { exit 1 }
}
