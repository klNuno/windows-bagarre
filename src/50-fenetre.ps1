# ---------------------------------------------------------------------------
# Mode -Liste : le catalogue en texte, sans rien appliquer (test)
# ---------------------------------------------------------------------------
if ($Liste) {
    Write-Host "Machine : $Machine"
    $Items | ForEach-Object { '{0,-24} {1} {2}' -f $_.Id, $(if ($_.Coche) { '[x]' } else { '[ ]' }), $_.Titre }
    return
}

# ---------------------------------------------------------------------------
# Textes de l'interface, français et anglais. Les tutos sont dans $Textes, les items dans le catalogue
# (français) et $TraductionsEn (anglais).
# ---------------------------------------------------------------------------
$PagesNoms = 'Accueil', 'Installation', 'Facile', 'Optis', 'Nvidia', 'Dur', 'Maintenance', 'Dns', 'Audit'
$UI = @{
    fr = @{
        nav      = 'Accueil', '1. Installation', '2. Facile', '3. Le script à cocher', '4. NVIDIA', '5. Dur', '6. Maintenance', '7. DNS', '8. Audit IA'
        duree    = '', '30 min', '15 min', '10 min', '15 min', '20 min', 'plus tard', '1 min', '10 min'
        resume   = '', 'Windows propre, mises à jour, pilotes', 'débloat en deux clics, DirectX, Visual C++, tes applis', 'services, vie privée, jeu, carte réseau, confort', 'pilote nu, ancien Panneau de configuration', 'tu lis tout avant de toucher', 'nettoyer et vérifier, des mois après', 'le résolveur le plus rapide depuis chez toi', 'une IA vérifie ton PC et trouve ce qui manque'
        titres   = @{
            Accueil = 'Tu viens de réinstaller Windows 11 ?'; Installation = '1. Installation (30 min) : Windows propre, mises à jour, pilotes'
            Facile = '2. Facile (15 min) : débloat en deux clics, DirectX, Visual C++, tes applis'; Optis = '3. Le script à cocher (10 min)'
            Nvidia = "4. NVIDIA (15 min) : le pilote nu, puis l'ancien Panneau de configuration"; Dur = '5. Dur (20 min) : lis tout avant de toucher'
            Maintenance = '6. Maintenance : quand le PC a vécu'; Dns = '7. DNS : qui répond le plus vite depuis chez toi ?'
            Audit = '8. Audit IA (10 min) : une IA vérifie ton PC et trouve ce qui manque'
        }
        intros   = @{
            Accueil = "Les étapes, dans l'ordre. Clique sur une étape pour y aller, ou sur Étape suivante en bas."
            Installation = 'Les boutons lancent les commandes du tuto dans une console à part. Le reste se fait à la main, dans l ordre.'
            Facile = "Les deux boutons jaunes ouvrent chaque outil dans sa propre console (ils demandent avant chaque groupe). Les boutons gris installent via winget."
            Optis = "Une case cochée = appliqué quand tu cliques le bouton jaune. Décochée = pas touché. Les cases cochées d'office sont sûres pour tout PC. Passe la souris sur une ligne : le Pourquoi et ce que tu perds s'affichent à droite. Tu ne comprends pas une ligne, tu ne la coches pas. Tout remettre restaure les valeurs d'avant. Redémarre après."
            Nvidia = 'NVCleanstall installe le pilote nu, le Panneau vient du Store. Les captures montrent quoi cocher.'
            Dur = "Une chose à la fois, tu joues 30 minutes, tu regardes RivaTuner, tu gardes ou tu remets."
            Maintenance = "Des mois après l'installation. Les boutons gris installent l'outil, les autres lancent la commande."
            Dns = 'Le DNS transforme un nom (youtube.com) en adresse IP. Un DNS lent ajoute quelques dizaines de ms à CHAQUE nouveau site ou serveur de jeu contacté. Le test résout 6 noms courants sur chaque serveur, 3 fois, et garde la médiane. Une trentaine de secondes, la fenêtre ne répond pas pendant ce temps.'
            Audit = 'Trois boutons, dans l ordre : le rapport, le prompt, et tu colles les deux dans ton IA.'
        }
        precedent = 'Étape précédente'; suivant = 'Étape suivante'; journal = 'Journal : ce qui vient de se passer'
        survole = 'Passe la souris sur une case.'; pourquoi = 'Pourquoi'; perds = 'Ce que tu perds'; rien = 'Rien de notable.'
        appliquerN = 'Appliquer les {0} cases cochées'; appliquer0 = 'Appliquer (rien de coché)'; appliquer1 = 'Appliquer la case cochée'
        applisTitre = "Tes applis, installées d'un coup par winget (coche, puis le bouton) :"
        reseauTitre = 'Carte réseau à la main'
        rienCoche = 'Rien de coché.'; confirmAppliquer = "Appliquer {0} réglages ?`n`nL'état d'avant est sauvé dans {1}, le bouton Tout remettre le restaure."
        termine = 'Terminé. Redémarre le PC pour que tout prenne effet.'; rienRestaurer = 'Rien à restaurer : aucun réglage appliqué sur ce PC.'
        confirmRestaurer = 'Remettre les {0} réglages comme avant ?'; restaure = 'Restauré. Redémarre le PC.'
        aucuneCarte = 'Aucune carte réseau active trouvée.'; dnsCarte = 'Carte : {0} ({1}). DNS actuel : {2} (souvent ta box).'
        dnsEnCours = 'Test DNS en cours...'; dnsFini = 'Test terminé. Sélectionne une ligne puis "Utiliser le DNS sélectionné", ou ne change rien.'
        dnsSelection = 'Sélectionne une ligne dans la liste.'
        collecte = 'Collecte en cours, environ 30 secondes...'; promptCopie = 'Prompt copié dans le presse-papiers. Colle-le dans ton IA avec rapport-pc.txt.'
        pasRapport = "Pas encore de rapport : bouton 1 d'abord."; pasJournal = 'Pas encore de journal.'; aucuneAppli = 'Aucune appli cochée.'
        dejaApplique = '{0} réglages déjà appliqués sur ce PC (bagarre-avant.json). Tout remettre les restaure.'
        ouverte = 'Fenêtre ouverte. Si tu ne la vois pas, regarde la barre des tâches : elle peut être derrière ce terminal.'
        measureTitre = 'MeasureSleep : attendu environ 0,5 ms, Ctrl+C pour arrêter'
    }
    en = @{
        nav      = 'Home', '1. Install', '2. Easy', '3. The checkbox script', '4. NVIDIA', '5. Hard', '6. Maintenance', '7. DNS', '8. AI audit'
        duree    = '', '30 min', '15 min', '10 min', '15 min', '20 min', 'later', '1 min', '10 min'
        resume   = '', 'clean Windows, updates, drivers', 'debloat in two clicks, DirectX, Visual C++, your apps', 'services, privacy, gaming, network card, comfort', 'bare driver, classic Control Panel', 'read everything before touching anything', 'clean and check, months later', 'the fastest resolver from your place', 'an AI checks your PC and finds what is missing'
        titres   = @{
            Accueil = 'Just reinstalled Windows 11?'; Installation = '1. Install (30 min): clean Windows, updates, drivers'
            Facile = '2. Easy (15 min): debloat in two clicks, DirectX, Visual C++, your apps'; Optis = '3. The checkbox script (10 min)'
            Nvidia = '4. NVIDIA (15 min): the bare driver, then the classic Control Panel'; Dur = '5. Hard (20 min): read everything before touching anything'
            Maintenance = '6. Maintenance: when the PC has lived a while'; Dns = '7. DNS: who answers fastest from your place?'
            Audit = '8. AI audit (10 min): an AI checks your PC and finds what is missing'
        }
        intros   = @{
            Accueil = 'The steps, in order. Click a step to open it, or use Next step at the bottom.'
            Installation = 'The buttons run the commands from the guide in a separate console. The rest is done by hand, in order.'
            Facile = 'The two yellow buttons open each tool in its own console (they ask before each group). The grey buttons install through winget.'
            Optis = 'A checked box = applied when you click the yellow button. Unchecked = untouched. The boxes checked by default are safe on any PC. Hover a line: the Why and what you lose show up on the right. If you do not understand a line, do not check it. Restore everything puts the previous values back. Reboot afterwards.'
            Nvidia = 'NVCleanstall installs the bare driver, the Control Panel comes from the Store. The screenshots show what to tick.'
            Dur = 'One thing at a time, play 30 minutes, watch RivaTuner, keep it or put it back.'
            Maintenance = 'Months after the install. Grey buttons install the tool, the others run the command.'
            Dns = 'DNS turns a name (youtube.com) into an IP address. A slow DNS adds tens of ms to EVERY new site or game server you contact. The test resolves 6 common names on each server, 3 times, and keeps the median. About thirty seconds, the window does not respond meanwhile.'
            Audit = 'Three buttons, in order: the report, the prompt, then paste both into your AI.'
        }
        precedent = 'Previous step'; suivant = 'Next step'; journal = 'Log: what just happened'
        survole = 'Hover a checkbox.'; pourquoi = 'Why'; perds = 'What you lose'; rien = 'Nothing notable.'
        appliquerN = 'Apply the {0} checked boxes'; appliquer0 = 'Apply (nothing checked)'; appliquer1 = 'Apply the checked box'
        applisTitre = 'Your apps, installed in one go by winget (tick, then the button):'
        reseauTitre = 'Network card by hand'
        rienCoche = 'Nothing checked.'; confirmAppliquer = "Apply {0} settings?`n`nThe previous state is saved in {1}, the Restore button puts it back."
        termine = 'Done. Reboot the PC so everything takes effect.'; rienRestaurer = 'Nothing to restore: no setting applied on this PC.'
        confirmRestaurer = 'Put the {0} settings back as they were?'; restaure = 'Restored. Reboot the PC.'
        aucuneCarte = 'No active network card found.'; dnsCarte = 'Card: {0} ({1}). Current DNS: {2} (usually your router).'
        dnsEnCours = 'DNS test running...'; dnsFini = 'Test done. Select a line then "Use the selected DNS", or change nothing.'
        dnsSelection = 'Select a line in the list.'
        collecte = 'Collecting, about 30 seconds...'; promptCopie = 'Prompt copied to the clipboard. Paste it into your AI along with rapport-pc.txt.'
        pasRapport = 'No report yet: button 1 first.'; pasJournal = 'No log yet.'; aucuneAppli = 'No app ticked.'
        dejaApplique = '{0} settings already applied on this PC (bagarre-avant.json). Restore puts them back.'
        ouverte = 'Window open. If you do not see it, check the taskbar: it may be behind this terminal.'
        measureTitre = 'MeasureSleep: about 0.5 ms expected, Ctrl+C to stop'
    }
}
$S.L = $UI[$S.Langue]

