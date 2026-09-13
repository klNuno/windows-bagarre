# ---------------------------------------------------------------------------
# Mode -Liste : le catalogue en texte, sans rien appliquer (test)
# ---------------------------------------------------------------------------
if ($Liste) {
    Write-Host "Machine : $Machine"
    $Items | ForEach-Object { '{0,-24} {1} {2}' -f $_.Id, $(if ($_.Coche) { '[x]' } else { '[ ]' }), $_.Titre }
    return
}

# ---------------------------------------------------------------------------
# Textes de l'interface, français et anglais. Les tutos sont dans $Textes (un fichier par page, balisé :
# "## " ouvre une carte, "@Id, Id2" pose des boutons, "! " une mise en garde, "> " une commande, "- " une puce),
# les items dans le catalogue (français) et $TraductionsEn (anglais).
# ---------------------------------------------------------------------------
$PagesNoms = 'Accueil', 'Installation', 'Facile', 'Optis', 'Nvidia', 'Dur', 'Maintenance', 'Dns', 'Audit'
$UI = @{
    fr = @{
        nav      = 'Accueil', 'Installation', 'Facile', 'Le script à cocher', 'NVIDIA', 'Dur', 'Maintenance', 'DNS', 'Audit IA'
        resume   = '', 'Windows propre, mises à jour, pilotes', 'débloat en deux clics, librairies, son', 'services, vie privée, jeu, réseau, confort', 'pilote nu, ancien Panneau de configuration', 'une chose à la fois, tu mesures', 'nettoyer et vérifier, des mois après', 'le résolveur le plus rapide depuis chez toi', 'une IA vérifie ton PC'
        titres   = @{
            Accueil = 'Tu viens de réinstaller Windows 11 ?'; Installation = 'Windows propre, mises à jour, pilotes'
            Facile = 'Débloat en deux clics, librairies, son'; Optis = 'Le script à cocher'
            Nvidia = "Le pilote nu, puis l'ancien Panneau de configuration"; Dur = 'Une chose à la fois, tu mesures'
            Maintenance = 'Quand le PC a vécu'; Dns = 'Qui répond le plus vite depuis chez toi ?'; Audit = 'Une IA vérifie ton PC'
        }
        survole = 'Passe la souris sur une ligne pour lire le pourquoi et ce que tu perds.'; pourquoi = 'Pourquoi'; perds = 'Ce que tu perds'; rien = 'Rien de notable.'
        appliquerN = 'Appliquer les {0} cases cochées'; appliquer0 = 'Appliquer (rien de coché)'; appliquer1 = 'Appliquer la case cochée'
        legende = 'Coché = fait quand tu cliques Appliquer. Décoché = rien ne change. Tu ne comprends pas une ligne, tu ne la coches pas.'
        seraFait = 'sera fait'; laisse = 'laissé tel quel'; dejaFait = 'déjà fait'
        reseauTitre = 'Carte réseau à la main'; langue = 'Français'
        rienCoche = 'Rien de coché.'; confirmAppliquer = "Appliquer {0} réglages ?`n`nL'état d'avant est sauvé dans {1}, le bouton Tout remettre le restaure."
        termine = 'Terminé. Redémarre le PC pour que tout prenne effet.'; rienRestaurer = 'Rien à restaurer : aucun réglage appliqué sur ce PC.'
        confirmRestaurer = 'Remettre les {0} réglages comme avant ?'; restaure = 'Restauré. Redémarre le PC.'
        aucuneCarte = 'Aucune carte réseau active trouvée.'; dnsCarte = 'Carte {0} ({1}). DNS actuel : {2}, souvent ta box.'
        dnsEnCours = 'Test DNS en cours...'; dnsFini = 'Test terminé. Clique une ligne puis "Utiliser le DNS sélectionné", ou ne change rien.'
        dnsSelection = 'Clique une ligne de résultat.'; dnsBox = 'box'
        collecte = 'Collecte en cours, environ 30 secondes...'; promptCopie = 'Prompt copié dans le presse-papiers. Colle-le dans ton IA avec rapport-pc.txt.'
        commandeCopiee = 'Commande copiée. Colle-la dans un Terminal pour rouvrir bagarre.'
        pasRapport = "Pas encore de rapport : bouton 1 d'abord."; pasJournal = 'Pas encore de journal.'
        dejaApplique = '{0} réglages déjà appliqués sur ce PC (bagarre-avant.json). Tout remettre les restaure.'
        ouverte = 'Fenêtre ouverte. Si tu ne la vois pas, regarde la barre des tâches : elle peut être derrière ce terminal.'
        filtrer = 'Chercher une ligne'; tout = 'tout'; rienBtn = 'rien'; coches = 'cochées'
        detection = 'Détection de ce qui est déjà en place sur ce PC...'
        detectionFin = '{0} réglages déjà en place, décochés et marqués "déjà fait". Le reste est à faire.'
        vieuxTitre = 'Ton installation Windows a {0}.'
        vieuxTexte = "C'est pas que je suis pas sûr de mon script, mais on sait jamais. Il faut toujours se protéger."
        vieuxRestauration = 'Créer un point de restauration'; vieuxSauvegarde = 'Sauvegarder mes fichiers'; vieuxContinuer = 'Continuer quand même'
        an = 'an', 'ans'; mois = 'mois', 'mois'; jour = 'jour', 'jours'; et = 'et'
    }
    en = @{
        nav      = 'Home', 'Install', 'Easy', 'The checkbox script', 'NVIDIA', 'Hard', 'Maintenance', 'DNS', 'AI audit'
        resume   = '', 'clean Windows, updates, drivers', 'debloat in two clicks, libraries, sound', 'services, privacy, gaming, network, comfort', 'bare driver, classic Control Panel', 'one thing at a time, you measure', 'clean and check, months later', 'the fastest resolver from your place', 'an AI checks your PC'
        titres   = @{
            Accueil = 'Just reinstalled Windows 11?'; Installation = 'Clean Windows, updates, drivers'
            Facile = 'Debloat in two clicks, libraries, sound'; Optis = 'The checkbox script'
            Nvidia = 'The bare driver, then the classic Control Panel'; Dur = 'One thing at a time, you measure'
            Maintenance = 'When the PC has lived a while'; Dns = 'Who answers fastest from your place?'; Audit = 'An AI checks your PC'
        }
        survole = 'Hover a line to read the why and what you lose.'; pourquoi = 'Why'; perds = 'What you lose'; rien = 'Nothing notable.'
        appliquerN = 'Apply the {0} checked boxes'; appliquer0 = 'Apply (nothing checked)'; appliquer1 = 'Apply the checked box'
        legende = 'Checked = done when you click Apply. Unchecked = nothing changes. If you do not understand a line, do not check it.'
        seraFait = 'will be done'; laisse = 'left as is'; dejaFait = 'already done'
        reseauTitre = 'Network card by hand'; langue = 'English'
        rienCoche = 'Nothing checked.'; confirmAppliquer = "Apply {0} settings?`n`nThe previous state is saved in {1}, the Restore button puts it back."
        termine = 'Done. Reboot the PC so everything takes effect.'; rienRestaurer = 'Nothing to restore: no setting applied on this PC.'
        confirmRestaurer = 'Put the {0} settings back as they were?'; restaure = 'Restored. Reboot the PC.'
        aucuneCarte = 'No active network card found.'; dnsCarte = 'Card {0} ({1}). Current DNS: {2}, usually your router.'
        dnsEnCours = 'DNS test running...'; dnsFini = 'Test done. Click a line then "Use the selected DNS", or change nothing.'
        dnsSelection = 'Click a result line.'; dnsBox = 'router'
        collecte = 'Collecting, about 30 seconds...'; promptCopie = 'Prompt copied to the clipboard. Paste it into your AI along with rapport-pc.txt.'
        commandeCopiee = 'Command copied. Paste it into a Terminal to reopen bagarre.'
        pasRapport = 'No report yet: button 1 first.'; pasJournal = 'No log yet.'
        dejaApplique = '{0} settings already applied on this PC (bagarre-avant.json). Restore puts them back.'
        ouverte = 'Window open. If you do not see it, check the taskbar: it may be behind this terminal.'
        filtrer = 'Find a line'; tout = 'all'; rienBtn = 'none'; coches = 'checked'
        detection = 'Detecting what is already in place on this PC...'
        detectionFin = '{0} settings already in place, unchecked and marked "already done". The rest is to do.'
        vieuxTitre = 'Your Windows install is {0} old.'
        vieuxTexte = 'Not that I doubt my script, but you never know. Always protect yourself first.'
        vieuxRestauration = 'Create a restore point'; vieuxSauvegarde = 'Back up my files'; vieuxContinuer = 'Continue anyway'
        an = 'year', 'years'; mois = 'month', 'months'; jour = 'day', 'days'; et = 'and'
    }
}
$Bagarre.L = $UI[$Bagarre.Langue]

# Titre et explications d'un item dans la langue courante
function Item-Titre($it) { if ($Bagarre.Langue -eq 'en' -and $TraductionsEn[$it.Id]) { $TraductionsEn[$it.Id].Titre } else { $it.Titre } }
function Item-Pourquoi($it) { if ($Bagarre.Langue -eq 'en' -and $TraductionsEn[$it.Id]) { $TraductionsEn[$it.Id].Pourquoi } else { $it.Pourquoi } }
function Item-Attention($it) { if ($Bagarre.Langue -eq 'en' -and $TraductionsEn[$it.Id]) { $TraductionsEn[$it.Id].Attention } else { $it.Attention } }

# Âge de l'installation en mots : "2 ans et 3 mois", "3 mois et 12 jours", "12 jours"
function Age-Texte($jours) {
    $L = $Bagarre.L
    $annees = [math]::Floor($jours / 365); $reste = $jours % 365; $m = [math]::Floor($reste / 30); $j = $reste % 30
    $mot = { param($n, $f) if ($n -eq 1) { "$n $($f[0])" } else { "$n $($f[1])" } }
    if ($annees -gt 0) { $t = & $mot $annees $L.an; if ($m -gt 0) { $t += " $($L.et) " + (& $mot $m $L.mois) }; return $t }
    if ($m -gt 0) { $t = & $mot $m $L.mois; if ($j -gt 0) { $t += " $($L.et) " + (& $mot $j $L.jour) }; return $t }
    & $mot $j $L.jour
}

# ---------------------------------------------------------------------------
# Les boutons : libellé et bulle d'aide dans les deux langues, logo de l'outil lancé, ce qu'ils font.
# Un bouton est créé une fois (Bouton-Obtenir) et posé là où le texte de la page l'appelle par "@Id".
# ---------------------------------------------------------------------------
# Carte AMD dédiée : l'étape 4 devient la page AMD (textes/amd.txt), le rail et la carte d'accueil suivent.
# Le nom interne de la page reste Nvidia.
if ($EstAmd) {
    $UI.fr.nav[4] = 'AMD'; $UI.fr.resume[4] = 'pilote propre, Adrenalin sans le superflu'; $UI.fr.titres.Nvidia = 'Le pilote propre, puis Adrenalin sans le superflu'
    $UI.en.nav[4] = 'AMD'; $UI.en.resume[4] = 'clean driver, Adrenalin without the extras'; $UI.en.titres.Nvidia = 'The clean driver, then Adrenalin without the extras'
}