# Titre et explications d'un item dans la langue courante
function Item-Titre($it) { if ($S.Langue -eq 'en' -and $TraductionsEn[$it.Id]) { $TraductionsEn[$it.Id].Titre } else { $it.Titre } }
function Item-Pourquoi($it) { if ($S.Langue -eq 'en' -and $TraductionsEn[$it.Id]) { $TraductionsEn[$it.Id].Pourquoi } else { $it.Pourquoi } }
function Item-Attention($it) { if ($S.Langue -eq 'en' -and $TraductionsEn[$it.Id]) { $TraductionsEn[$it.Id].Attention } else { $it.Attention } }

# ---------------------------------------------------------------------------
# Les boutons de chaque page : libellé et bulle d'aide dans les deux langues, et ce qu'ils font.
# ---------------------------------------------------------------------------
$Boutons = [ordered]@{
    Accueil = @(
        @{ Id = 'BtnRestaurerAccueil'; T = @{ fr = 'Tout remettre comme avant'; en = 'Restore everything' }; Tip = @{ fr = 'Remet chaque réglage du script à cocher à sa valeur d avant. Le DNS aussi.'; en = 'Puts every setting of the checkbox script back to its previous value. DNS too.' }; Action = { Restaurer-Demander } }
        @{ Id = 'BtnJournalAccueil'; T = @{ fr = 'Ouvrir bagarre.log'; en = 'Open bagarre.log' }; Tip = @{ fr = 'Le détail de tout ce qui a été modifié sur ce PC.'; en = 'The detail of everything changed on this PC.' }; Action = { Journal-Ouvrir } }
    )
    Installation = @(
        @{ Id = 'BtnFsutil'; T = @{ fr = 'fsutil 8dot3name set 1'; en = 'fsutil 8dot3name set 1' }; Tip = @{ fr = 'Coupe la génération des noms courts PROGRA~1 sur les disques neufs. Juste après le premier bureau, avant d installer quoi que ce soit.'; en = 'Stops generating PROGRA~1 short names on new disks. Right after the first desktop, before installing anything.' }; Action = { Console-Lancer 'fsutil 8dot3name set 1' 'fsutil 8dot3name set 1; fsutil 8dot3name query' } }
        @{ Id = 'BtnWindowsUpdate'; T = @{ fr = 'Ouvrir Windows Update'; en = 'Open Windows Update' }; Tip = @{ fr = 'Tu cliques jusqu à ce qu il n y ait plus rien, redémarre entre chaque série.'; en = 'Click until nothing is left, reboot between each batch.' }; Action = { Ouvrir 'ms-settings:windowsupdate' } }
        @{ Id = 'BtnSnappy'; T = @{ fr = 'Snappy Driver Installer Origin (winget)'; en = 'Snappy Driver Installer Origin (winget)' }; Tip = @{ fr = 'Dernier recours pour un pilote introuvable. Ne coche que ce qui manque.'; en = 'Last resort for a missing driver. Only tick what is missing.' }; Action = { Winget-Installer 'Snappy Driver Installer Origin' 'GlennDelahoy.SnappyDriverInstallerOrigin' } }
    )
    Facile = @(
        @{ Id = 'BtnDebloat'; Principal = $true; T = @{ fr = 'Win11Debloat'; en = 'Win11Debloat' }; Tip = @{ fr = 'Retire les applis sponsorisées, Copilot, les pubs, la télémétrie. Demande avant chaque groupe. Mode par défaut.'; en = 'Removes sponsored apps, Copilot, ads, telemetry. Asks before each group. Default mode.' }; Action = { Console-Lancer 'Win11Debloat' '& ([scriptblock]::Create((irm "https://debloat.raphi.re/")))' } }
        @{ Id = 'BtnWinUtil'; Principal = $true; T = @{ fr = 'WinUtil (Chris Titus)'; en = 'WinUtil (Chris Titus)' }; Tip = @{ fr = 'Onglet Install pour tes programmes, onglet Tweaks preset Standard seulement.'; en = 'Install tab for your programs, Tweaks tab with the Standard preset only.' }; Action = { Console-Lancer 'WinUtil (Chris Titus)' 'irm https://christitus.com/win | iex' } }
        @{ Id = 'BtnDirectX'; T = @{ fr = 'DirectX (winget)'; en = 'DirectX (winget)' }; Tip = @{ fr = 'Les vieilles librairies DirectX 9 que les anciens jeux réclament.'; en = 'The old DirectX 9 libraries older games ask for.' }; Action = { Winget-Installer 'DirectX' 'Microsoft.DirectX' } }
        @{ Id = 'BtnVcredist'; T = @{ fr = 'Visual C++ 2005 à 2022 (winget)'; en = 'Visual C++ 2005 to 2022 (winget)' }; Tip = @{ fr = 'Sans elles un jeu plante avec "VCRUNTIME140.dll introuvable".'; en = 'Without them a game crashes with "VCRUNTIME140.dll not found".' }; Action = { $ids = foreach ($an in '2005', '2008', '2010', '2012', '2013', '2015+') { "Microsoft.VCRedist.$an.x86"; "Microsoft.VCRedist.$an.x64" }; Winget-Installer 'Visual C++ 2005-2022' $ids } }
    )
    Optis = @(
        @{ Id = 'BtnAppliquer'; Principal = $true; T = @{ fr = 'Appliquer'; en = 'Apply' }; Tip = @{ fr = 'Applique les cases cochées, après confirmation. L état d avant est sauvé.'; en = 'Applies the checked boxes, after confirmation. The previous state is saved.' }; Action = { Appliquer-Demander } }
        @{ Id = 'BtnRestaurer'; T = @{ fr = 'Tout remettre comme avant'; en = 'Restore everything' }; Tip = @{ fr = 'Remet chaque réglage à sa valeur d avant, DNS compris.'; en = 'Puts every setting back to its previous value, DNS included.' }; Action = { Restaurer-Demander } }
        @{ Id = 'BtnDefaut'; T = @{ fr = 'Cases par défaut'; en = 'Default boxes' }; Tip = @{ fr = 'Recoche exactement les cases sûres, décoche le reste.'; en = 'Re-ticks exactly the safe boxes, unticks the rest.' }; Action = { foreach ($id in $Cases.Keys) { $Cases[$id].IsChecked = $Defauts[$id] } } }
        @{ Id = 'BtnReseau'; T = @{ fr = 'Carte réseau à la main (tuto)'; en = 'Network card by hand (guide)' }; Tip = @{ fr = 'Le groupe Carte réseau fait tout seul. Ce tuto sert si tu veux vérifier ou le faire à la main.'; en = 'The Network card group does it all. This guide is for checking or doing it by hand.' }; Action = { Opti-Montrer $S.L.reseauTitre $Textes[$S.Langue]['reseau'] $null } }
        @{ Id = 'BtnImgProtocoles'; T = @{ fr = 'Capture : protocoles'; en = 'Screenshot: protocols' }; Tip = @{ fr = 'La liste des protocoles de la carte, ce qu on décoche.'; en = 'The card protocol list, what gets unticked.' }; Action = { Image-Ouvrir 'reseau-protocoles.png' } }
        @{ Id = 'BtnImgAvance'; T = @{ fr = 'Capture : onglet Avancé'; en = 'Screenshot: Advanced tab' }; Tip = @{ fr = 'L onglet Avancé du pilote réseau.'; en = 'The Advanced tab of the network driver.' }; Action = { Image-Ouvrir 'reseau-avance.png' } }
        @{ Id = 'BtnJournal'; T = @{ fr = 'Ouvrir bagarre.log'; en = 'Open bagarre.log' }; Tip = @{ fr = 'Le détail de tout ce qui a été modifié, avec les valeurs d avant.'; en = 'The detail of everything changed, with the previous values.' }; Action = { Journal-Ouvrir } }
    )
    Nvidia = @(
        @{ Id = 'BtnNvclean'; Principal = $true; T = @{ fr = 'NVCleanstall (winget)'; en = 'NVCleanstall (winget)' }; Tip = @{ fr = 'Installe le pilote NVIDIA nu, sans NVIDIA App. Coche comme sur la capture.'; en = 'Installs the bare NVIDIA driver, without the NVIDIA App. Tick as on the screenshot.' }; Action = { Winget-Installer 'NVCleanstall' 'TechPowerUp.NVCleanstall' } }
        @{ Id = 'BtnPanneau'; T = @{ fr = 'Panneau de configuration NVIDIA (Store)'; en = 'NVIDIA Control Panel (Store)' }; Tip = @{ fr = 'L ancien Panneau, depuis le Store. À refaire après chaque installation propre du pilote.'; en = 'The classic Control Panel, from the Store. Redo it after every clean driver install.' }; Action = { Console-Lancer 'NVIDIA Control Panel' 'winget install --id 9NF8H0H7WMLT --source msstore --accept-package-agreements --accept-source-agreements' } }
        @{ Id = 'BtnAfterburner'; T = @{ fr = 'MSI Afterburner + RivaTuner (winget)'; en = 'MSI Afterburner + RivaTuner (winget)' }; Tip = @{ fr = 'Pas pour overclocker : pour VOIR le temps d image et poser un cap de FPS.'; en = 'Not for overclocking: to SEE frame times and set an FPS cap.' }; Action = { Winget-Installer 'MSI Afterburner + RivaTuner' 'Guru3D.Afterburner', 'Guru3D.RTSS' } }
        @{ Id = 'BtnInspector'; T = @{ fr = 'NVIDIA Profile Inspector (winget)'; en = 'NVIDIA Profile Inspector (winget)' }; Tip = @{ fr = 'Ansel off, CUDA Force P2 State off. Rien d autre sans savoir.'; en = 'Ansel off, CUDA Force P2 State off. Nothing else unless you know.' }; Action = { Winget-Installer 'NVIDIA Profile Inspector' 'Orbmu2k.nvidiaProfileInspector' } }
        @{ Id = 'BtnImgNvclean'; T = @{ fr = 'Capture : NVCleanstall'; en = 'Screenshot: NVCleanstall' }; Tip = @{ fr = 'Les cases à cocher dans NVCleanstall (sauf MPO).'; en = 'The boxes to tick in NVCleanstall (except MPO).' }; Action = { Image-Ouvrir 'nvcleanstall.png' } }
        @{ Id = 'BtnImgPanneau'; T = @{ fr = 'Capture : Panneau NVIDIA'; en = 'Screenshot: NVIDIA Control Panel' }; Tip = @{ fr = 'Les réglages 3D globaux.'; en = 'The global 3D settings.' }; Action = { Image-Ouvrir 'panneau-nvidia.png' } }
    )
    Dur = @(
        @{ Id = 'BtnIslc'; T = @{ fr = 'ISLC (winget)'; en = 'ISLC (winget)' }; Tip = @{ fr = '16 Go de RAM et des jeux récents seulement.'; en = '16 GB of RAM and recent games only.' }; Action = { Winget-Installer 'ISLC' 'Wagnardsoft.ISLC' } }
        @{ Id = 'BtnCompact'; T = @{ fr = 'CompactGUI (winget)'; en = 'CompactGUI (winget)' }; Tip = @{ fr = 'Compression NTFS des vieux jeux 2D uniquement.'; en = 'NTFS compression for old 2D games only.' }; Action = { Winget-Installer 'CompactGUI' 'IridiumIO.CompactGUI' } }
        @{ Id = 'BtnAutoGpu'; T = @{ fr = 'AutoGpuAffinity (dépôt)'; en = 'AutoGpuAffinity (repo)' }; Tip = @{ fr = 'Ouvre le dépôt GitHub. Long (1 h), sur un PC déjà stable.'; en = 'Opens the GitHub repo. Long (1 h), on an already stable PC.' }; Action = { Ouvrir 'https://github.com/valleyofdoom/AutoGpuAffinity' } }
        @{ Id = 'BtnTimerDepot'; T = @{ fr = 'TimerResolution (dépôt)'; en = 'TimerResolution (repo)' }; Tip = @{ fr = 'Le code source de SetTimerResolution et MeasureSleep.'; en = 'The source code of SetTimerResolution and MeasureSleep.' }; Action = { Ouvrir 'https://github.com/valleyofdoom/TimerResolution' } }
    )
    Maintenance = @(
        @{ Id = 'BtnMeasure'; Principal = $true; T = @{ fr = 'MeasureSleep (vérifier le timer)'; en = 'MeasureSleep (check the timer)' }; Tip = @{ fr = 'Attendu environ 0,5 ms après le script. 1 ms ou 15,6 ms : tuto Dur, point 1.'; en = 'About 0.5 ms expected after the script. 1 ms or 15.6 ms: Hard guide, point 1.' }; Action = { $exe = Outil-Obtenir 'MeasureSleep.exe'; if ($exe) { Console-Lancer $S.L.measureTitre "& '$exe'" } } }
        @{ Id = 'BtnCleanmgr'; T = @{ fr = 'Nettoyage de disque (cleanmgr)'; en = 'Disk Cleanup (cleanmgr)' }; Tip = @{ fr = 'Nettoyer les fichiers système : anciennes mises à jour, corbeille.'; en = 'Clean up system files: old updates, recycle bin.' }; Action = { Start-Process cleanmgr | Out-Null; Log 'console   cleanmgr' } }
        @{ Id = 'BtnDismAnalyse'; T = @{ fr = 'DISM : analyser WinSxS'; en = 'DISM: analyze WinSxS' }; Tip = @{ fr = 'Dit s il y a quelque chose à nettoyer.'; en = 'Says whether there is something to clean.' }; Action = { Console-Lancer 'DISM AnalyzeComponentStore' 'Dism /Online /Cleanup-Image /AnalyzeComponentStore' } }
        @{ Id = 'BtnDismNettoyer'; T = @{ fr = 'DISM : nettoyer WinSxS'; en = 'DISM: clean WinSxS' }; Tip = @{ fr = 'Jamais /ResetBase : tu perdrais la désinstallation des mises à jour.'; en = 'Never /ResetBase: you would lose update uninstall.' }; Action = { Console-Lancer 'DISM StartComponentCleanup' 'Dism /Online /Cleanup-Image /StartComponentCleanup' } }
        @{ Id = 'BtnTrim'; T = @{ fr = 'TRIM du disque système'; en = 'TRIM the system disk' }; Tip = @{ fr = 'Optimize-Volume -ReTrim. L Assistant de stockage le fait déjà tous les mois.'; en = 'Optimize-Volume -ReTrim. Storage Sense already does it monthly.' }; Action = { Console-Lancer 'TRIM' "Optimize-Volume -DriveLetter $($env:SystemDrive[0]) -ReTrim -Verbose" } }
        @{ Id = 'BtnAutoruns'; T = @{ fr = 'Autoruns (winget)'; en = 'Autoruns (winget)' }; Tip = @{ fr = 'Tout ce qui se lance au démarrage. Décoche, ne supprime pas.'; en = 'Everything that starts with Windows. Untick, do not delete.' }; Action = { Winget-Installer 'Autoruns' 'Microsoft.Sysinternals.Autoruns' } }
        @{ Id = 'BtnGeek'; T = @{ fr = 'Geek Uninstaller (winget)'; en = 'Geek Uninstaller (winget)' }; Tip = @{ fr = 'Désinstalle proprement et enlève les restes.'; en = 'Uninstalls cleanly and removes leftovers.' }; Action = { Winget-Installer 'Geek Uninstaller' 'GeekUninstaller.GeekUninstaller' } }
        @{ Id = 'BtnRapr'; T = @{ fr = 'DriverStore Explorer (winget)'; en = 'DriverStore Explorer (winget)' }; Tip = @{ fr = 'Supprime les vieux pilotes NVIDIA empilés (plusieurs Go).'; en = 'Removes stacked old NVIDIA drivers (several GB).' }; Action = { Winget-Installer 'DriverStore Explorer' 'lostindark.DriverStoreExplorer' } }
        @{ Id = 'BtnBleach'; T = @{ fr = 'BleachBit (winget)'; en = 'BleachBit (winget)' }; Tip = @{ fr = 'Caches navigateurs, logs. Jamais "Free disk space" ni "Memory".'; en = 'Browser caches, logs. Never "Free disk space" nor "Memory".' }; Action = { Winget-Installer 'BleachBit' 'BleachBit.BleachBit' } }
        @{ Id = 'BtnCrystal'; T = @{ fr = 'CrystalDiskInfo (winget)'; en = 'CrystalDiskInfo (winget)' }; Tip = @{ fr = 'Santé et température des disques.'; en = 'Disk health and temperature.' }; Action = { Winget-Installer 'CrystalDiskInfo' 'CrystalDewWorld.CrystalDiskInfo' } }
        @{ Id = 'BtnFan'; T = @{ fr = 'FanControl (winget)'; en = 'FanControl (winget)' }; Tip = @{ fr = 'Les ventilos, sans la suite constructeur.'; en = 'Fans, without the vendor suite.' }; Action = { Winget-Installer 'FanControl' 'Rem0o.FanControl' } }
        @{ Id = 'BtnRgb'; T = @{ fr = 'OpenRGB (winget)'; en = 'OpenRGB (winget)' }; Tip = @{ fr = 'Les LED, sans la suite constructeur.'; en = 'LEDs, without the vendor suite.' }; Action = { Winget-Installer 'OpenRGB' 'OpenRGB.OpenRGB' } }
        @{ Id = 'BtnDdu'; T = @{ fr = 'DDU (winget)'; en = 'DDU (winget)' }; Tip = @{ fr = 'Seulement quand tu changes de marque de carte graphique.'; en = 'Only when you switch graphics card brand.' }; Action = { Winget-Installer 'Display Driver Uninstaller' 'Wagnardsoft.DisplayDriverUninstaller' } }
        @{ Id = 'BtnCapframe'; T = @{ fr = 'CapFrameX + PresentMon (winget)'; en = 'CapFrameX + PresentMon (winget)' }; Tip = @{ fr = 'Mesurer avant / après : médiane, 1 % low, p99.'; en = 'Measure before / after: median, 1% low, p99.' }; Action = { Winget-Installer 'CapFrameX + PresentMon' 'CXWorld.CapFrameX', 'Intel.PresentMon' } }
    )
    Dns = @(
        @{ Id = 'BtnDnsTester'; Principal = $true; T = @{ fr = 'Tester les DNS'; en = 'Test the DNS servers' }; Tip = @{ fr = 'Une trentaine de secondes.'; en = 'About thirty seconds.' }; Action = { Dns-Tester } }
        @{ Id = 'BtnDnsAppliquer'; T = @{ fr = 'Utiliser le DNS sélectionné'; en = 'Use the selected DNS' }; Tip = @{ fr = 'Sur la carte testée. Tout remettre le rend.'; en = 'On the tested card. Restore puts it back.' }; Action = { $i = $C.DnsListe.SelectedIndex; if ($i -lt 0) { Log $S.L.dnsSelection; return }; Dns-Appliquer $S.DnsAdapt $S.DnsResultats[$i] } }
    )
    Audit = @(
        @{ Id = 'BtnCollecter'; Principal = $true; T = @{ fr = '1. Collecter le rapport (30 s, ne modifie rien)'; en = '1. Collect the report (30 s, changes nothing)' }; Tip = @{ fr = 'Écrit rapport-pc.txt et AUDIT.txt dans bagarre-audit sur le Bureau, et ouvre le dossier.'; en = 'Writes rapport-pc.txt and AUDIT.txt into bagarre-audit on the Desktop, and opens the folder.' }; Action = { Audit-Collecter } }
        @{ Id = 'BtnPrompt'; T = @{ fr = "2. Copier le prompt d'audit"; en = '2. Copy the audit prompt' }; Tip = @{ fr = 'Dans le presse-papiers, à coller dans ton IA.'; en = 'To the clipboard, paste it into your AI.' }; Action = { [Windows.Clipboard]::SetText($Textes[$S.Langue]['audit-prompt']); Log $S.L.promptCopie } }
        @{ Id = 'BtnDossierAudit'; T = @{ fr = 'Ouvrir le dossier du rapport'; en = 'Open the report folder' }; Tip = @{ fr = 'bagarre-audit sur le Bureau.'; en = 'bagarre-audit on the Desktop.' }; Action = { if (Test-Path $DossierAudit) { Ouvrir $DossierAudit } else { Log $S.L.pasRapport } } }
    )
}

# ---------------------------------------------------------------------------
# La fenêtre : onglets à gauche, une page par étape, Précédent / Suivant, journal en bas.
# Tout tourne sur le thread de la fenêtre, Log appelle Rafraichir pour qu'elle reste vivante.
# ---------------------------------------------------------------------------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$Xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="windows bagarre edition" Width="1200" Height="800" MinWidth="960" MinHeight="640"
        WindowStartupLocation="CenterScreen" Background="#1B1B1F" Foreground="#E8E8E8" FontFamily="Segoe UI" FontSize="13">
  <Window.Resources>
    <Style TargetType="Button">
      <Setter Property="Background" Value="#2A2A31"/>
      <Setter Property="Foreground" Value="#F0F0F0"/>
      <Setter Property="BorderBrush" Value="#3C3C46"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="12,6"/>
      <Setter Property="Margin" Value="0,0,8,8"/>
      <Setter Property="HorizontalContentAlignment" Value="Center"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="4" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Fond" Property="BorderBrush" Value="#F2C14E"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.4"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Principal" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
      <Setter Property="Background" Value="#F2C14E"/>
      <Setter Property="Foreground" Value="#1B1B1F"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
    </Style>
    <Style x:Key="Carte" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
      <Setter Property="HorizontalAlignment" Value="Stretch"/>
      <Setter Property="HorizontalContentAlignment" Value="Left"/>
      <Setter Property="Padding" Value="14,10"/>
      <Setter Property="Margin" Value="0,0,0,6"/>
      <Setter Property="Background" Value="#141416"/>
    </Style>
    <Style x:Key="Langue" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
      <Setter Property="Padding" Value="10,4"/>
      <Setter Property="Margin" Value="0,0,6,0"/>
      <Setter Property="Background" Value="#141416"/>
    </Style>
    <Style TargetType="CheckBox">
      <Setter Property="Foreground" Value="#E8E8E8"/>
      <Setter Property="Margin" Value="0,3,0,3"/>
    </Style>
    <Style TargetType="TextBox">
      <Setter Property="Background" Value="#141416"/>
      <Setter Property="Foreground" Value="#DADADA"/>
      <Setter Property="BorderBrush" Value="#2E2E36"/>
      <Setter Property="FontFamily" Value="Consolas"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Padding" Value="10"/>
      <Setter Property="IsReadOnly" Value="True"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
      <Setter Property="AcceptsReturn" Value="True"/>
      <Setter Property="VerticalScrollBarVisibility" Value="Auto"/>
    </Style>
    <Style TargetType="ListBoxItem">
      <Setter Property="Foreground" Value="#C8C8C8"/>
      <Setter Property="Padding" Value="14,9"/>
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ListBoxItem">
            <Border Name="Fond" Background="Transparent" Padding="{TemplateBinding Padding}">
              <ContentPresenter/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsSelected" Value="True">
                <Setter TargetName="Fond" Property="Background" Value="#2A2A31"/>
                <Setter Property="Foreground" Value="#F2C14E"/>
              </Trigger>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Fond" Property="Background" Value="#232329"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Titre" TargetType="TextBlock">
      <Setter Property="FontSize" Value="20"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Margin" Value="0,0,0,8"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
    </Style>
    <Style x:Key="Intro" TargetType="TextBlock">
      <Setter Property="Foreground" Value="#B0B0B8"/>
      <Setter Property="Margin" Value="0,0,0,10"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
    </Style>
    <Style x:Key="Groupe" TargetType="TextBlock">
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Foreground" Value="#F2C14E"/>
      <Setter Property="Margin" Value="0,14,0,6"/>
    </Style>
    <Style x:Key="Etiquette" TargetType="TextBlock">
      <Setter Property="Foreground" Value="#F2C14E"/>
      <Setter Property="Margin" Value="0,12,0,2"/>
    </Style>
  </Window.Resources>
  <Grid Background="#1B1B1F">
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="240"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>
    <Grid.RowDefinitions>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="150"/>
    </Grid.RowDefinitions>

    <DockPanel Grid.Column="0" Grid.RowSpan="3" Background="#141416">
      <StackPanel DockPanel.Dock="Top" Margin="16,18,16,10">
        <TextBlock Text="BAGARRE" FontSize="24" FontWeight="Bold" Foreground="#F2C14E"/>
        <TextBlock Text="windows bagarre edition" Foreground="#8A8A95"/>
      </StackPanel>
      <StackPanel DockPanel.Dock="Bottom" Margin="16,8,16,14">
        <StackPanel Orientation="Horizontal" Margin="0,0,0,8">
          <Button Name="BtnFr" Content="Français" Style="{StaticResource Langue}"/>
          <Button Name="BtnEn" Content="English" Style="{StaticResource Langue}"/>
        </StackPanel>
        <TextBlock Name="NavMachine" Foreground="#8A8A95" TextWrapping="Wrap" FontSize="11"/>
      </StackPanel>
      <ListBox Name="Nav" Background="Transparent" BorderThickness="0" SelectedIndex="0"/>
    </DockPanel>

    <Grid Grid.Column="1" Grid.Row="0" Name="Pages" Margin="20,16,20,4">

      <DockPanel Name="PageAccueil">
        <TextBlock DockPanel.Dock="Top" Name="TitreAccueil" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroAccueil" Style="{StaticResource Intro}"/>
        <StackPanel DockPanel.Dock="Top" Name="Cartes" Margin="0,0,0,10"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsAccueil"/>
        <TextBox Name="TexteAccueil"/>
      </DockPanel>

      <DockPanel Name="PageInstallation" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreInstallation" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroInstallation" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsInstallation"/>
        <TextBox Name="TexteInstallation"/>
      </DockPanel>

      <DockPanel Name="PageFacile" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreFacile" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroFacile" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsFacile"/>
        <Border DockPanel.Dock="Top" Background="#141416" CornerRadius="4" Padding="12" Margin="0,0,0,10">
          <StackPanel>
            <TextBlock Name="ApplisTitre" Margin="0,0,0,6"/>
            <WrapPanel Name="ListeApplis"/>
            <Button Name="BtnApplis" Margin="0,8,0,0" HorizontalAlignment="Left"/>
          </StackPanel>
        </Border>
        <TextBox Name="TexteFacile"/>
      </DockPanel>

      <DockPanel Name="PageOptis" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreOptis" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroOptis" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsOptis"/>
        <Grid>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="370"/>
          </Grid.ColumnDefinitions>
          <ScrollViewer Grid.Column="0" VerticalScrollBarVisibility="Auto">
            <StackPanel Name="ListeOptis" Margin="0,0,12,0"/>
          </ScrollViewer>
          <Border Grid.Column="1" Background="#141416" CornerRadius="4" Padding="14">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
              <StackPanel>
                <TextBlock Name="OptiTitre" FontWeight="SemiBold" FontSize="14" TextWrapping="Wrap"/>
                <TextBlock Name="OptiEtiquette1" Style="{StaticResource Etiquette}"/>
                <TextBlock Name="OptiPourquoi" TextWrapping="Wrap" Foreground="#DADADA"/>
                <TextBlock Name="OptiEtiquette2" Style="{StaticResource Etiquette}"/>
                <TextBlock Name="OptiAttention" TextWrapping="Wrap" Foreground="#DADADA"/>
              </StackPanel>
            </ScrollViewer>
          </Border>
        </Grid>
      </DockPanel>

      <DockPanel Name="PageNvidia" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreNvidia" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroNvidia" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsNvidia"/>
        <TextBox Name="TexteNvidia"/>
      </DockPanel>

      <DockPanel Name="PageDur" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreDur" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroDur" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsDur"/>
        <TextBox Name="TexteDur"/>
      </DockPanel>

      <DockPanel Name="PageMaintenance" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreMaintenance" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroMaintenance" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsMaintenance"/>
        <TextBox Name="TexteMaintenance"/>
      </DockPanel>

      <DockPanel Name="PageDns" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreDns" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroDns" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsDns"/>
        <TextBlock DockPanel.Dock="Top" Name="DnsCarte" Foreground="#B0B0B8" Margin="0,0,0,8" TextWrapping="Wrap"/>
        <ListBox DockPanel.Dock="Top" Name="DnsListe" Background="#141416" BorderThickness="0" Height="150" FontFamily="Consolas"/>
        <TextBox Name="TexteDns" Margin="0,10,0,0"/>
      </DockPanel>

      <DockPanel Name="PageAudit" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Name="TitreAudit" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Name="IntroAudit" Style="{StaticResource Intro}"/>
        <WrapPanel DockPanel.Dock="Top" Name="BoutonsAudit"/>
        <TextBox Name="TexteAudit"/>
      </DockPanel>
    </Grid>

    <DockPanel Grid.Column="1" Grid.Row="1" Margin="20,0,20,6" LastChildFill="False">
      <Button Name="BtnSuivant" DockPanel.Dock="Right" Style="{StaticResource Principal}" Margin="8,0,0,0"/>
      <Button Name="BtnPrecedent" DockPanel.Dock="Right" Margin="0"/>
    </DockPanel>

    <DockPanel Grid.Column="1" Grid.Row="2" Margin="20,0,20,14">
      <TextBlock DockPanel.Dock="Top" Name="JournalTitre" Foreground="#8A8A95" Margin="0,0,0,4"/>
      <TextBox Name="Journal" FontSize="12"/>
    </DockPanel>
  </Grid>