$Boutons = @{
    BtnRestaurerAccueil = @{ T = @{ fr = 'Tout remettre comme avant'; en = 'Restore everything' }; Tip = @{ fr = 'Remet chaque réglage du script à cocher à sa valeur d avant. Le DNS aussi.'; en = 'Puts every setting of the checkbox script back to its previous value. DNS too.' }; Action = { Restaurer-Demander } }
    BtnJournalAccueil = @{ T = @{ fr = 'Ouvrir le journal (bagarre.log)'; en = 'Open the log (bagarre.log)' }; Tip = @{ fr = 'Le détail de tout ce qui a été modifié sur ce PC.'; en = 'The detail of everything changed on this PC.' }; Action = { Journal-Ouvrir } }
    BtnCommande = @{ T = @{ fr = 'Copier la commande de lancement'; en = 'Copy the launch command' }; Tip = @{ fr = 'La ligne irm ... | iex dans le presse-papiers.'; en = 'The irm ... | iex line to the clipboard.' }; Action = { [Windows.Clipboard]::SetText("irm $Depot | iex"); Log $Bagarre.L.commandeCopiee } }

    BtnFsutil = @{ Logo = 'microsoft'; T = @{ fr = 'Lancer fsutil 8dot3name set 1'; en = 'Run fsutil 8dot3name set 1' }; Tip = @{ fr = 'Coupe la génération des noms courts PROGRA~1 sur les disques neufs. Juste après le premier bureau, avant d installer quoi que ce soit.'; en = 'Stops generating PROGRA~1 short names on new disks. Right after the first desktop, before installing anything.' }; Action = { Console-Lancer 'fsutil 8dot3name set 1' 'fsutil 8dot3name set 1; fsutil 8dot3name query' } }
    BtnWindowsUpdate = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir Windows Update'; en = 'Open Windows Update' }; Tip = @{ fr = 'Tu cliques jusqu à ce qu il n y ait plus rien, redémarre entre chaque série.'; en = 'Click until nothing is left, reboot between each batch.' }; Action = { Ouvrir 'ms-settings:windowsupdate' } }
    BtnPeripheriques = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir le Gestionnaire de périphériques'; en = 'Open Device Manager' }; Tip = @{ fr = 'Un point d exclamation jaune = un pilote qui manque.'; en = 'A yellow exclamation mark = a missing driver.' }; Action = { Ouvrir 'devmgmt.msc' } }
    BtnSnappy = @{ Logo = 'snappy'; T = @{ fr = 'Installer Snappy Driver Installer'; en = 'Install Snappy Driver Installer' }; Tip = @{ fr = 'Télécharge le zip officiel (celui que winget connaît) dans le dossier bagarre et lance SDIO. Dernier recours pour un pilote introuvable. Ne coche que ce qui manque.'; en = 'Downloads the official zip (the one winget knows) into the bagarre folder and starts SDIO. Last resort for a missing driver. Only tick what is missing.' }; Action = { Snappy-Installer } }

    BtnDebloat = @{ Logo = 'raphire'; T = @{ fr = 'Lancer Win11Debloat'; en = 'Run Win11Debloat' }; Tip = @{ fr = 'Retire les applis sponsorisées, Copilot, les pubs, la télémétrie. Demande avant chaque groupe. Mode par défaut.'; en = 'Removes sponsored apps, Copilot, ads, telemetry. Asks before each group. Default mode.' }; Action = { Console-Lancer 'Win11Debloat' '& ([scriptblock]::Create((irm "https://debloat.raphi.re/")))' -Fermer } }
    BtnWinUtil = @{ Logo = 'christitus'; T = @{ fr = 'Lancer WinUtil (Chris Titus)'; en = 'Run WinUtil (Chris Titus)' }; Tip = @{ fr = 'Onglet Install pour tes programmes, onglet Tweaks preset Standard seulement.'; en = 'Install tab for your programs, Tweaks tab with the Standard preset only.' }; Action = { Console-Lancer 'WinUtil (Chris Titus)' 'irm https://christitus.com/win | iex' -Fermer } }
    BtnDirectX = @{ Logo = 'microsoft'; T = @{ fr = 'Installer DirectX 9'; en = 'Install DirectX 9' }; Tip = @{ fr = 'Installe via winget les vieilles librairies DirectX 9 que les anciens jeux réclament.'; en = 'Installs through winget the old DirectX 9 libraries older games ask for.' }; Action = { Winget-Installer 'DirectX' 'Microsoft.DirectX' } }
    BtnVcredist = @{ Logo = 'microsoft'; T = @{ fr = 'Installer Visual C++ 2005 à 2022'; en = 'Install Visual C++ 2005 to 2022' }; Tip = @{ fr = 'Installe via winget. Sans elles un jeu plante avec "VCRUNTIME140.dll introuvable".'; en = 'Installs through winget. Without them a game crashes with "VCRUNTIME140.dll not found".' }; Action = { $ids = foreach ($an in '2005', '2008', '2010', '2012', '2013', '2015+') { "Microsoft.VCRedist.$an.x86"; "Microsoft.VCRedist.$an.x64" }; Winget-Installer 'Visual C++ 2005-2022' $ids } }
    BtnSon = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir les périphériques de lecture'; en = 'Open playback devices' }; Tip = @{ fr = 'La fenêtre Son de Windows : ton haut-parleur > Propriétés > Améliorations et Avancé.'; en = 'The Windows Sound window: your speaker > Properties > Enhancements and Advanced.' }; Action = { Start-Process control.exe -ArgumentList 'mmsys.cpl' | Out-Null } }

    BtnAppliquer = @{ Zone = 'Barre'; Principal = $true; T = @{ fr = 'Appliquer'; en = 'Apply' }; Tip = @{ fr = 'Applique les cases cochées, après confirmation. L état d avant est sauvé.'; en = 'Applies the checked boxes, after confirmation. The previous state is saved.' }; Action = { Appliquer-Demander } }
    BtnDefaut = @{ Zone = 'Barre'; T = @{ fr = 'Recocher les cases par défaut'; en = 'Re-tick the default boxes' }; Tip = @{ fr = 'Recoche exactement les cases sûres, décoche le reste.'; en = 'Re-ticks exactly the safe boxes, unticks the rest.' }; Action = { foreach ($id in $Lignes.Keys) { $Lignes[$id].Cb.IsChecked = $Defauts[$id] } } }
    BtnDetecter = @{ Zone = 'Barre'; T = @{ fr = 'Re-détecter ce PC'; en = 'Re-detect this PC' }; Tip = @{ fr = 'Relit le PC : les réglages déjà en place sont décochés et marqués "déjà fait".'; en = 'Reads the PC again: settings already in place get unchecked and marked "already done".' }; Action = { Detecter-Tout } }
    BtnRestaurer = @{ Zone = 'Barre'; T = @{ fr = 'Tout remettre comme avant'; en = 'Restore everything' }; Tip = @{ fr = 'Remet chaque réglage à sa valeur d avant, DNS compris.'; en = 'Puts every setting back to its previous value, DNS included.' }; Action = { Restaurer-Demander } }
    BtnReseau = @{ Zone = 'Volet'; T = @{ fr = 'Lire : la carte réseau à la main'; en = 'Read: the network card by hand' }; Tip = @{ fr = 'Le groupe Carte réseau fait tout seul. Ce tuto sert si tu veux vérifier ou le faire à la main.'; en = 'The Network card group does it all. This guide is for checking or doing it by hand.' }; Action = { Opti-Montrer $Bagarre.L.reseauTitre $Textes[$Bagarre.Langue]['reseau'] $null } }
    BtnImgProtocoles = @{ Zone = 'Volet'; T = @{ fr = 'Voir la capture : protocoles'; en = 'See the screenshot: protocols' }; Tip = @{ fr = 'La liste des protocoles de la carte, ce qu on décoche.'; en = 'The card protocol list, what gets unticked.' }; Action = { Image-Ouvrir 'reseau-protocoles.png' } }
    BtnImgAvance = @{ Zone = 'Volet'; T = @{ fr = 'Voir la capture : onglet Avancé'; en = 'See the screenshot: Advanced tab' }; Tip = @{ fr = 'L onglet Avancé du pilote réseau.'; en = 'The Advanced tab of the network driver.' }; Action = { Image-Ouvrir 'reseau-avance.png' } }
    BtnJournal = @{ Zone = 'Volet'; T = @{ fr = 'Ouvrir le journal (bagarre.log)'; en = 'Open the log (bagarre.log)' }; Tip = @{ fr = 'Le détail de tout ce qui a été modifié, avec les valeurs d avant.'; en = 'The detail of everything changed, with the previous values.' }; Action = { Journal-Ouvrir } }

    BtnNvclean = @{ Logo = 'techpowerup'; T = @{ fr = 'Installer NVCleanstall'; en = 'Install NVCleanstall' }; Tip = @{ fr = 'Installe via winget. Le pilote NVIDIA nu, sans NVIDIA App. Coche comme sur la capture.'; en = 'Installs through winget. The bare NVIDIA driver, without the NVIDIA App. Tick as on the screenshot.' }; Action = { Winget-Installer 'NVCleanstall' 'TechPowerUp.NVCleanstall' } }
    BtnPanneau = @{ Logo = 'nvidia'; T = @{ fr = 'Installer le Panneau de configuration NVIDIA'; en = 'Install the NVIDIA Control Panel' }; Tip = @{ fr = 'L ancien Panneau, depuis le Store. À refaire après chaque installation propre du pilote.'; en = 'The classic Control Panel, from the Store. Redo it after every clean driver install.' }; Action = { Winget-Installer 'NVIDIA Control Panel' '9NF8H0H7WMLT' 'msstore' } }
    BtnGraphiques = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir Affichage > Graphiques'; en = 'Open Display > Graphics' }; Tip = @{ fr = 'Les Paramètres Windows : optimisations fenêtrées, HAGS, Auto HDR.'; en = 'Windows Settings: windowed optimizations, HAGS, Auto HDR.' }; Action = { Ouvrir 'ms-settings:display-advancedgraphics' } }
    BtnAfterburner = @{ Logo = 'msi'; T = @{ fr = 'Installer MSI Afterburner + RivaTuner'; en = 'Install MSI Afterburner + RivaTuner' }; Tip = @{ fr = 'Installe via winget. Pas pour overclocker : pour VOIR le temps d image et poser un cap de FPS.'; en = 'Installs through winget. Not for overclocking: to SEE frame times and set an FPS cap.' }; Action = { Winget-Installer 'MSI Afterburner + RivaTuner' 'Guru3D.Afterburner', 'Guru3D.RTSS' } }
    BtnImgNvclean = @{ T = @{ fr = 'Voir la capture : quoi cocher'; en = 'See the screenshot: what to tick' }; Tip = @{ fr = 'Les cases à cocher dans NVCleanstall (sauf MPO).'; en = 'The boxes to tick in NVCleanstall (except MPO).' }; Action = { Image-Ouvrir 'nvcleanstall.png' } }
    BtnImgPanneau = @{ T = @{ fr = 'Voir la capture : réglages 3D'; en = 'See the screenshot: 3D settings' }; Tip = @{ fr = 'Les réglages 3D globaux.'; en = 'The global 3D settings.' }; Action = { Image-Ouvrir 'panneau-nvidia.png' } }

    BtnThreadPilot = @{ Logo = 'threadpilot'; T = @{ fr = 'Installer ThreadPilot'; en = 'Install ThreadPilot' }; Tip = @{ fr = 'Installe via winget. Priorité et cœurs par programme, open source. Windows 11 seulement.'; en = 'Installs through winget. Per-program priority and cores, open source. Windows 11 only.' }; Action = { Winget-Installer 'ThreadPilot' 'PrimeBuild.ThreadPilot' } }
    BtnSouris = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir les propriétés de la souris'; en = 'Open mouse properties' }; Tip = @{ fr = 'Onglet Options du pointeur : vitesse au cran 6/11, précision décochée par le script.'; en = 'Pointer Options tab: speed at notch 6/11, precision unticked by the script.' }; Action = { Start-Process control.exe -ArgumentList 'main.cpl' | Out-Null } }
    BtnIslc = @{ Logo = 'wagnardsoft'; T = @{ fr = 'Installer ISLC'; en = 'Install ISLC' }; Tip = @{ fr = 'Installe via winget. 16 Go de RAM et des jeux récents seulement.'; en = 'Installs through winget. 16 GB of RAM and recent games only.' }; Action = { Winget-Installer 'ISLC' 'Wagnardsoft.ISLC' } }
    BtnAutoGpu = @{ Logo = 'valleyofdoom'; T = @{ fr = 'Ouvrir le dépôt AutoGpuAffinity'; en = 'Open the AutoGpuAffinity repo' }; Tip = @{ fr = 'Ouvre le dépôt GitHub. Long (1 h), sur un PC déjà stable.'; en = 'Opens the GitHub repo. Long (1 h), on an already stable PC.' }; Action = { Ouvrir 'https://github.com/valleyofdoom/AutoGpuAffinity' } }
    BtnAmd = @{ T = @{ fr = 'Ouvrir la page pilotes AMD'; en = 'Open the AMD drivers page' }; Tip = @{ fr = 'Le site AMD, pilote seul.'; en = 'AMD site, driver only.' }; Action = { Ouvrir 'https://www.amd.com/en/support/download/drivers.html' } }
    BtnUpdateOptions = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir Windows Update > Options avancées'; en = 'Open Windows Update > Advanced options' }; Tip = @{ fr = 'Suspendre les mises à jour, jusqu à 5 semaines.'; en = 'Pause updates, up to 5 weeks.' }; Action = { Ouvrir 'ms-settings:windowsupdate-options' } }

    BtnAutoruns = @{ Logo = 'microsoft'; T = @{ fr = 'Installer Autoruns'; en = 'Install Autoruns' }; Tip = @{ fr = 'Installe via winget. Tout ce qui se lance au démarrage. Décoche, ne supprime pas.'; en = 'Installs through winget. Everything that starts with Windows. Untick, do not delete.' }; Action = { Winget-Installer 'Autoruns' 'Microsoft.Sysinternals.Autoruns' } }
    BtnGeek = @{ Logo = 'geek'; T = @{ fr = 'Installer Geek Uninstaller'; en = 'Install Geek Uninstaller' }; Tip = @{ fr = 'Installe via winget. Désinstalle proprement et enlève les restes.'; en = 'Installs through winget. Uninstalls cleanly and removes leftovers.' }; Action = { Winget-Installer 'Geek Uninstaller' 'GeekUninstaller.GeekUninstaller' } }
    BtnFan = @{ Logo = 'rem0o'; T = @{ fr = 'Installer FanControl'; en = 'Install FanControl' }; Tip = @{ fr = 'Installe via winget. Les ventilos, sans la suite constructeur.'; en = 'Installs through winget. Fans, without the vendor suite.' }; Action = { Winget-Installer 'FanControl' 'Rem0o.FanControl' } }
    BtnRgb = @{ Logo = 'openrgb'; T = @{ fr = 'Installer OpenRGB'; en = 'Install OpenRGB' }; Tip = @{ fr = 'Installe via winget. Les LED, sans la suite constructeur.'; en = 'Installs through winget. LEDs, without the vendor suite.' }; Action = { Winget-Installer 'OpenRGB' 'OpenRGB.OpenRGB' } }
    BtnCleanmgr = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir le Nettoyage de disque'; en = 'Open Disk Cleanup' }; Tip = @{ fr = 'cleanmgr, puis Nettoyer les fichiers système : anciennes mises à jour, corbeille.'; en = 'cleanmgr, then Clean up system files: old updates, recycle bin.' }; Action = { Start-Process cleanmgr | Out-Null; Log 'console   cleanmgr' } }
    BtnDismAnalyse = @{ Logo = 'microsoft'; T = @{ fr = 'Analyser WinSxS (DISM)'; en = 'Analyze WinSxS (DISM)' }; Tip = @{ fr = 'Dit s il y a quelque chose à nettoyer.'; en = 'Says whether there is something to clean.' }; Action = { Console-Lancer 'DISM AnalyzeComponentStore' 'Dism /Online /Cleanup-Image /AnalyzeComponentStore' } }
    BtnDismNettoyer = @{ Logo = 'microsoft'; T = @{ fr = 'Nettoyer WinSxS (DISM)'; en = 'Clean WinSxS (DISM)' }; Tip = @{ fr = 'Jamais /ResetBase : tu perdrais la désinstallation des mises à jour.'; en = 'Never /ResetBase: you would lose update uninstall.' }; Action = { Console-Lancer 'DISM StartComponentCleanup' 'Dism /Online /Cleanup-Image /StartComponentCleanup' } }
    BtnStockage = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir l Assistant de stockage'; en = 'Open Storage Sense' }; Tip = @{ fr = 'Paramètres > Système > Stockage > Assistant de stockage.'; en = 'Settings > System > Storage > Storage Sense.' }; Action = { Ouvrir 'ms-settings:storagesense' } }
    BtnBleach = @{ Logo = 'bleachbit'; T = @{ fr = 'Installer BleachBit'; en = 'Install BleachBit' }; Tip = @{ fr = 'Installe via winget. Caches navigateurs, logs. Jamais "Free disk space" ni "Memory".'; en = 'Installs through winget. Browser caches, logs. Never "Free disk space" nor "Memory".' }; Action = { Winget-Installer 'BleachBit' 'BleachBit.BleachBit' } }
    BtnRapr = @{ Logo = 'lostindark'; T = @{ fr = 'Installer DriverStore Explorer'; en = 'Install DriverStore Explorer' }; Tip = @{ fr = 'Installe via winget. Supprime les vieux pilotes NVIDIA empilés (plusieurs Go).'; en = 'Installs through winget. Removes stacked old NVIDIA drivers (several GB).' }; Action = { Winget-Installer 'DriverStore Explorer' 'lostindark.DriverStoreExplorer' } }
    BtnTrim = @{ Logo = 'microsoft'; T = @{ fr = 'Lancer le TRIM du disque système'; en = 'Run TRIM on the system disk' }; Tip = @{ fr = 'Optimize-Volume -ReTrim. L Assistant de stockage le fait déjà tous les mois.'; en = 'Optimize-Volume -ReTrim. Storage Sense already does it monthly.' }; Action = { Console-Lancer 'TRIM' "Optimize-Volume -DriveLetter $($env:SystemDrive[0]) -ReTrim -Verbose" } }
    BtnCrystal = @{ Logo = 'crystaldiskinfo'; T = @{ fr = 'Installer CrystalDiskInfo'; en = 'Install CrystalDiskInfo' }; Tip = @{ fr = 'Installe via winget. Santé et température des disques.'; en = 'Installs through winget. Disk health and temperature.' }; Action = { Winget-Installer 'CrystalDiskInfo' 'CrystalDewWorld.CrystalDiskInfo' } }
    BtnDdu = @{ Logo = 'wagnardsoft'; T = @{ fr = 'Installer DDU'; en = 'Install DDU' }; Tip = @{ fr = 'Installe via winget. Quand tu changes de marque de carte, ou pour repartir propre après un pilote qui déconne.'; en = 'Installs through winget. When you switch card brand, or to start clean after a misbehaving driver.' }; Action = { Winget-Installer 'Display Driver Uninstaller' 'Wagnardsoft.DisplayDriverUninstaller' } }
    BtnReveil = @{ Logo = 'microsoft'; T = @{ fr = 'Voir ce qui réveille le PC'; en = 'See what wakes the PC' }; Tip = @{ fr = 'powercfg /lastwake, /waketimers, /requests dans une console.'; en = 'powercfg /lastwake, /waketimers, /requests in a console.' }; Action = { Console-Lancer 'powercfg' 'powercfg /lastwake; Write-Host ""; powercfg /waketimers; Write-Host ""; powercfg /requests' } }
    BtnEvenements = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir l Observateur d événements'; en = 'Open Event Viewer' }; Tip = @{ fr = 'Journaux Windows > Système, source WHEA-Logger.'; en = 'Windows Logs > System, source WHEA-Logger.' }; Action = { Ouvrir 'eventvwr.msc' } }
    BtnWlan = @{ Logo = 'microsoft'; T = @{ fr = 'Générer le rapport Wi-Fi'; en = 'Generate the Wi-Fi report' }; Tip = @{ fr = 'netsh wlan show wlanreport, puis ouvre le rapport HTML.'; en = 'netsh wlan show wlanreport, then opens the HTML report.' }; Action = { Console-Lancer 'wlanreport' 'netsh wlan show wlanreport; Start-Process "$env:ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html"' -Fermer } }
    BtnDefenderEnregistrer = @{ Logo = 'microsoft'; T = @{ fr = 'Enregistrer Defender (10 min)'; en = 'Record Defender (10 min)' }; Tip = @{ fr = 'New-MpPerformanceRecording : joue, puis Entrée dans la console pour arrêter.'; en = 'New-MpPerformanceRecording: play, then press Enter in the console to stop.' }; Action = { Console-Lancer 'Defender' 'New-MpPerformanceRecording -RecordTo C:\defender.etl' } }
    BtnDefenderRapport = @{ Logo = 'microsoft'; T = @{ fr = 'Lire le rapport Defender'; en = 'Read the Defender report' }; Tip = @{ fr = 'Get-MpPerformanceReport : les 10 fichiers et dossiers les plus scannés.'; en = 'Get-MpPerformanceReport: the 10 most scanned files and folders.' }; Action = { Console-Lancer 'Defender' 'Get-MpPerformanceReport -Path C:\defender.etl -TopFiles 10 -TopPaths 10' } }
    BtnDefenderExclusions = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir les exclusions Defender'; en = 'Open Defender exclusions' }; Tip = @{ fr = 'Sécurité Windows > Protection contre les virus > Paramètres > Exclusions.'; en = 'Windows Security > Virus protection > Settings > Exclusions.' }; Action = { Ouvrir 'windowsdefender://threatsettings' } }
    BtnCapframe = @{ Logo = 'cxworld'; T = @{ fr = 'Installer CapFrameX + PresentMon'; en = 'Install CapFrameX + PresentMon' }; Tip = @{ fr = 'Installe via winget. Mesurer avant / après : médiane, 1 % low, p99.'; en = 'Installs through winget. Measure before / after: median, 1% low, p99.' }; Action = { Winget-Installer 'CapFrameX + PresentMon' 'CXWorld.CapFrameX', 'Intel.PresentMon' } }

    BtnDnsTester = @{ Principal = $true; T = @{ fr = 'Tester les DNS (30 s)'; en = 'Test the DNS servers (30 s)' }; Tip = @{ fr = 'Une trentaine de secondes, ne change rien.'; en = 'About thirty seconds, changes nothing.' }; Action = { Dns-Tester } }
    BtnDnsAppliquer = @{ T = @{ fr = 'Utiliser le DNS sélectionné'; en = 'Use the selected DNS' }; Tip = @{ fr = 'Sur la carte testée. Tout remettre le rend.'; en = 'On the tested card. Restore puts it back.' }; Action = { $i = $Bagarre.DnsChoix; if ($i -lt 0) { Log $Bagarre.L.dnsSelection; return }; Dns-Appliquer $Bagarre.DnsAdapt $Bagarre.DnsResultats[$i] } }

    BtnCollecter = @{ T = @{ fr = 'Collecter le rapport (30 s)'; en = 'Collect the report (30 s)' }; Tip = @{ fr = 'Ne modifie rien. Écrit rapport-pc.txt et AUDIT.txt dans bagarre-audit sur le Bureau, et ouvre le dossier.'; en = 'Changes nothing. Writes rapport-pc.txt and AUDIT.txt into bagarre-audit on the Desktop, and opens the folder.' }; Action = { Audit-Collecter } }
    BtnPrompt = @{ T = @{ fr = "Copier le prompt d'audit"; en = 'Copy the audit prompt' }; Tip = @{ fr = 'Dans le presse-papiers, à coller dans ton IA.'; en = 'To the clipboard, paste it into your AI.' }; Action = { [Windows.Clipboard]::SetText($Textes[$Bagarre.Langue]['audit-prompt']); Log $Bagarre.L.promptCopie } }
    BtnDossierAudit = @{ T = @{ fr = 'Ouvrir le dossier du rapport'; en = 'Open the report folder' }; Tip = @{ fr = 'bagarre-audit sur le Bureau.'; en = 'bagarre-audit on the Desktop.' }; Action = { if (Test-Path $DossierAudit) { Ouvrir $DossierAudit } else { Log $Bagarre.L.pasRapport } } }

    BtnVoileRestauration = @{ Logo = 'microsoft'; Principal = $true; T = @{ fr = 'Créer un point de restauration'; en = 'Create a restore point' }; Tip = @{ fr = 'Checkpoint-Computer dans une console. Windows n en crée qu un par 24 h.'; en = 'Checkpoint-Computer in a console. Windows creates only one per 24 h.' }; Action = { Console-Lancer 'Point de restauration' "Enable-ComputerRestore -Drive '$($env:SystemDrive)\'; Checkpoint-Computer -Description 'avant bagarre' -RestorePointType MODIFY_SETTINGS; Get-ComputerRestorePoint | Select-Object -Last 3 | Format-Table -AutoSize" } }
    BtnVoileSauvegarde = @{ Logo = 'microsoft'; T = @{ fr = 'Sauvegarder mes fichiers'; en = 'Back up my files' }; Tip = @{ fr = 'Paramètres > Sauvegarde Windows.'; en = 'Settings > Windows Backup.' }; Action = { Ouvrir 'ms-settings:backup' } }
    BtnVoileContinuer = @{ T = @{ fr = 'Continuer quand même'; en = 'Continue anyway' }; Tip = @{ fr = 'Ferme cet avertissement.'; en = 'Closes this warning.' }; Action = { $Ctl.Voile.Visibility = 'Collapsed' } }
}