</Window>
'@

try {
    $Fenetre = [Windows.Markup.XamlReader]::Parse($Xaml)
} catch {
    Add-Content -Path $LogFichier -Value "ÉCHEC fenêtre : $_"
    [Windows.MessageBox]::Show("La fenêtre n'a pas pu s'ouvrir :`n$_`n`nDétail dans $LogFichier", 'bagarre') | Out-Null
    return
}

# Tous les contrôles nommés dans $C, le journal à portée de Log
$C = @{}
foreach ($m in [regex]::Matches($Xaml, '(?<![:\w])Name="(\w+)"')) { $n = $m.Groups[1].Value; $C[$n] = $Fenetre.FindName($n) }
$Journal = $C.Journal
$C.NavMachine.Text = "$Machine`nbagarre $Version"

# ---------------------------------------------------------------------------
# Navigation : liste à gauche, cartes de l'accueil, Précédent / Suivant
# ---------------------------------------------------------------------------
foreach ($n in $PagesNoms) { $li = New-Object Windows.Controls.ListBoxItem; [void]$C.Nav.Items.Add($li) }
function Aller($k) { $C.Nav.SelectedIndex = $k }
$C.Nav.Add_SelectionChanged({
    $i = $C.Nav.SelectedIndex
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) {
        $C["Page$($PagesNoms[$k])"].Visibility = if ($k -eq $i) { 'Visible' } else { 'Collapsed' }
    }
    $C.BtnPrecedent.IsEnabled = $i -gt 0
    $C.BtnSuivant.IsEnabled = $i -lt ($PagesNoms.Count - 1)
})
$C.BtnPrecedent.Add_Click({ if ($C.Nav.SelectedIndex -gt 0) { Aller ($C.Nav.SelectedIndex - 1) } })
$C.BtnSuivant.Add_Click({ if ($C.Nav.SelectedIndex -lt ($PagesNoms.Count - 1)) { Aller ($C.Nav.SelectedIndex + 1) } })

for ($k = 1; $k -lt $PagesNoms.Count; $k++) {
    $carte = New-Object Windows.Controls.Button
    $carte.Style = $Fenetre.FindResource('Carte')
    $carte.Tag = $k
    $carte.Add_Click({ param($s, $e) Aller ([int]$s.Tag) })
    [void]$C.Cartes.Children.Add($carte)
}

# ---------------------------------------------------------------------------
# Boutons des pages, créés depuis $Boutons
# ---------------------------------------------------------------------------
foreach ($page in $Boutons.Keys) {
    foreach ($def in $Boutons[$page]) {
        $b = New-Object Windows.Controls.Button
        if ($def.Principal) { $b.Style = $Fenetre.FindResource('Principal') }
        $b.Add_Click($def.Action)
        $def.Ctl = $b
        $C[$def.Id] = $b
        [void]$C["Boutons$page"].Children.Add($b)
    }
}
$C.BtnDnsAppliquer.IsEnabled = $false

# ---------------------------------------------------------------------------
# Onglet 3 : une case par item du catalogue, l'explication au survol, le compte sur le bouton
# ---------------------------------------------------------------------------
function Opti-Montrer($titre, $pourquoi, $attention) {
    $C.OptiTitre.Text = $titre
    $C.OptiPourquoi.Text = $pourquoi
    $C.OptiAttention.Text = if ($attention) { $attention } else { $S.L.rien }
    $C.OptiEtiquette1.Visibility = 'Visible'
    $C.OptiEtiquette2.Visibility = if ($null -eq $attention) { 'Collapsed' } else { 'Visible' }
}
function Opti-Vider {
    $C.OptiTitre.Text = $S.L.survole
    $C.OptiPourquoi.Text = ''; $C.OptiAttention.Text = ''
    $C.OptiEtiquette1.Visibility = 'Collapsed'; $C.OptiEtiquette2.Visibility = 'Collapsed'
}
function Compter-Coches {
    $n = @($Items | Where-Object { $_.Coche }).Count
    $C.BtnAppliquer.Content = switch ($n) { 0 { $S.L.appliquer0 } 1 { $S.L.appliquer1 } default { $S.L.appliquerN -f $n } }
}