# Snappy : winget refuse le paquet en admin (le hash du zip ne correspond plus au manifeste), donc on prend l'URL du zip
# que winget connaît et on le télécharge nous-mêmes, puis on lance l'exe x64 dézippé.
function Snappy-Installer {
    $fr = $Bagarre.Langue -eq 'fr'
    $m = @{
        cherche = if ($fr) { 'Je demande à winget où est le zip de Snappy...' } else { 'Asking winget where the Snappy zip is...' }
        pasUrl  = if ($fr) { 'Pas trouvé l URL du zip, j ouvre la page de téléchargement à la place.' } else { 'Could not find the zip URL, opening the download page instead.' }
        telecharge = if ($fr) { 'Téléchargement de' } else { 'Downloading' }
        lance   = if ($fr) { 'Je lance' } else { 'Starting' }
        pasExe  = if ($fr) { 'Pas d exe x64 trouvé dans le zip, j ouvre le dossier.' } else { 'No x64 exe found in the zip, opening the folder.' }
    }
    $cmd = @"
Write-Host '$($m.cherche)'
`$fiche = winget show --id GlennDelahoy.SnappyDriverInstallerOrigin -e --accept-source-agreements | Out-String
`$url = [regex]::Match(`$fiche, 'https?://\S+\.zip').Value
if (-not `$url) { Write-Host '$($m.pasUrl)' -ForegroundColor Yellow; Start-Process 'https://www.glenn.delahoy.com/snappy-driver-installer-origin/'; return }
`$zip = Join-Path '$Dossier' 'sdio.zip'
`$dest = Join-Path '$Dossier' 'sdio'
Write-Host "$($m.telecharge) `$url"
Invoke-WebRequest -Uri `$url -OutFile `$zip -UseBasicParsing -ErrorAction Stop
Expand-Archive -Path `$zip -DestinationPath `$dest -Force -ErrorAction Stop
`$exe = Get-ChildItem -Path `$dest -Recurse -Filter 'SDIO_x64_*.exe' | Select-Object -First 1
if (`$exe) { Write-Host "$($m.lance) `$(`$exe.Name)"; Start-Process `$exe.FullName } else { Write-Host '$($m.pasExe)' -ForegroundColor Yellow; Start-Process `$dest }
"@
    Console-Lancer 'Snappy Driver Installer Origin' $cmd -Fermer
}

# ---------------------------------------------------------------------------
# La fenêtre : barre de titre maison (WindowChrome garde le déplacement, le redimensionnement, l'aimantation),
# rail des étapes à gauche, la page au centre. Tout tourne sur le thread de la fenêtre :
# Log, Dns-Mesurer, Collecter-Rapport et Appliquer-Items appellent Rafraichir pour qu'elle reste vivante.
# ---------------------------------------------------------------------------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$Xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="windows BAGARRE edition" Width="1320" Height="860" MinWidth="1040" MinHeight="700"
        WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="CanResize"
        Background="#15121C" Foreground="#ECE8F4" FontFamily="Segoe UI Variable Text, Segoe UI" FontSize="13"
        TextOptions.TextFormattingMode="Display" UseLayoutRounding="True" SnapsToDevicePixels="True">
  <WindowChrome.WindowChrome>
    <WindowChrome CaptionHeight="40" ResizeBorderThickness="6" GlassFrameThickness="0" CornerRadius="0" UseAeroCaptionButtons="False"/>
  </WindowChrome.WindowChrome>
  <Window.Resources>
    <SolidColorBrush x:Key="Fond" Color="#15121C"/>
    <SolidColorBrush x:Key="Rail" Color="#110E17"/>
    <SolidColorBrush x:Key="Surface" Color="#1E1A28"/>
    <SolidColorBrush x:Key="Surface2" Color="#262133"/>
    <SolidColorBrush x:Key="Bordure" Color="#2E2840"/>
    <SolidColorBrush x:Key="Texte" Color="#ECE8F4"/>
    <SolidColorBrush x:Key="Sourd" Color="#9B93AD"/>
    <SolidColorBrush x:Key="Accent" Color="#B794F6"/>
    <SolidColorBrush x:Key="AccentClair" Color="#D4BFFF"/>
    <SolidColorBrush x:Key="AccentFond" Color="#2C2340"/>
    <SolidColorBrush x:Key="SurAccent" Color="#1A1026"/>
    <SolidColorBrush x:Key="Alerte" Color="#F6C177"/>
    <SolidColorBrush x:Key="AlerteFond" Color="#2E2620"/>
    <SolidColorBrush x:Key="Ok" Color="#8FD3A0"/>

    <Style x:Key="Focus" TargetType="Control"><Setter Property="FocusVisualStyle" Value="{x:Null}"/></Style>

    <Style TargetType="Button">
      <Setter Property="Background" Value="{StaticResource Surface2}"/>
      <Setter Property="Foreground" Value="{StaticResource Texte}"/>
      <Setter Property="BorderBrush" Value="{StaticResource Bordure}"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="12,7"/>
      <Setter Property="Margin" Value="0,0,8,8"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Fond" Property="BorderBrush" Value="{StaticResource Accent}"/></Trigger>
              <Trigger Property="IsPressed" Value="True"><Setter TargetName="Fond" Property="Opacity" Value="0.8"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.4"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Principal" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
      <Setter Property="Background" Value="{StaticResource Accent}"/>
      <Setter Property="BorderBrush" Value="{StaticResource Accent}"/>
      <Setter Property="Foreground" Value="{StaticResource SurAccent}"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
    </Style>
    <Style x:Key="Petit" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
      <Setter Property="Padding" Value="8,1"/>
      <Setter Property="Margin" Value="6,0,0,0"/>
      <Setter Property="FontSize" Value="11"/>
      <Setter Property="Background" Value="Transparent"/>
    </Style>
    <Style x:Key="Drapeau" TargetType="Button">
      <Setter Property="Padding" Value="2"/>
      <Setter Property="Margin" Value="0,0,6,0"/>
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="BorderBrush" Value="Transparent"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="2" CornerRadius="5" Padding="{TemplateBinding Padding}">
              <ContentPresenter VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Fond" Property="BorderBrush" Value="{StaticResource Accent}"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Legende" TargetType="Button">
      <Setter Property="Width" Value="46"/>
      <Setter Property="Height" Value="40"/>
      <Setter Property="Margin" Value="0"/>
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="{StaticResource Sourd}"/>
      <Setter Property="FontFamily" Value="Segoe MDL2 Assets"/>
      <Setter Property="FontSize" Value="10"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
      <Setter Property="WindowChrome.IsHitTestVisibleInChrome" Value="True"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Fond" Property="Background" Value="{StaticResource Surface2}"/>
                <Setter Property="Foreground" Value="{StaticResource Texte}"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Fermer" TargetType="Button" BasedOn="{StaticResource Legende}">
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Fond" Property="Background" Value="#C42B1C"/>
                <Setter Property="Foreground" Value="White"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Etape" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
      <Setter Property="Background" Value="{StaticResource Surface}"/>
      <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
      <Setter Property="Padding" Value="14,12"/>
      <Setter Property="Margin" Value="0,0,10,10"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="1" CornerRadius="10" Padding="{TemplateBinding Padding}">
              <ContentPresenter/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Fond" Property="BorderBrush" Value="{StaticResource Accent}"/>
                <Setter TargetName="Fond" Property="Background" Value="{StaticResource Surface2}"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style TargetType="CheckBox">
      <Setter Property="Foreground" Value="{StaticResource Texte}"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="CheckBox">
            <Grid Background="Transparent">
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
              </Grid.ColumnDefinitions>
              <Border Name="Boite" Width="20" Height="20" CornerRadius="6" BorderThickness="2" BorderBrush="#5A5070" Background="#1A1524" VerticalAlignment="Center">
                <Path Name="Coche" Data="M3.5,8.5 L7,12 L12.5,4.5" Stroke="#1A1026" StrokeThickness="2.4" StrokeStartLineCap="Round" StrokeEndLineCap="Round" StrokeLineJoin="Round" Visibility="Collapsed"/>
              </Border>
              <ContentPresenter Grid.Column="1" Margin="10,0,0,0" VerticalAlignment="Center"/>
            </Grid>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Boite" Property="BorderBrush" Value="{StaticResource AccentClair}"/></Trigger>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Boite" Property="Background" Value="{StaticResource Accent}"/>
                <Setter TargetName="Boite" Property="BorderBrush" Value="{StaticResource Accent}"/>
                <Setter TargetName="Coche" Property="Visibility" Value="Visible"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.4"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style TargetType="TextBox">
      <Setter Property="Background" Value="{StaticResource Rail}"/>
      <Setter Property="Foreground" Value="#D6D0E2"/>
      <Setter Property="BorderBrush" Value="{StaticResource Bordure}"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="FontFamily" Value="Cascadia Mono, Consolas"/>
      <Setter Property="FontSize" Value="12"/>
      <Setter Property="Padding" Value="10,8"/>
      <Setter Property="IsReadOnly" Value="True"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
      <Setter Property="AcceptsReturn" Value="True"/>
      <Setter Property="VerticalScrollBarVisibility" Value="Auto"/>
      <Setter Property="CaretBrush" Value="{StaticResource Accent}"/>
      <Setter Property="SelectionBrush" Value="{StaticResource Accent}"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="TextBox">
            <Border Name="Fond" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
              <ScrollViewer x:Name="PART_ContentHost" Padding="0" BorderThickness="0" Background="Transparent"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="Fond" Property="BorderBrush" Value="{StaticResource Accent}"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Champ" TargetType="TextBox" BasedOn="{StaticResource {x:Type TextBox}}">
      <Setter Property="IsReadOnly" Value="False"/>
      <Setter Property="AcceptsReturn" Value="False"/>
      <Setter Property="FontFamily" Value="Segoe UI Variable Text, Segoe UI"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Padding" Value="10,5"/>
      <Setter Property="Background" Value="{StaticResource Surface}"/>
      <Setter Property="VerticalScrollBarVisibility" Value="Hidden"/>
    </Style>
    <Style x:Key="Commande" TargetType="TextBox" BasedOn="{StaticResource {x:Type TextBox}}">
      <Setter Property="Foreground" Value="{StaticResource AccentClair}"/>
      <Setter Property="Margin" Value="0,4,0,8"/>
      <Setter Property="VerticalScrollBarVisibility" Value="Disabled"/>
    </Style>

    <Style TargetType="ScrollBar">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Width" Value="8"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ScrollBar">
            <Grid Background="Transparent" Width="8">
              <Track Name="PART_Track" IsDirectionReversed="True">
                <Track.DecreaseRepeatButton><RepeatButton Command="ScrollBar.PageUpCommand" Opacity="0" Focusable="False"/></Track.DecreaseRepeatButton>
                <Track.IncreaseRepeatButton><RepeatButton Command="ScrollBar.PageDownCommand" Opacity="0" Focusable="False"/></Track.IncreaseRepeatButton>
                <Track.Thumb>
                  <Thumb>
                    <Thumb.Template>
                      <ControlTemplate TargetType="Thumb"><Border Background="#3A3350" CornerRadius="4" Margin="1"/></ControlTemplate>
                    </Thumb.Template>
                  </Thumb>
                </Track.Thumb>
              </Track>
            </Grid>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="ToolTip">
      <Setter Property="Background" Value="{StaticResource Surface2}"/>
      <Setter Property="Foreground" Value="{StaticResource Texte}"/>
      <Setter Property="BorderBrush" Value="{StaticResource Bordure}"/>
      <Setter Property="Padding" Value="10,6"/>
      <Setter Property="MaxWidth" Value="420"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ToolTip">
            <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="1" CornerRadius="8" Padding="{TemplateBinding Padding}">
              <ContentPresenter/>
            </Border>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
      <Style.Resources>
        <Style TargetType="TextBlock"><Setter Property="TextWrapping" Value="Wrap"/></Style>
      </Style.Resources>
    </Style>
    <Style TargetType="ProgressBar">
      <Setter Property="Foreground" Value="{StaticResource Accent}"/>
      <Setter Property="Background" Value="{StaticResource Surface2}"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ProgressBar">
            <Border Background="{TemplateBinding Background}" CornerRadius="3">
              <Grid>
                <Border Name="PART_Track"/>
                <Border Name="PART_Indicator" Background="{TemplateBinding Foreground}" CornerRadius="3" HorizontalAlignment="Left"/>
              </Grid>
            </Border>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style TargetType="ListBox">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
    </Style>
    <Style TargetType="ListBoxItem">
      <Setter Property="Foreground" Value="#C9C2D8"/>
      <Setter Property="Padding" Value="8,9"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ListBoxItem">
            <Border Name="Fond" Background="Transparent" CornerRadius="8" Padding="{TemplateBinding Padding}" Margin="0,1">
              <Grid>
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="3"/>
                  <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Border Name="Barre" Width="3" CornerRadius="2" Background="Transparent" Margin="0,2"/>
                <ContentPresenter Grid.Column="1" Margin="10,0,0,0"/>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Fond" Property="Background" Value="{StaticResource Surface}"/></Trigger>
              <Trigger Property="IsSelected" Value="True">
                <Setter TargetName="Fond" Property="Background" Value="{StaticResource Surface2}"/>
                <Setter TargetName="Barre" Property="Background" Value="{StaticResource Accent}"/>
                <Setter Property="Foreground" Value="{StaticResource Texte}"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style x:Key="Ligne" TargetType="Border">
      <Setter Property="Padding" Value="10,6"/>
      <Setter Property="Margin" Value="0,1"/>
      <Setter Property="CornerRadius" Value="8"/>
      <Setter Property="Background" Value="Transparent"/>
      <Style.Triggers>
        <Trigger Property="IsMouseOver" Value="True"><Setter Property="Background" Value="{StaticResource Surface}"/></Trigger>
      </Style.Triggers>
    </Style>
    <Style x:Key="Groupe" TargetType="TextBlock">
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Foreground" Value="{StaticResource Accent}"/>
    </Style>
    <Style x:Key="Etiquette" TargetType="TextBlock">
      <Setter Property="Foreground" Value="{StaticResource Accent}"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="FontSize" Value="12"/>
      <Setter Property="Margin" Value="0,14,0,3"/>
    </Style>
  </Window.Resources>

  <Border Name="Cadre" BorderBrush="#2E2840" BorderThickness="1" Background="#15121C">
    <Grid Name="Racine">
      <Grid.RowDefinitions>
        <RowDefinition Height="40"/>
        <RowDefinition Height="*"/>
      </Grid.RowDefinitions>
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="236"/>
        <ColumnDefinition Width="*"/>
      </Grid.ColumnDefinitions>

      <!-- barre de titre -->
      <Grid Grid.Row="0" Grid.ColumnSpan="2" Background="#110E17">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <TextBlock Name="TitreBarre" Grid.ColumnSpan="3" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="13" FontWeight="SemiBold" Foreground="#ECE8F4" IsHitTestVisible="False"/>
        <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,10,0" WindowChrome.IsHitTestVisibleInChrome="True">
          <Button Name="BtnFr" Style="{StaticResource Drapeau}"><Border Name="DrapeauFr" Width="24" Height="16" CornerRadius="3"/></Button>
          <Button Name="BtnEn" Style="{StaticResource Drapeau}"><Border Name="DrapeauEn" Width="24" Height="16" CornerRadius="3"/></Button>
        </StackPanel>
        <StackPanel Grid.Column="2" Orientation="Horizontal">
          <Button Name="BtnReduire" Content="&#xE921;" Style="{StaticResource Legende}"/>
          <Button Name="BtnAgrandir" Content="&#xE922;" Style="{StaticResource Legende}"/>
          <Button Name="BtnFermer" Content="&#xE8BB;" Style="{StaticResource Fermer}"/>
        </StackPanel>
      </Grid>

      <!-- rail des étapes -->
      <Border Grid.Row="1" Grid.Column="0" Background="#110E17">
        <ListBox Name="Nav" Margin="10,12,10,0"/>
      </Border>

      <!-- la page -->
      <Grid Grid.Row="1" Grid.Column="1" Margin="28,18,24,14">
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <TextBlock Grid.Row="0" Name="TitrePage" FontSize="22" FontWeight="SemiBold" TextWrapping="Wrap" Margin="0,0,0,14"/>

        <Grid Grid.Row="1" Name="Pages">
          <Grid Name="PageOptis" Visibility="Collapsed">
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <DockPanel Grid.Row="0" LastChildFill="False">
              <WrapPanel Name="BarreOptis" DockPanel.Dock="Left"/>
              <Grid DockPanel.Dock="Right" Width="220" Margin="8,0,0,8">
                <TextBox Name="Filtre" Style="{StaticResource Champ}"/>
                <TextBlock Name="FiltreIndice" Foreground="#6E6683" Margin="11,0,0,0" VerticalAlignment="Center" IsHitTestVisible="False"/>
              </Grid>
            </DockPanel>
            <TextBlock Grid.Row="1" Name="Legende" Foreground="#9B93AD" TextWrapping="Wrap" Margin="0,2,0,10" LineHeight="18"/>
            <Grid Grid.Row="2">
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="350"/>
              </Grid.ColumnDefinitions>
              <ScrollViewer Grid.Column="0" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled" Padding="0,0,10,0">
                <StackPanel Name="ListeOptis"/>
              </ScrollViewer>
              <Border Grid.Column="1" Background="#1E1A28" BorderBrush="#2E2840" BorderThickness="1" CornerRadius="10" Padding="16" Margin="12,0,0,0">
                <DockPanel>
                  <WrapPanel Name="VoletOptis" DockPanel.Dock="Bottom" Margin="0,12,0,0"/>
                  <ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                    <StackPanel Margin="0,0,6,0">
                      <TextBlock Name="OptiTitre" FontWeight="SemiBold" FontSize="14" TextWrapping="Wrap" LineHeight="20"/>
                      <TextBlock Name="OptiEtiquette1" Style="{StaticResource Etiquette}"/>
                      <TextBlock Name="OptiPourquoi" TextWrapping="Wrap" Foreground="#D6D0E2" LineHeight="19"/>
                      <TextBlock Name="OptiEtiquette2" Style="{StaticResource Etiquette}"/>
                      <TextBlock Name="OptiAttention" TextWrapping="Wrap" Foreground="#D6D0E2" LineHeight="19"/>
                    </StackPanel>
                  </ScrollViewer>
                </DockPanel>
              </Border>
            </Grid>
          </Grid>
        </Grid>

        <ProgressBar Grid.Row="2" Name="Progression" Height="5" Minimum="0" Maximum="100" Visibility="Collapsed" Margin="0,10,0,0"/>
      </Grid>

      <!-- voile : installation pas récente -->
      <Grid Name="Voile" Grid.Row="1" Grid.ColumnSpan="2" Background="#E015121C" Visibility="Collapsed">
        <Border Width="600" Background="#1E1A28" BorderBrush="#2E2840" BorderThickness="1" CornerRadius="14" Padding="30,26" VerticalAlignment="Center" HorizontalAlignment="Center">
          <StackPanel>
            <Border Width="200" Height="200" CornerRadius="12" HorizontalAlignment="Center" Margin="0,0,0,20">
              <Border.Background><ImageBrush x:Name="VoileImage" Stretch="UniformToFill"/></Border.Background>
            </Border>
            <TextBlock Name="VoileTitre" FontSize="22" FontWeight="SemiBold" TextWrapping="Wrap" TextAlignment="Center" LineHeight="30"/>
            <TextBlock Name="VoileTexte" Foreground="#9B93AD" FontSize="14" TextWrapping="Wrap" TextAlignment="Center" Margin="0,10,0,24" LineHeight="22"/>
            <StackPanel Name="VoileBoutons" Orientation="Horizontal" HorizontalAlignment="Center"/>
            <StackPanel Name="VoileSuite" HorizontalAlignment="Center" Margin="0,6,0,0"/>
          </StackPanel>
        </Border>
      </Grid>
    </Grid>
  </Border>
</Window>
'@

try {
    $Fenetre = [Windows.Markup.XamlReader]::Parse($Xaml)
} catch {
    Add-Content -Path $LogFichier -Value "ÉCHEC fenêtre : $_"
    [Windows.MessageBox]::Show("La fenêtre n'a pas pu s'ouvrir :`n$_`n`nDétail dans $LogFichier", 'bagarre') | Out-Null
    return
}

# Tous les contrôles nommés dans $Ctl. Le journal reste dans le fichier et la console, pas dans la fenêtre.
$Ctl = @{}
foreach ($m in [regex]::Matches($Xaml, '(?<!\w)(?:x:)?Name="(\w+)"')) { $n = $m.Groups[1].Value; $Ctl[$n] = $Fenetre.FindName($n) }
$Ctl.TitreBarre.Text = "windows BAGARRE edition v$Version"
$Fenetre.Title = $Ctl.TitreBarre.Text
$Pinceau = @{}
foreach ($k in 'Fond', 'Rail', 'Surface', 'Surface2', 'Bordure', 'Texte', 'Sourd', 'Accent', 'AccentClair', 'AccentFond', 'SurAccent', 'Alerte', 'AlerteFond', 'Ok') { $Pinceau[$k] = $Fenetre.FindResource($k) }
# Les deux drapeaux (images embarquées par build.ps1)
foreach ($paire in @(@('DrapeauFr', 'drapeau-fr'), @('DrapeauEn', 'drapeau-en'))) {
    $img = Logo-Image $paire[1]
    if ($img) { $brosse = New-Object Windows.Media.ImageBrush $img; $brosse.Stretch = 'UniformToFill'; $Ctl[$paire[0]].Background = $brosse }   # pas $pinceau : écraserait $Pinceau
}

# ---------------------------------------------------------------------------
# Barre de titre maison : réduire, agrandir / restaurer, fermer. Le déplacement, le double-clic et les bords
# de redimensionnement sont gérés par WindowChrome. Agrandie, la fenêtre déborde de 8 px : marge compensée.
# ---------------------------------------------------------------------------
$Ctl.BtnReduire.Add_Click({ $Fenetre.WindowState = 'Minimized' })
$Ctl.BtnAgrandir.Add_Click({ $Fenetre.WindowState = if ($Fenetre.WindowState -eq 'Maximized') { 'Normal' } else { 'Maximized' } })
$Ctl.BtnFermer.Add_Click({ $Fenetre.Close() })
$Fenetre.Add_StateChanged({
    if ($Fenetre.WindowState -eq 'Maximized') { $Ctl.Cadre.Margin = '8'; $Ctl.Cadre.BorderThickness = '0'; $Ctl.BtnAgrandir.Content = [string][char]0xE923 }
    else { $Ctl.Cadre.Margin = '0'; $Ctl.Cadre.BorderThickness = '1'; $Ctl.BtnAgrandir.Content = [string][char]0xE922 }
})
# Coins arrondis Windows 11 (DWMWA_WINDOW_CORNER_PREFERENCE = 33, DWMWCP_ROUND = 2). Ignoré ailleurs.
if (-not $Capture) {
    try { Add-Type -Namespace Bagarre -Name Dwm -MemberDefinition '[DllImport("dwmapi.dll")] public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int value, int size);' -ErrorAction Stop } catch {}
    $Fenetre.Add_SourceInitialized({
        try { $h = (New-Object Windows.Interop.WindowInteropHelper $Fenetre).Handle; $v = 2; [void][Bagarre.Dwm]::DwmSetWindowAttribute($h, 33, [ref]$v, 4) } catch {}
    })
    # Tout tourne sur le thread de la fenêtre. Quand une action dépasse 5 s sans repasser par la boucle de messages (test DNS,
    # collecte, application), Windows dessine une copie figée de la fenêtre par-dessus (le "fantôme" des applis qui ne répondent
    # pas), et on voit deux fenêtres dont une morte. Rafraichir la garde vivante ; ceci coupe le fantôme si une étape est plus longue.
    try {
        Add-Type -Namespace Bagarre -Name User32 -MemberDefinition '[DllImport("user32.dll")] public static extern void DisableProcessWindowsGhosting();' -ErrorAction Stop
        [Bagarre.User32]::DisableProcessWindowsGhosting()
    } catch {}
}

# ---------------------------------------------------------------------------
# Briques : texte, carte, bouton avec logo
# ---------------------------------------------------------------------------
function Bloc-Texte($texte, $pinceau, $taille, $ligne) {
    $t = New-Object Windows.Controls.TextBlock
    $t.Text = $texte; $t.TextWrapping = 'Wrap'; $t.Foreground = $pinceau; $t.FontSize = $taille; $t.LineHeight = $ligne; $t.Margin = '0,0,0,6'
    $t
}
function Carte-Creer($titre) {
    $b = New-Object Windows.Controls.Border
    $b.Background = $Pinceau.Surface; $b.BorderBrush = $Pinceau.Bordure; $b.BorderThickness = '1'; $b.CornerRadius = '10'; $b.Padding = '18,14,18,10'; $b.Margin = '0,0,0,10'
    $pile = New-Object Windows.Controls.StackPanel
    $t = New-Object Windows.Controls.TextBlock
    $t.Text = $titre; $t.FontSize = 15; $t.FontWeight = 'SemiBold'; $t.TextWrapping = 'Wrap'; $t.Margin = '0,0,0,8'
    [void]$pile.Children.Add($t)
    $b.Child = $pile
    @{ Bord = $b; Pile = $pile }
}
function Detacher($ctl) {
    $p = $ctl.Parent
    if ($p -is [Windows.Controls.Panel]) { [void]$p.Children.Remove($ctl) }
}
$BoutonsCtl = @{}
function Bouton-Obtenir($id) {
    if ($BoutonsCtl[$id]) { Detacher $BoutonsCtl[$id]; return $BoutonsCtl[$id] }
    $def = $Boutons[$id]
    if (-not $def) { return $null }
    $b = New-Object Windows.Controls.Button
    if ($def.Principal) { $b.Style = $Fenetre.FindResource('Principal') }
    $sp = New-Object Windows.Controls.StackPanel
    $sp.Orientation = 'Horizontal'
    $img = if ($def.Logo) { Logo-Image $def.Logo } else { $null }
    if ($img) {
        $logo = New-Object Windows.Controls.Border
        $logo.Width = 20; $logo.Height = 20; $logo.CornerRadius = '5'; $logo.Margin = '0,0,9,0'; $logo.VerticalAlignment = 'Center'
        $pinceau = New-Object Windows.Media.ImageBrush $img
        $pinceau.Stretch = 'UniformToFill'
        $logo.Background = $pinceau
        [void]$sp.Children.Add($logo)
    }
    $t = New-Object Windows.Controls.TextBlock
    $t.VerticalAlignment = 'Center'
    [void]$sp.Children.Add($t)
    $b.Content = $sp
    $b.Tag = $id
    $b.Add_Click($def.Action)
    $def.Label = $t; $def.Ctl = $b
    $BoutonsCtl[$id] = $b; $Ctl[$id] = $b
    $b
}
function Boutons-Libeller {
    foreach ($id in $BoutonsCtl.Keys) { $d = $Boutons[$id]; $d.Label.Text = $d.T[$Bagarre.Langue]; $d.Ctl.ToolTip = $d.Tip[$Bagarre.Langue] }
}

# Une page depuis son texte balisé. Les blocs avant la première "## " sont l'intro, en plus grand.
function Page-Construire($nom) {
    $conteneur = $Ctl["Contenu$nom"]
    $conteneur.Children.Clear()
    $cle = if ($nom -eq 'Nvidia' -and $EstAmd) { 'amd' } else { $nom.ToLower() }   # l'étape 4 est la page de TA carte
    $texte = $Textes[$Bagarre.Langue][$cle]
    if (-not $texte) { return }
    $pile = $conteneur; $intro = $true
    foreach ($ligne in ($texte -split "`r?`n")) {
        if ($ligne -match '^## (.+)$') {
            $carte = Carte-Creer $Matches[1]
            [void]$conteneur.Children.Add($carte.Bord)
            $pile = $carte.Pile; $intro = $false
            continue
        }
        if ($ligne.Trim() -eq '') { continue }
        if ($ligne -match '^@(.+)$') {
            $wp = New-Object Windows.Controls.WrapPanel
            $wp.Margin = '0,4,0,2'
            foreach ($id in ($Matches[1] -split ',')) {
                $id = $id.Trim()
                $c = switch ($id) { 'DnsListe' { $Ctl.DnsPanneau } default { Bouton-Obtenir $id } }
                if ($c) { Detacher $c; [void]$wp.Children.Add($c) }
            }
            [void]$pile.Children.Add($wp)
        } elseif ($ligne -match '^! (.+)$') {
            $b = New-Object Windows.Controls.Border
            $b.Background = $Pinceau.AlerteFond; $b.BorderBrush = $Pinceau.Alerte; $b.BorderThickness = '3,0,0,0'; $b.CornerRadius = '4'; $b.Padding = '12,8'; $b.Margin = '0,2,0,8'
            $t = Bloc-Texte $Matches[1] $Pinceau.Texte 13 19; $t.Margin = '0'
            $b.Child = $t
            [void]$pile.Children.Add($b)
        } elseif ($ligne -match '^> (.+)$') {
            $t = New-Object Windows.Controls.TextBox
            $t.Style = $Fenetre.FindResource('Commande'); $t.Text = $Matches[1]
            [void]$pile.Children.Add($t)
        } elseif ($ligne -match '^- (.+)$') {
            $g = New-Object Windows.Controls.Grid
            $c1 = New-Object Windows.Controls.ColumnDefinition; $c1.Width = 'Auto'; [void]$g.ColumnDefinitions.Add($c1)
            $c2 = New-Object Windows.Controls.ColumnDefinition; [void]$g.ColumnDefinitions.Add($c2)
            $puce = New-Object Windows.Controls.Border
            $puce.Width = 6; $puce.Height = 6; $puce.CornerRadius = '3'; $puce.Background = $Pinceau.Accent; $puce.Margin = '2,7,10,0'; $puce.VerticalAlignment = 'Top'
            $t = Bloc-Texte $Matches[1] $Pinceau.Texte 13 19; $t.Margin = '0,0,0,5'
            [Windows.Controls.Grid]::SetColumn($t, 1)
            [void]$g.Children.Add($puce); [void]$g.Children.Add($t)
            [void]$pile.Children.Add($g)
        } else {
            $t = if ($intro) { Bloc-Texte $ligne $Pinceau.Sourd 14 22 } else { Bloc-Texte $ligne $Pinceau.Texte 13 19 }
            if ($intro) { $t.Margin = '0,0,0,8' }
            [void]$pile.Children.Add($t)
        }
    }
    if ($intro) { return }
    $conteneur.Children[$conteneur.Children.Count - 1].Margin = '0'
}

# Une page par étape : un ScrollViewer et sa pile, sauf le script à cocher qui est dans le XAML
foreach ($n in $PagesNoms) {
    if ($n -eq 'Optis') { continue }
    $sv = New-Object Windows.Controls.ScrollViewer
    $sv.VerticalScrollBarVisibility = 'Auto'; $sv.HorizontalScrollBarVisibility = 'Disabled'; $sv.Visibility = 'Collapsed'; $sv.Padding = '0,0,10,0'
    $sv.MaxWidth = 940; $sv.HorizontalAlignment = 'Left'   # lignes lisibles, la barre de défilement colle aux cartes
    $pile = New-Object Windows.Controls.StackPanel
    $sv.Content = $pile
    $Ctl["Page$n"] = $sv; $Ctl["Contenu$n"] = $pile
    [void]$Ctl.Pages.Children.Add($sv)
}

# ---------------------------------------------------------------------------
# Navigation : rail à gauche, titre de page, cartes d'étapes sur l'accueil
# ---------------------------------------------------------------------------
$NavItems = @()
for ($k = 0; $k -lt $PagesNoms.Count; $k++) {
    $li = New-Object Windows.Controls.ListBoxItem
    $g = New-Object Windows.Controls.Grid
    foreach ($w in 'Auto', '*') { $cd = New-Object Windows.Controls.ColumnDefinition; $cd.Width = $w; [void]$g.ColumnDefinitions.Add($cd) }
    $num = New-Object Windows.Controls.TextBlock
    $num.Text = if ($k -eq 0) { '' } else { "$k" }; $num.Width = 18; $num.Foreground = $Pinceau.Accent; $num.FontWeight = 'SemiBold'; $num.FontSize = 12; $num.VerticalAlignment = 'Center'
    $nom = New-Object Windows.Controls.TextBlock
    $nom.FontSize = 13; $nom.VerticalAlignment = 'Center'
    [Windows.Controls.Grid]::SetColumn($nom, 1)
    [void]$g.Children.Add($num); [void]$g.Children.Add($nom)
    $li.Content = $g
    [void]$Ctl.Nav.Items.Add($li)
    $NavItems += @{ Nom = $nom }
}
function Aller($k) { $Ctl.Nav.SelectedIndex = $k }
function Entete-Poser {
    $i = $Ctl.Nav.SelectedIndex
    if ($i -lt 0) { return }
    $Ctl.TitrePage.Text = $Bagarre.L.titres[$PagesNoms[$i]]
}
$Ctl.Nav.Add_SelectionChanged({
    $i = $Ctl.Nav.SelectedIndex
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) {
        $Ctl["Page$($PagesNoms[$k])"].Visibility = if ($k -eq $i) { 'Visible' } else { 'Collapsed' }
    }
    Entete-Poser
})

# Les huit étapes en cartes sur l'accueil, insérées après l'intro
function Etapes-Construire {
    $L = $Bagarre.L
    $grille = New-Object Windows.Controls.Primitives.UniformGrid
    $grille.Columns = 2; $grille.Margin = '0,6,0,12'
    for ($k = 1; $k -lt $PagesNoms.Count; $k++) {
        $carte = New-Object Windows.Controls.Button
        $carte.Style = $Fenetre.FindResource('Etape'); $carte.Tag = $k
        $g = New-Object Windows.Controls.Grid
        foreach ($w in 'Auto', '*') { $cd = New-Object Windows.Controls.ColumnDefinition; $cd.Width = $w; [void]$g.ColumnDefinitions.Add($cd) }
        $num = New-Object Windows.Controls.TextBlock
        $num.Text = "$k"; $num.FontSize = 26; $num.FontWeight = 'Bold'; $num.Foreground = $Pinceau.Accent; $num.Width = 36; $num.VerticalAlignment = 'Top'; $num.Margin = '0,-4,0,0'
        $pile = New-Object Windows.Controls.StackPanel
        [Windows.Controls.Grid]::SetColumn($pile, 1)
        $nom = New-Object Windows.Controls.TextBlock
        $nom.Text = $L.nav[$k]; $nom.FontSize = 14; $nom.FontWeight = 'SemiBold'
        $resume = New-Object Windows.Controls.TextBlock
        $resume.Text = $L.resume[$k]; $resume.Foreground = $Pinceau.Sourd; $resume.TextWrapping = 'Wrap'; $resume.Margin = '0,3,0,0'; $resume.FontSize = 12
        [void]$pile.Children.Add($nom); [void]$pile.Children.Add($resume)
        [void]$g.Children.Add($num); [void]$g.Children.Add($pile)
        $carte.Content = $g
        $carte.Add_Click({ param($s, $e) Aller ([int]$s.Tag) })
        [void]$grille.Children.Add($carte)
    }
    # après les paragraphes d'intro, avant les boutons
    $enfants = $Ctl.ContenuAccueil.Children
    $i = 0
    while ($i -lt $enfants.Count -and $enfants[$i] -is [Windows.Controls.TextBlock]) { $i++ }
    $enfants.Insert($i, $grille)
}

# ---------------------------------------------------------------------------
# Le script à cocher : une ligne par item, [case] [étiquette] titre ...... état. L'explication au survol.
# ---------------------------------------------------------------------------
function Opti-Montrer($titre, $pourquoi, $attention) {
    $Ctl.OptiTitre.Text = $titre
    $Ctl.OptiPourquoi.Text = $pourquoi
    $Ctl.OptiAttention.Text = if ($attention) { $attention } else { $Bagarre.L.rien }
    $Ctl.OptiEtiquette1.Visibility = 'Visible'
    $Ctl.OptiEtiquette2.Visibility = if ($null -eq $attention) { 'Collapsed' } else { 'Visible' }
}
function Opti-Vider {
    $Ctl.OptiTitre.Text = $Bagarre.L.survole
    $Ctl.OptiPourquoi.Text = ''; $Ctl.OptiAttention.Text = ''
    $Ctl.OptiEtiquette1.Visibility = 'Collapsed'; $Ctl.OptiEtiquette2.Visibility = 'Collapsed'
}
function Compter-Coches {
    $n = @($Items | Where-Object { $_.Coche }).Count
    if ($Boutons.BtnAppliquer.Label) { $Boutons.BtnAppliquer.Label.Text = switch ($n) { 0 { $Bagarre.L.appliquer0 } 1 { $Bagarre.L.appliquer1 } default { $Bagarre.L.appliquerN -f $n } } }
    foreach ($g in $Groupes) {
        $c = @($g.Ids | Where-Object { $Lignes[$_].Cb.IsChecked }).Count
        $g.Compte.Text = "$c / $($g.Ids.Count) $($Bagarre.L.coches)"
    }
}

# L'étiquette colorée devant chaque ligne : ce que la case fait une fois cochée
$Etiquettes = @{
    off = @{ fr = 'DÉSACTIVER'; en = 'TURN OFF'; couleur = '#F08A8A' }
    on  = @{ fr = 'ACTIVER'; en = 'TURN ON'; couleur = '#8FD3A0' }
    set = @{ fr = 'RÉGLER'; en = 'SET'; couleur = '#8AB8F0' }
}
$Lignes = @{}    # id -> Cb, Contenu, PillT, Titre, Statut, Ligne, Item
$Defauts = @{}
$Groupes = @()   # un objet par groupe : Nom, Entete, Titre, Compte, Tout, Rien, Ids
$Etat = @{}      # id -> résultat de la détection ($true déjà fait)

function Ligne-Creer($it) {
    $cb = New-Object Windows.Controls.CheckBox
    $cb.IsChecked = [bool]$it.Coche; $cb.Tag = $it
    $g = New-Object Windows.Controls.Grid
    foreach ($w in 'Auto', '*', 'Auto') { $cd = New-Object Windows.Controls.ColumnDefinition; $cd.Width = $w; [void]$g.ColumnDefinitions.Add($cd) }
    $action = Item-Action $it
    $pill = New-Object Windows.Controls.Border
    $pill.Background = $Etiquettes[$action].couleur; $pill.CornerRadius = '4'; $pill.Padding = '0,2'; $pill.Margin = '0,0,10,0'; $pill.Width = 84; $pill.VerticalAlignment = 'Center'
    $pt = New-Object Windows.Controls.TextBlock
    $pt.FontSize = 10; $pt.FontWeight = 'Bold'; $pt.Foreground = '#1A1026'; $pt.TextAlignment = 'Center'; $pt.Tag = $action
    $pill.Child = $pt
    $titre = New-Object Windows.Controls.TextBlock
    $titre.VerticalAlignment = 'Center'; $titre.TextWrapping = 'Wrap'
    [Windows.Controls.Grid]::SetColumn($titre, 1)
    $statut = New-Object Windows.Controls.TextBlock
    $statut.FontSize = 11; $statut.Margin = '14,0,4,0'; $statut.VerticalAlignment = 'Center'
    [Windows.Controls.Grid]::SetColumn($statut, 2)
    [void]$g.Children.Add($pill); [void]$g.Children.Add($titre); [void]$g.Children.Add($statut)
    $cb.Content = $g
    $cb.Add_MouseEnter({ param($s, $e) Opti-Montrer (Item-Titre $s.Tag) (Item-Pourquoi $s.Tag) (Item-Attention $s.Tag) })
    $cb.Add_Checked({ param($s, $e) $s.Tag.Coche = $true; Ligne-Etat $s.Tag.Id; Compter-Coches })
    $cb.Add_Unchecked({ param($s, $e) $s.Tag.Coche = $false; Ligne-Etat $s.Tag.Id; Compter-Coches })
    $ligne = New-Object Windows.Controls.Border
    $ligne.Style = $Fenetre.FindResource('Ligne')
    $ligne.Child = $cb
    $Lignes[$it.Id] = @{ Cb = $cb; Contenu = $g; PillT = $pt; Titre = $titre; Statut = $statut; Ligne = $ligne; Item = $it }
    $ligne
}
# L'état à droite de la ligne : sera fait / déjà fait / laissé tel quel. Une ligne décochée s'efface un peu.
function Ligne-Etat($id) {
    $row = $Lignes[$id]; $L = $Bagarre.L   # pas $l : PowerShell ne distingue pas $l de $L
    if ($row.Cb.IsChecked) { $row.Statut.Text = $L.seraFait; $row.Statut.Foreground = $Pinceau.AccentClair; $row.Contenu.Opacity = 1 }
    elseif ($Etat[$id] -eq $true) { $row.Statut.Text = $L.dejaFait; $row.Statut.Foreground = $Pinceau.Ok; $row.Contenu.Opacity = 0.75 }
    else { $row.Statut.Text = $L.laisse; $row.Statut.Foreground = $Pinceau.Sourd; $row.Contenu.Opacity = 0.6 }
}
function Ligne-Libeller($id) {
    $l = $Lignes[$id]
    $l.PillT.Text = $Etiquettes[$l.PillT.Tag][$Bagarre.Langue]
    $l.Titre.Text = Item-Titre $l.Item
    Ligne-Etat $id
}

$groupe = $null
foreach ($it in $Items) {
    if (-not $groupe -or $it.Groupe -ne $groupe.Nom) {
        $entete = New-Object Windows.Controls.DockPanel
        $entete.Margin = '10,16,4,6'; $entete.LastChildFill = $false
        $tb = New-Object Windows.Controls.TextBlock
        $tb.Style = $Fenetre.FindResource('Groupe'); $tb.VerticalAlignment = 'Center'
        $compte = New-Object Windows.Controls.TextBlock
        $compte.Foreground = $Pinceau.Sourd; $compte.Margin = '10,0,0,0'; $compte.VerticalAlignment = 'Center'; $compte.FontSize = 11
        $tout = New-Object Windows.Controls.Button; $tout.Style = $Fenetre.FindResource('Petit'); $tout.Margin = '14,0,0,0'
        $rien = New-Object Windows.Controls.Button; $rien.Style = $Fenetre.FindResource('Petit')
        foreach ($c in $tb, $compte, $tout, $rien) { [Windows.Controls.DockPanel]::SetDock($c, 'Left'); [void]$entete.Children.Add($c) }
        [void]$Ctl.ListeOptis.Children.Add($entete)
        $groupe = @{ Nom = $it.Groupe; Entete = $entete; Titre = $tb; Compte = $compte; Tout = $tout; Rien = $rien; Ids = @() }
        $tout.Tag = $groupe; $rien.Tag = $groupe
        $tout.Add_Click({ param($s, $e) foreach ($x in $s.Tag.Ids) { if ($Lignes[$x].Ligne.Visibility -eq 'Visible') { $Lignes[$x].Cb.IsChecked = $true } } })
        $rien.Add_Click({ param($s, $e) foreach ($x in $s.Tag.Ids) { if ($Lignes[$x].Ligne.Visibility -eq 'Visible') { $Lignes[$x].Cb.IsChecked = $false } } })
        $Groupes += $groupe
    }
    [void]$Ctl.ListeOptis.Children.Add((Ligne-Creer $it))
    $groupe.Ids += $it.Id
    $Defauts[$it.Id] = [bool]$it.Coche
}

# Barre du script à cocher et volet : les boutons de zone Barre et Volet, créés une fois
foreach ($id in 'BtnAppliquer', 'BtnDefaut', 'BtnDetecter', 'BtnRestaurer') { [void]$Ctl.BarreOptis.Children.Add((Bouton-Obtenir $id)) }
foreach ($id in 'BtnReseau', 'BtnImgProtocoles', 'BtnImgAvance', 'BtnJournal') { $b = Bouton-Obtenir $id; $b.Margin = '0,8,8,0'; $b.Padding = '10,5'; $b.FontSize = 12; [void]$Ctl.VoletOptis.Children.Add($b) }

# Filtre : tape un mot, seules les lignes dont le titre (ou le nom du groupe) le contient restent, les groupes vides disparaissent
function Filtrer {
    $f = $Ctl.Filtre.Text.Trim()
    foreach ($g in $Groupes) {
        $visibles = 0
        $groupeOk = ($f -ne '') -and ($g.Titre.Text.IndexOf($f, [StringComparison]::OrdinalIgnoreCase) -ge 0)
        foreach ($id in $g.Ids) {
            $ok = ($f -eq '') -or $groupeOk -or ((Item-Titre $Lignes[$id].Item).IndexOf($f, [StringComparison]::OrdinalIgnoreCase) -ge 0)
            $Lignes[$id].Ligne.Visibility = if ($ok) { 'Visible' } else { 'Collapsed' }
            if ($ok) { $visibles++ }
        }
        $g.Entete.Visibility = if ($visibles -gt 0) { 'Visible' } else { 'Collapsed' }
    }
}
$Ctl.Filtre.Add_TextChanged({ $Ctl.FiltreIndice.Visibility = if ($Ctl.Filtre.Text) { 'Collapsed' } else { 'Visible' }; Filtrer })

# Détection de ce qui est déjà en place : les items déjà faits sont décochés et marqués
function Detecter-Tout {
    Log $Bagarre.L.detection
    Rafraichir
    $faits = 0
    foreach ($it in $Items) {
        $r = Detecter-Item $it
        $Etat[$it.Id] = $r
        if ($r -eq $true) { $Lignes[$it.Id].Cb.IsChecked = $false; $faits++ }
        Ligne-Etat $it.Id
    }
    Log ($Bagarre.L.detectionFin -f $faits)
    Compter-Coches
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
    if ($coches.Count -eq 0) { Log $Bagarre.L.rienCoche; return }
    $q = [Windows.MessageBox]::Show(($Bagarre.L.confirmAppliquer -f $coches.Count, $EtatFichier), 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Appliquer-Items $coches
    Detecter-Tout
    [Windows.MessageBox]::Show($Bagarre.L.termine, 'bagarre') | Out-Null
}
function Restaurer-Demander {
    if ($Avant.Count -eq 0) { Log $Bagarre.L.rienRestaurer; return }
    $q = [Windows.MessageBox]::Show(($Bagarre.L.confirmRestaurer -f $Avant.Count), 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Tout-Restaurer
    Detecter-Tout
    [Windows.MessageBox]::Show($Bagarre.L.restaure, 'bagarre') | Out-Null
}
function Journal-Ouvrir { if (Test-Path $LogFichier) { Start-Process notepad $LogFichier } else { Log $Bagarre.L.pasJournal } }

# ---------------------------------------------------------------------------
# DNS : les résultats en lignes cliquables, logo, barre proportionnelle (panneau posé par "@DnsListe")
# ---------------------------------------------------------------------------
$Bagarre.DnsAdapt = $null
$Bagarre.DnsResultats = @()
$Bagarre.DnsChoix = -1
$Ctl.DnsPanneau = New-Object Windows.Controls.StackPanel
$Ctl.DnsPanneau.Margin = '0,2,0,4'; $Ctl.DnsPanneau.MinWidth = 600
$Ctl.DnsCarte = New-Object Windows.Controls.TextBlock
$Ctl.DnsCarte.Foreground = $Pinceau.Sourd; $Ctl.DnsCarte.TextWrapping = 'Wrap'; $Ctl.DnsCarte.Margin = '0,0,0,8'
$Ctl.DnsListe = New-Object Windows.Controls.StackPanel
[void]$Ctl.DnsPanneau.Children.Add($Ctl.DnsCarte); [void]$Ctl.DnsPanneau.Children.Add($Ctl.DnsListe)

function Dns-Choisir($i) {
    $Bagarre.DnsChoix = $i
    foreach ($row in $Ctl.DnsListe.Children) { $row.BorderBrush = if ([int]$row.Tag -eq $i) { $Pinceau.Accent } else { $Pinceau.Bordure } }
    $Ctl.BtnDnsAppliquer.IsEnabled = $i -ge 0
}
function Dns-Ligne($i, $r, $max) {
    $row = New-Object Windows.Controls.Border
    $row.Tag = $i; $row.Background = $Pinceau.Surface2; $row.BorderBrush = $Pinceau.Bordure; $row.BorderThickness = '1'; $row.CornerRadius = '8'; $row.Padding = '10,8'; $row.Margin = '0,0,0,6'; $row.Cursor = 'Hand'
    $g = New-Object Windows.Controls.Grid
    foreach ($w in '34', '190', '*', '70') { $cd = New-Object Windows.Controls.ColumnDefinition; $cd.Width = $w; [void]$g.ColumnDefinitions.Add($cd) }
    $logo = New-Object Windows.Controls.Border
    $logo.Width = 22; $logo.Height = 22; $logo.CornerRadius = '5'; $logo.HorizontalAlignment = 'Left'; $logo.VerticalAlignment = 'Center'
    $nomLogo = switch -Regex ($r.Nom) { 'Quad9' { 'quad9' } 'Cloudflare' { 'cloudflare' } 'Google' { 'google' } default { $null } }
    $img = if ($nomLogo) { Logo-Image $nomLogo } else { $null }
    if ($img) { $ib = New-Object Windows.Media.ImageBrush $img; $ib.Stretch = 'UniformToFill'; $logo.Background = $ib }
    else {
        $logo.Background = $Pinceau.AccentFond
        $lt = New-Object Windows.Controls.TextBlock; $lt.Text = $Bagarre.L.dnsBox; $lt.FontSize = 8; $lt.Foreground = $Pinceau.AccentClair; $lt.HorizontalAlignment = 'Center'; $lt.VerticalAlignment = 'Center'
        $logo.Child = $lt
    }
    $nom = New-Object Windows.Controls.TextBlock
    $nom.Text = $r.Nom; $nom.VerticalAlignment = 'Center'; $nom.Margin = '4,0,10,0'
    [Windows.Controls.Grid]::SetColumn($nom, 1)
    $med = 0.0; $ok = [double]::TryParse([string]$r.Mediane, [ref]$med)
    $barre = New-Object Windows.Controls.Border
    $barre.Height = 8; $barre.CornerRadius = '4'; $barre.HorizontalAlignment = 'Left'; $barre.VerticalAlignment = 'Center'
    $barre.Width = if ($ok -and $max -gt 0) { 12 + 220 * $med / $max } else { 12 }
    $barre.Background = if ($ok -and $med -le $max * 0.35) { $Pinceau.Accent } else { '#4A4260' }
    [Windows.Controls.Grid]::SetColumn($barre, 2)
    $ms = New-Object Windows.Controls.TextBlock
    $ms.Text = if ($ok) { '{0} ms' -f [math]::Round($med) } else { [string]$r.Mediane }; $ms.TextAlignment = 'Right'; $ms.VerticalAlignment = 'Center'; $ms.FontWeight = 'SemiBold'
    [Windows.Controls.Grid]::SetColumn($ms, 3)
    foreach ($c in $logo, $nom, $barre, $ms) { [void]$g.Children.Add($c) }
    $row.Child = $g
    $row.Add_MouseLeftButtonDown({ param($s, $e) Dns-Choisir ([int]$s.Tag) })
    $row
}
function Dns-Tester {
    $adapt = Dns-Carte
    if (-not $adapt) { Log $Bagarre.L.aucuneCarte; return }
    $Bagarre.DnsAdapt = $adapt
    $Ctl.DnsCarte.Text = $Bagarre.L.dnsCarte -f $adapt.Name, $adapt.InterfaceDescription, ((Dns-Actuels $adapt) -join ', ')
    $Ctl.DnsListe.Children.Clear()
    Dns-Choisir -1
    Log $Bagarre.L.dnsEnCours
    $Bagarre.DnsResultats = @(Dns-Mesurer $adapt)
    $max = 0.0
    foreach ($r in $Bagarre.DnsResultats) { $v = 0.0; if ([double]::TryParse([string]$r.Mediane, [ref]$v) -and $v -gt $max) { $max = $v } }
    for ($i = 0; $i -lt $Bagarre.DnsResultats.Count; $i++) { [void]$Ctl.DnsListe.Children.Add((Dns-Ligne $i $Bagarre.DnsResultats[$i] $max)) }
    Log $Bagarre.L.dnsFini
}

# ---------------------------------------------------------------------------
# Audit IA
# ---------------------------------------------------------------------------
$DossierAudit = Join-Path ([Environment]::GetFolderPath('Desktop')) 'bagarre-audit'
function Audit-Collecter {
    if (-not (Test-Path $DossierAudit)) { New-Item -Path $DossierAudit -ItemType Directory -Force | Out-Null }
    [IO.File]::WriteAllText((Join-Path $DossierAudit 'AUDIT.txt'), $Textes[$Bagarre.Langue]['audit-prompt'], (New-Object Text.UTF8Encoding $true))
    Log $Bagarre.L.collecte
    Collecter-Rapport (Join-Path $DossierAudit 'rapport-pc.txt')
    Ouvrir $DossierAudit
}

# ---------------------------------------------------------------------------
# Voile : l'installation n'est pas récente, propose de se protéger avant de toucher
# ---------------------------------------------------------------------------
$imgVoile = Logo-Image 'stop-it'
if ($imgVoile) { $Ctl.VoileImage.ImageSource = $imgVoile }
foreach ($id in 'BtnVoileRestauration', 'BtnVoileSauvegarde') { [void]$Ctl.VoileBoutons.Children.Add((Bouton-Obtenir $id)) }
$Ctl.BtnVoileSauvegarde.Margin = '0,0,0,8'
[void]$Ctl.VoileSuite.Children.Add((Bouton-Obtenir 'BtnVoileContinuer'))
$Ctl.BtnVoileContinuer.Margin = '0'; $Ctl.BtnVoileContinuer.Background = 'Transparent'; $Ctl.BtnVoileContinuer.Foreground = $Pinceau.Sourd
function Voile-Libeller {
    $Ctl.VoileTitre.Text = $Bagarre.L.vieuxTitre -f (Age-Texte $InstallJours)
    $Ctl.VoileTexte.Text = $Bagarre.L.vieuxTexte
}
$EstVieux = ($InstallJours -gt 30) -or $Vieux

# ---------------------------------------------------------------------------
# Langue : tout relabelliser d'un coup (les pages sont reconstruites depuis leur texte), et retenir le choix
# ---------------------------------------------------------------------------
function Appliquer-Langue {
    $Bagarre.L = $UI[$Bagarre.Langue]; $L = $Bagarre.L
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) { $NavItems[$k].Nom.Text = $L.nav[$k] }
    foreach ($p in $PagesNoms) { if ($p -ne 'Optis') { Page-Construire $p } }
    Etapes-Construire
    Boutons-Libeller
    $Ctl.Legende.Text = $L.legende
    $Ctl.OptiEtiquette1.Text = $L.pourquoi; $Ctl.OptiEtiquette2.Text = $L.perds
    foreach ($g in $Groupes) {
        $g.Titre.Text = if ($Bagarre.Langue -eq 'en' -and $GroupesEn[$g.Nom]) { $GroupesEn[$g.Nom] } else { $g.Nom }
        $g.Tout.Content = $L.tout; $g.Rien.Content = $L.rienBtn
    }
    $Ctl.FiltreIndice.Text = $L.filtrer
    foreach ($id in $Lignes.Keys) { Ligne-Libeller $id }
    foreach ($paire in @(@($Ctl.BtnFr, $Ctl.DrapeauFr, 'fr'), @($Ctl.BtnEn, $Ctl.DrapeauEn, 'en'))) {
        $actif = $Bagarre.Langue -eq $paire[2]
        $paire[0].BorderBrush = if ($actif) { $Pinceau.Accent } else { 'Transparent' }
        $paire[0].ToolTip = $UI[$paire[2]].langue
        $paire[1].Opacity = if ($actif) { 1 } else { 0.45 }
    }
    Voile-Libeller
    Entete-Poser
    Opti-Vider
    Compter-Coches
}
function Changer-Langue($l) {
    $Bagarre.Langue = $l
    Set-Content -Path $LangueFichier -Value $l -Encoding ASCII
    Appliquer-Langue
}
$Ctl.BtnFr.Add_Click({ Changer-Langue 'fr' })
$Ctl.BtnEn.Add_Click({ Changer-Langue 'en' })
Appliquer-Langue
Aller 0
$Ctl.BtnDnsAppliquer.IsEnabled = $false
Detecter-Tout
if ($EstVieux) { $Ctl.Voile.Visibility = 'Visible' }

# ---------------------------------------------------------------------------
# Mode -Capture dossier : rend chaque page en PNG sans afficher la fenêtre ni demander l'admin (preuve visuelle en dev).
# Avec -Vieux, une capture de plus avec le voile.
# ---------------------------------------------------------------------------
if ($Capture) {
    if (-not (Test-Path $Capture)) { New-Item -Path $Capture -ItemType Directory -Force | Out-Null }
    Log "bagarre $Version, $Machine (capture $($Bagarre.Langue))"
    $racine = $Fenetre.Content
    $racine.Measure((New-Object Windows.Size 1320, 860))
    $racine.Arrange((New-Object Windows.Rect 0, 0, 1320, 860))
    Opti-Montrer (Item-Titre $Items[0]) (Item-Pourquoi $Items[0]) (Item-Attention $Items[0])   # le volet d'explication rempli, comme au survol
    $Ctl.Voile.Visibility = 'Collapsed'
    function Capture-Png($nom) {
        $racine.UpdateLayout()
        $bmp = New-Object Windows.Media.Imaging.RenderTargetBitmap 1320, 860, 96, 96, ([Windows.Media.PixelFormats]::Pbgra32)
        $bmp.Render($racine)
        $enc = New-Object Windows.Media.Imaging.PngBitmapEncoder
        $enc.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bmp))
        $fs = [IO.File]::Create((Join-Path $Capture "$nom.png"))
        $enc.Save($fs); $fs.Close()
    }
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) { Aller $k; Capture-Png ('{0}-{1}-{2}' -f $k, $PagesNoms[$k].ToLower(), $Bagarre.Langue) }
    if ($Vieux) { Aller 0; $Ctl.Voile.Visibility = 'Visible'; Capture-Png ('9-voile-{0}' -f $Bagarre.Langue) }
    Write-Host "Captures dans $Capture"
    return
}

Log "bagarre $Version, $Machine"
if ($Avant.Count -gt 0) { Log ($Bagarre.L.dejaApplique -f $Avant.Count) }

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
        Log "essai     visible=$($Fenetre.IsVisible) chargée=$($Fenetre.IsLoaded) largeur=$($Fenetre.ActualWidth) hauteur=$($Fenetre.ActualHeight) voile=$($Ctl.Voile.Visibility)"
        $this.Stop()
        $Fenetre.Close()
    })
    $minuteur.Start()
}

Write-Host "  $($Bagarre.L.ouverte)" -ForegroundColor Green
try { $Fenetre.ShowDialog() | Out-Null } catch {
    Log "ÉCHEC affichage de la fenêtre : $_"
    [Windows.MessageBox]::Show("La fenêtre n'a pas pu s'afficher :`n$_`n`nDétail dans $LogFichier", 'bagarre') | Out-Null
}
Log (Msg 'fenetreFermee')