$Cases = @{}
$Defauts = @{}
$Groupes = @()
$groupe = ''
foreach ($it in $Items) {
    if ($it.Groupe -ne $groupe) {
        $groupe = $it.Groupe
        $tb = New-Object Windows.Controls.TextBlock
        $tb.Style = $Fenetre.FindResource('Groupe')
        $tb.Tag = $groupe
        [void]$C.ListeOptis.Children.Add($tb)
        $Groupes += $tb
    }
    $cb = New-Object Windows.Controls.CheckBox
    $cb.IsChecked = [bool]$it.Coche
    $cb.Tag = $it
    $cb.Add_MouseEnter({ param($s, $e) Opti-Montrer (Item-Titre $s.Tag) (Item-Pourquoi $s.Tag) (Item-Attention $s.Tag) })
    $cb.Add_Checked({ param($s, $e) $s.Tag.Coche = $true; Compter-Coches })
    $cb.Add_Unchecked({ param($s, $e) $s.Tag.Coche = $false; Compter-Coches })
    [void]$C.ListeOptis.Children.Add($cb)
    $Cases[$it.Id] = $cb
    $Defauts[$it.Id] = [bool]$it.Coche
}

# Noms de groupe en anglais (les groupes du catalogue sont en français)
$GroupesEn = @{
    'Services Windows' = 'Windows services'; 'Vie privée et pubs' = 'Privacy and ads'; 'Jeu et réactivité' = 'Gaming and responsiveness'
    'Carte réseau (appliqué sur chaque carte physique active)' = 'Network card (applied to every active physical card)'
    'Confort (aucun gain de FPS, juste plus vif)' = 'Comfort (no FPS gain, just snappier)'
    'Avancé (décoché par défaut, lis l explication avant)' = 'Advanced (unchecked by default, read the explanation first)'; 'NVIDIA' = 'NVIDIA'
}

function Appliquer-Demander {
    $coches = @($Items | Where-Object { $_.Coche })
    if ($coches.Count -eq 0) { Log $S.L.rienCoche; return }
    $q = [Windows.MessageBox]::Show(($S.L.confirmAppliquer -f $coches.Count, $EtatFichier), 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Appliquer-Items $coches
    [Windows.MessageBox]::Show($S.L.termine, 'bagarre') | Out-Null
}
function Restaurer-Demander {
    if ($Avant.Count -eq 0) { Log $S.L.rienRestaurer; return }
    $q = [Windows.MessageBox]::Show(($S.L.confirmRestaurer -f $Avant.Count), 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Tout-Restaurer
    [Windows.MessageBox]::Show($S.L.restaure, 'bagarre') | Out-Null
}
function Journal-Ouvrir { if (Test-Path $LogFichier) { Start-Process notepad $LogFichier } else { Log $S.L.pasJournal } }

# ---------------------------------------------------------------------------
# Onglet 2 : les applis winget à cocher
# ---------------------------------------------------------------------------
$Applis = @(
    @{ Nom = 'Steam'; Id = 'Valve.Steam'; Coche = $true }
    @{ Nom = 'Discord'; Id = 'Discord.Discord'; Coche = $true }
    @{ Nom = '7-Zip'; Id = '7zip.7zip'; Coche = $true }
    @{ Nom = 'VLC'; Id = 'VideoLAN.VLC'; Coche = $true }
    @{ Nom = 'Firefox'; Id = 'Mozilla.Firefox'; Coche = $false }
    @{ Nom = 'Brave'; Id = 'Brave.Brave'; Coche = $false }
    @{ Nom = 'Chrome'; Id = 'Google.Chrome'; Coche = $false }
    @{ Nom = 'Everything'; Id = 'voidtools.Everything'; Coche = $false }
    @{ Nom = 'PowerToys'; Id = 'Microsoft.PowerToys'; Coche = $false }
)
foreach ($a in $Applis) {
    $cb = New-Object Windows.Controls.CheckBox
    $cb.Content = $a.Nom
    $cb.IsChecked = $a.Coche
    $cb.Tag = $a.Id
    $cb.Margin = '0,3,18,3'
    [void]$C.ListeApplis.Children.Add($cb)
}
$C.BtnApplis.Add_Click({
    $ids = @($C.ListeApplis.Children | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })
    if ($ids.Count -eq 0) { Log $S.L.aucuneAppli; return }
    Winget-Installer "$($ids.Count) apps" $ids
})

# ---------------------------------------------------------------------------
# Onglet 7 : DNS
# ---------------------------------------------------------------------------
$S.DnsAdapt = $null
$S.DnsResultats = @()
function Dns-Tester {
    $adapt = Dns-Carte
    if (-not $adapt) { Log $S.L.aucuneCarte; return }
    $S.DnsAdapt = $adapt
    $C.DnsCarte.Text = $S.L.dnsCarte -f $adapt.Name, $adapt.InterfaceDescription, ((Dns-Actuels $adapt) -join ', ')
    $C.DnsListe.Items.Clear()
    $C.BtnDnsAppliquer.IsEnabled = $false
    Log $S.L.dnsEnCours
    $S.DnsResultats = @(Dns-Mesurer $adapt)
    foreach ($r in $S.DnsResultats) { [void]$C.DnsListe.Items.Add(('{0,-24} {1,7} ms' -f $r.Nom, $r.Mediane)) }
    $C.BtnDnsAppliquer.IsEnabled = $true
    Log $S.L.dnsFini
}

# ---------------------------------------------------------------------------
# Onglet 8 : audit IA
# ---------------------------------------------------------------------------
$DossierAudit = Join-Path ([Environment]::GetFolderPath('Desktop')) 'bagarre-audit'
function Audit-Collecter {
    if (-not (Test-Path $DossierAudit)) { New-Item -Path $DossierAudit -ItemType Directory -Force | Out-Null }
    [IO.File]::WriteAllText((Join-Path $DossierAudit 'AUDIT.txt'), $Textes[$S.Langue]['audit-prompt'], (New-Object Text.UTF8Encoding $true))
    Log $S.L.collecte
    Collecter-Rapport (Join-Path $DossierAudit 'rapport-pc.txt')
    Ouvrir $DossierAudit
}

# ---------------------------------------------------------------------------
# Langue : tout relabelliser d'un coup, et retenir le choix
# ---------------------------------------------------------------------------
function Appliquer-Langue {
    $S.L = $UI[$S.Langue]; $L = $S.L
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) {
        $p = $PagesNoms[$k]
        $C.Nav.Items[$k].Content = $L.nav[$k]
        $C["Titre$p"].Text = $L.titres[$p]
        $C["Intro$p"].Text = $L.intros[$p]
        if ($C["Texte$p"]) { $C["Texte$p"].Text = $Textes[$S.Langue][$p.ToLower()] }
    }
    $k = 1
    foreach ($carte in $C.Cartes.Children) {
        $carte.Content = '{0,-26} {1,-10} {2}' -f $L.nav[$k], $L.duree[$k], $L.resume[$k]
        $carte.FontFamily = 'Consolas'
        $k++
    }
    foreach ($page in $Boutons.Keys) { foreach ($def in $Boutons[$page]) { $def.Ctl.Content = $def.T[$S.Langue]; $def.Ctl.ToolTip = $def.Tip[$S.Langue] } }
    $C.BtnPrecedent.Content = $L.precedent; $C.BtnSuivant.Content = $L.suivant
    $C.JournalTitre.Text = $L.journal
    $C.ApplisTitre.Text = $L.applisTitre
    $C.BtnApplis.Content = if ($S.Langue -eq 'fr') { 'Installer les applis cochées' } else { 'Install the ticked apps' }
    $C.OptiEtiquette1.Text = $L.pourquoi; $C.OptiEtiquette2.Text = $L.perds
    foreach ($tb in $Groupes) { $tb.Text = if ($S.Langue -eq 'en' -and $GroupesEn[$tb.Tag]) { $GroupesEn[$tb.Tag] } else { $tb.Tag } }
    foreach ($id in $Cases.Keys) { $Cases[$id].Content = Item-Titre $Cases[$id].Tag }
    $C.BtnFr.BorderBrush = if ($S.Langue -eq 'fr') { '#F2C14E' } else { '#3C3C46' }
    $C.BtnEn.BorderBrush = if ($S.Langue -eq 'en') { '#F2C14E' } else { '#3C3C46' }
    Opti-Vider
    Compter-Coches
}
function Changer-Langue($l) {
    $S.Langue = $l
    Set-Content -Path $LangueFichier -Value $l -Encoding ASCII
    Appliquer-Langue
}
$C.BtnFr.Add_Click({ Changer-Langue 'fr' })
$C.BtnEn.Add_Click({ Changer-Langue 'en' })
Appliquer-Langue
Aller 0
$C.BtnPrecedent.IsEnabled = $false

# ---------------------------------------------------------------------------
# Mode -Capture dossier : rend chaque onglet en PNG sans afficher la fenêtre ni demander l'admin (preuve visuelle en dev)
# ---------------------------------------------------------------------------
if ($Capture) {
    if (-not (Test-Path $Capture)) { New-Item -Path $Capture -ItemType Directory -Force | Out-Null }
    Log "bagarre $Version, $Machine (capture $($S.Langue))"
    $racine = $Fenetre.Content
    $racine.Measure((New-Object Windows.Size 1200, 800))
    $racine.Arrange((New-Object Windows.Rect 0, 0, 1200, 800))
    Opti-Montrer (Item-Titre $Items[0]) (Item-Pourquoi $Items[0]) (Item-Attention $Items[0])   # le volet d'explication rempli, comme au survol
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) {
        Aller $k
        $racine.UpdateLayout()
        $bmp = New-Object Windows.Media.Imaging.RenderTargetBitmap 1200, 800, 96, 96, ([Windows.Media.PixelFormats]::Pbgra32)
        $bmp.Render($racine)
        $enc = New-Object Windows.Media.Imaging.PngBitmapEncoder
        $enc.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bmp))
        $fs = [IO.File]::Create((Join-Path $Capture ('{0}-{1}-{2}.png' -f $k, $PagesNoms[$k].ToLower(), $S.Langue)))
        $enc.Save($fs); $fs.Close()
    }
    Write-Host "Captures dans $Capture"
    return
}

Log "bagarre $Version, $Machine"
if ($Avant.Count -gt 0) { Log ($L.dejaApplique -f $Avant.Count) }

# Passer devant la console qui nous a lancés (un Terminal garde souvent le premier plan) : Topmost le temps du chargement, puis Activate.
$Fenetre.Add_Loaded({
    $Fenetre.Topmost = $true
    [void]$Fenetre.Activate()
    $Fenetre.Topmost = $false
})

# Mode -Essai : la fenêtre s'ouvre pour de vrai mais invisible (hors écran, transparente), note son état dans le journal et se ferme.
if ($Essai) {
    $Fenetre.WindowStartupLocation = 'Manual'; $Fenetre.Left = -20000; $Fenetre.Top = -20000
    $Fenetre.Opacity = 0; $Fenetre.ShowInTaskbar = $false; $Fenetre.ShowActivated = $false
    $minuteur = New-Object Windows.Threading.DispatcherTimer
    $minuteur.Interval = [TimeSpan]::FromMilliseconds(1500)
    $minuteur.Add_Tick({
        Log "essai     visible=$($Fenetre.IsVisible) chargée=$($Fenetre.IsLoaded) largeur=$($Fenetre.ActualWidth) hauteur=$($Fenetre.ActualHeight)"
        $this.Stop()
        $Fenetre.Close()
    })
    $minuteur.Start()
}

Write-Host "  $($L.ouverte)" -ForegroundColor Green
try { $Fenetre.ShowDialog() | Out-Null } catch {
    Log "ÉCHEC affichage de la fenêtre : $_"
    [Windows.MessageBox]::Show("La fenêtre n'a pas pu s'afficher :`n$_`n`nDétail dans $LogFichier", 'bagarre') | Out-Null
}
Log 'fenêtre fermée'
