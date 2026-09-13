$Items = New-Object System.Collections.ArrayList

function Ajouter($groupe, $id, $titre, $pourquoi, $coche, $attention, $appliquer) {
    [void]$Items.Add([pscustomobject]@{
        Groupe = $groupe; Id = $id; Titre = $titre; Pourquoi = $pourquoi
        Coche = $coche; Attention = $attention; Appliquer = $appliquer
    })
}

# ----- Services : ce qui tourne en fond pour rien -----------------------------
$G = 'Services Windows'
Ajouter $G 'svc-telemetrie' 'Télémétrie Microsoft (DiagTrack, dmwappushservice)' `
    'Envoie ton usage à Microsoft en continu. Aucun rôle pour toi.' $true '' {
    Service-Couper 'DiagTrack' 'télémétrie'
    Service-Couper 'dmwappushservice' 'routage télémétrie'
}
Ajouter $G 'svc-geoloc' 'Géolocalisation (lfsvc)' `
    'Position GPS pour les applis du Store. Un PC fixe ne bouge pas.' $true 'Les applis météo / cartes ne te localisent plus.' {
    Service-Couper 'lfsvc' 'géolocalisation'
}
Ajouter $G 'svc-phone' 'Téléphonie (PhoneSvc)' `
    'Sert à Phone Link pour passer des appels depuis le PC.' $true 'Phone Link (Mobile connecté) perd les appels.' {
    Service-Couper 'PhoneSvc' 'téléphonie'
}
Ajouter $G 'svc-maps' 'Cartes hors ligne (MapsBroker)' `
    'Télécharge des cartes pour l appli Cartes. Personne ne l utilise.' $true '' {
    Service-Couper 'MapsBroker' 'cartes hors ligne'
}
Ajouter $G 'svc-demo' 'Mode démo magasin (RetailDemo)' `
    'Le mode vitrine des PC en rayon.' $true '' {
    Service-Couper 'RetailDemo' 'mode démo'
}
Ajouter $G 'svc-wer' 'Rapport d erreurs Windows (WerSvc)' `
    'Envoie un rapport à Microsoft quand un programme plante.' $true 'Plus de rapport automatique quand une appli plante (tu peux toujours lire l Observateur d événements).' {
    Service-Couper 'WerSvc' 'rapport d erreurs'
}
Ajouter $G 'svc-fax' 'Fax' `
    'On est en 2026.' $true '' {
    Service-Couper 'Fax' 'fax'
}
Ajouter $G 'svc-compat' 'Assistant compatibilité des programmes (PcaSvc)' `
    'Surveille chaque lancement de vieux programme pour proposer un mode compatibilité.' $true 'Windows ne proposera plus de corriger un vieux programme tout seul.' {
    Service-Couper 'PcaSvc' 'assistant compatibilité'
}
Ajouter $G 'svc-xbox' 'Services Xbox (XblAuthManager, XblGameSave, XboxNetApiSvc)' `
    'Connexion Xbox Live, sauvegardes cloud Xbox, réseau Xbox.' $false 'Game Pass PC, l appli Xbox et les jeux Microsoft Store ne se connectent plus. Laisse décoché si tu joues à un jeu Xbox / Game Pass.' {
    Service-Couper 'XblAuthManager' 'auth Xbox Live'
    Service-Couper 'XblGameSave' 'sauvegardes Xbox'
    Service-Couper 'XboxNetApiSvc' 'réseau Xbox'
}
Ajouter $G 'svc-edge' 'Mises à jour Edge en fond (edgeupdate, edgeupdatem)' `
    'Deux services qui vérifient Edge toutes les heures. Edge se met à jour tout seul à l ouverture de toute façon.' $true '' {
    Service-Couper 'edgeupdate' 'maj Edge'
    Service-Couper 'edgeupdatem' 'maj Edge (machine)'
}
Ajouter $G 'svc-wmp' 'Partage réseau Windows Media Player (WMPNetworkSvc)' `
    'Diffuse ta bibliothèque WMP sur le réseau local.' $true '' {
    Service-Couper 'WMPNetworkSvc' 'partage WMP'
}
Ajouter $G 'svc-insider' 'Programme Windows Insider (wisvc)' `
    'Ne sert qu à recevoir les versions bêta de Windows.' $true '' {
    Service-Couper 'wisvc' 'Windows Insider'
}
Ajouter $G 'svc-diag' 'Diagnostics automatiques (DPS, WdiServiceHost, WdiSystemHost)' `
    'Les utilitaires de résolution de problèmes automatiques. Ils tournent en permanence pour un usage très rare.' $true 'Le bouton Résoudre les problèmes dans les paramètres ne marchera plus tant que c est coupé.' {
    Service-Couper 'DPS' 'diagnostic policy'
    Service-Couper 'WdiServiceHost' 'diagnostic host'
    Service-Couper 'WdiSystemHost' 'diagnostic system host'
}
Ajouter $G 'svc-cdp' 'Plateforme appareils connectés (CDPSvc)' `
    'Partage de proximité, Phone Link, continuité entre appareils.' $true 'Partage de proximité et Phone Link ne marchent plus.' {
    Service-Couper 'CDPSvc' 'appareils connectés'
}
Ajouter $G 'svc-imprimante' 'Spouleur d impression (Spooler)' `
    'Gère les imprimantes. Sans imprimante, il tourne pour rien.' $false 'Tu ne peux plus imprimer, même en PDF. Coche seulement si tu n as jamais d imprimante.' {
    Service-Couper 'Spooler' 'impression'
}
Ajouter $G 'svc-recherche' 'Indexation de la recherche (WSearch)' `
    'Construit un index de tes fichiers pour que la recherche du menu Démarrer soit instantanée. Sur SSD, l indexation coûte très peu.' $false 'La recherche de fichiers dans Démarrer et l Explorateur devient lente. Outlook aussi.' {
    Service-Couper 'WSearch' 'indexation'
}
Ajouter $G 'svc-sysmain' 'SysMain (ex Superfetch)' `
    ('Précharge en RAM les programmes que tu lances souvent. Sur SSD il ne gêne pas, sur disque dur il peut faire ramer. ' + $(if ($EstHdd) { 'Ton disque système est un HDD : coche.' } else { 'Ton disque système est un SSD : laisse.' })) $EstHdd 'Les lancements de programmes ne sont plus préchargés.' {
    Service-Couper 'SysMain' 'sysmain'
}
Ajouter $G 'svc-bits' 'Transfert en arrière-plan (BITS)' `
    'Télécharge les mises à jour Windows et du Store discrètement en fond.' $false 'Windows Update, le Microsoft Store et les définitions Defender ne se téléchargent plus. Franchement, ne coche pas.' {
    Service-Couper 'BITS' 'BITS'
}
Ajouter $G 'svc-bluetooth' 'Bluetooth (bthserv, BTAGService)' `
    'Tout ce qui est Bluetooth.' $false 'Plus aucun appareil Bluetooth : casque, manette, souris. Coche uniquement si tu n en as aucun.' {
    Service-Couper 'bthserv' 'bluetooth'
    Service-Couper 'BTAGService' 'bluetooth audio'
}
Ajouter $G 'svc-delivery' 'Optimisation de la distribution : ne plus envoyer les mises à jour aux inconnus' `
    'Par défaut ton PC renvoie les mises à jour Windows qu il a téléchargées à d autres PC sur internet (du peer-to-peer). Ça prend de l upload pendant que tu joues. On garde le téléchargement, on coupe l envoi.' $true '' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' 'DODownloadMode' 0
}
Ajouter $G 'svc-hyperv' 'Services invité Hyper-V (vmic*)' `
    'Ne servent que si Windows tourne DANS une machine virtuelle Hyper-V. Sur un vrai PC ils ne démarrent jamais, les couper ne change rien.' $false '' {
    foreach ($s in 'HvHost', 'vmickvpexchange', 'vmicguestinterface', 'vmicshutdown', 'vmicheartbeat', 'vmicvmsession', 'vmicrdv', 'vmictimesync', 'vmicvss') { Service-Couper $s 'Hyper-V invité' }
}

# ----- Vie privée : ce que Windows envoie et affiche sans te demander ----------
$G = 'Vie privée et pubs'
Ajouter $G 'priv-telemetrie' 'Télémétrie au minimum (AllowTelemetry, CEIP, rapports d erreur, PowerShell)' `
    'Règle le niveau de données envoyées à Microsoft au plus bas. Honnêtement : sur Famille et Pro, AllowTelemetry=0 vaut 1 (le niveau "requis" reste), seules les éditions Entreprise et Éducation coupent tout. On coupe aussi le programme d amélioration (CEIP), l envoi des rapports de plantage, les demandes d avis et la télémétrie de PowerShell.' $true 'Les rapports de plantage ne partent plus chez Microsoft (ils restent lisibles dans l Observateur d événements).' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'AllowTelemetry' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'AllowDeviceNameInTelemetry' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'LimitDiagnosticLogCollection' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'LimitDumpCollection' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'DoNotShowFeedbackNotifications' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' 'AllowTelemetry' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows' 'CEIPEnable' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\SQMClient\Windows' 'CEIPEnable' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' 'Disabled' 1
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' 'DontSendAdditionalData' 1
    Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' 'POWERSHELL_TELEMETRY_OPTOUT' '1' 'String'
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy' 'TailoredExperiencesWithDiagnosticDataEnabled' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' 'NumberOfSIUFInPeriod' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'PublishUserActivities' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'UploadUserActivities' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'EnableActivityFeed' 0
}
Ajouter $G 'priv-pub' 'Identifiant publicitaire, suggestions, section "Recommandé" de Démarrer, bouton Chat' `
    'Coupe l ID de pub, les suggestions dans Démarrer et sa section "Recommandé", les conseils sur l écran de verrouillage, les pubs dans l Explorateur, l installation silencieuse d applis sponsorisées, les illustrations qui tournent dans la barre de recherche, le bouton Chat (Teams) de la barre des tâches et les astuces en ligne dans Paramètres.' $true 'La section "Recommandé" de Démarrer devient vide (les fichiers récents restent dans l Explorateur).' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' 'Enabled' 0
    Reg-Ecrire 'HKCU:\Control Panel\International\User Profile' 'HttpAcceptLanguageOptOut' 1
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'Start_TrackProgs' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'ShowSyncProviderNotifications' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement' 'ScoobeSystemSettingEnabled' 0
    $cdm = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
    foreach ($n in 'SubscribedContent-338393Enabled', 'SubscribedContent-353694Enabled', 'SubscribedContent-353696Enabled', 'SubscribedContent-338387Enabled', 'SubscribedContent-338389Enabled', 'SubscribedContent-310093Enabled', 'SubscribedContent-338388Enabled', 'SubscribedContent-314563Enabled', 'RotatingLockScreenOverlayEnabled', 'RotatingLockScreenEnabled', 'ContentDeliveryAllowed', 'OemPreInstalledAppsEnabled', 'PreInstalledAppsEnabled', 'PreInstalledAppsEverEnabled', 'SilentInstalledAppsEnabled', 'SoftLandingEnabled', 'SubscribedContentEnabled', 'FeatureManagementEnabled', 'SystemPaneSuggestionsEnabled') {
        Reg-Ecrire $cdm $n 0
    }
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableWindowsConsumerFeatures' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableThirdPartySuggestions' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableConsumerAccountStateContent' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableCloudOptimizedContent' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableSoftLanding' 1
    Reg-Ecrire 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' 'HideRecommendedSection' 1
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' 'IsDynamicSearchBoxEnabled' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'TaskbarMn' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' 'AllowCortana' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'NoCloudApplicationNotification' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' 'AllowOnlineTips' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableTailoredExperiencesWithDiagnosticData' 1
}
Ajouter $G 'priv-saisie' 'Personnalisation de la saisie et de la voix' `
    'Windows apprend ta frappe, ton écriture et ta voix pour les envoyer au cloud. Inutile hors Cortana.' $true '' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy' 'HasAccepted' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' 'AcceptedPrivacyPolicy' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' 'RestrictImplicitInkCollection' 1
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' 'RestrictImplicitTextCollection' 1
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore' 'HarvestContacts' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\TextInput' 'AllowLinguisticDataCollection' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Input\Settings' 'InsightsEnabled' 0
}
Ajouter $G 'priv-fond' 'Applis du Store en arrière-plan' `
    'Empêche les applis du Store de tourner quand elles sont fermées.' $true 'Les notifications de ces applis (Mail, Météo) n arrivent plus tant qu elles sont fermées.' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' 'GlobalUserDisabled' 1
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' 'BackgroundAppGlobalToggle' 0
}
Ajouter $G 'priv-copilot' 'Couper Copilot, Recall, Click to Do, les Widgets et l IA de Bloc-notes / Paint' `
    'Copilot et les Widgets sont des processus qui restent en mémoire. Recall, quand il est actif, prend une capture d écran toutes les quelques secondes et l indexe : CPU et disque en permanence. Click to Do analyse l écran à la demande. Les stratégies AllowRecallEnablement et DisableClickToDo sont celles documentées par Microsoft (policy CSP WindowsAI, 2025). On passe aussi le service de la pile IA (WSAIFabricSvc) en manuel et on coupe les boutons IA de Bloc-notes et Paint.' $true 'Plus de Copilot, plus de Recall, plus de Click to Do (Win+clic), plus de panneau météo / actus, plus de "Réécrire" dans le Bloc-notes ni de Cocreator dans Paint.' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' 'TurnOffWindowsCopilot' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI' 'DisableAIDataAnalysis' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI' 'AllowRecallEnablement' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI' 'AllowRecallEnablement' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI' 'DisableClickToDo' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' 'AllowNewsAndInterests' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\WindowsNotepad' 'DisableAIFeatures' 1
    foreach ($n in 'DisableCocreator', 'DisableGenerativeFill', 'DisableImageCreator', 'DisableGenerativeErase', 'DisableRemoveBackground') {
        Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Paint' $n 1
    }
    Service-Manuel 'WSAIFabricSvc' 'pile IA, ne démarre plus tout seul'
}
Ajouter $G 'priv-taches' 'Tâches planifiées de télémétrie (Compatibility Appraiser, CEIP, Feedback, DiskDiagnostic)' `
    'Des tâches de fond qui analysent tes programmes installés et envoient le résultat à Microsoft, parfois en pleine partie (Compatibility Appraiser est connu pour ses pics disque).' $true '' {
    Tache-Couper '\Microsoft\Windows\Application Experience\' 'Microsoft Compatibility Appraiser'
    Tache-Couper '\Microsoft\Windows\Application Experience\' 'Microsoft Compatibility Appraiser Exp'
    Tache-Couper '\Microsoft\Windows\Application Experience\' 'ProgramDataUpdater'
    Tache-Couper '\Microsoft\Windows\Application Experience\' 'StartupAppTask'
    Tache-Couper '\Microsoft\Windows\Customer Experience Improvement Program\' 'Consolidator'
    Tache-Couper '\Microsoft\Windows\Customer Experience Improvement Program\' 'UsbCeip'
    Tache-Couper '\Microsoft\Windows\DiskDiagnostic\' 'Microsoft-Windows-DiskDiagnosticDataCollector'
    Tache-Couper '\Microsoft\Windows\Feedback\Siuf\' 'DmClient'
    Tache-Couper '\Microsoft\Windows\Feedback\Siuf\' 'DmClientOnScenarioDownload'
    Tache-Couper '\Microsoft\Windows\Windows Error Reporting\' 'QueueReporting'
    Tache-Couper '\Microsoft\Windows\Maps\' 'MapsUpdateTask'
    Tache-Couper '\Microsoft\Windows\Autochk\' 'Proxy'
}
Ajouter $G 'priv-assistance' 'Couper l Assistance à distance' `
    'Permet à quelqu un de prendre la main sur ton PC via Windows. Personne ne s en sert, et c est une porte de moins.' $true 'Le bouton "Assistance rapide" Windows ne marche plus (Discord, AnyDesk, Parsec ne sont pas concernés).' {
    Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' 'fAllowToGetHelp' 0
}
Ajouter $G 'priv-sync' 'Synchronisation des paramètres avec le compte Microsoft' `
    'Arrête d envoyer thème, mots de passe et paramètres sur le cloud Microsoft.' $true 'Tes paramètres ne suivent plus sur un autre PC connecté au même compte.' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' 'SyncPolicy' 5
    foreach ($g in 'Personalization', 'BrowserSettings', 'Credentials', 'Accessibility', 'Windows') {
        Reg-Ecrire "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$g" 'Enabled' 0
    }
}
Ajouter $G 'priv-autorun' 'Couper l exécution automatique des clés USB et disques (AutoRun / AutoPlay)' `
    'Une clé branchée ne lance plus rien toute seule. C est la recommandation de sécurité de base de Microsoft depuis 2011, encore ouverte par défaut pour la fenêtre "que voulez-vous faire ?".' $true 'Plus de fenêtre automatique quand tu branches une clé ou un téléphone : tu l ouvres depuis l Explorateur.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' 'NoDriveTypeAutoRun' 255
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' 'NoAutorun' 1
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' 'NoAutoplayfornonVolume' 1
}
Ajouter $G 'priv-relance' 'Ne plus rouvrir les applis toutes seules après une mise à jour (ARSO)' `
    'Après un redémarrage de mise à jour, Windows se reconnecte tout seul et relance ce qui était ouvert. Un PC qui boot avec 15 fenêtres et le launcher de la veille.' $true 'Après une mise à jour tu retapes ton code PIN et tu rouvres tes applis toi-même.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' 'DisableAutomaticRestartSignOn' 1
}
Ajouter $G 'priv-metadata' 'Ne plus télécharger les fiches et icônes des périphériques chez Microsoft' `
    'Chaque périphérique branché déclenche un téléchargement de son icône et de sa fiche depuis Microsoft. Purement cosmétique dans "Périphériques et imprimantes".' $true 'Les périphériques ont une icône générique.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata' 'PreventDeviceMetadataFromNetwork' 1
}
Ajouter $G 'priv-presse-papiers' 'Couper l historique du presse-papiers (Win+V) et sa synchro cloud' `
    'Windows garde en mémoire tout ce que tu copies, mots de passe compris, et peut l envoyer sur ton compte Microsoft.' $false 'Plus de Win+V. Si tu t en sers, laisse décoché : seule la synchro cloud mérite d être coupée, et c est dans Paramètres > Système > Presse-papiers.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'AllowClipboardHistory' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'AllowCrossDeviceClipboard' 0
}

# ----- Jeu et réactivité -----------------------------------------------------
$G = 'Jeu et réactivité'
Ajouter $G 'jeu-dvr' 'Couper Game DVR (enregistrement en fond de la Game Bar)' `
    'La Game Bar enregistre en permanence les 30 dernières secondes de jeu "au cas où". C est un encodeur qui tourne pendant que tu joues.' $true 'Plus de clip instantané Win+Alt+G. La Game Bar elle-même reste (Win+G).' {
    Reg-Ecrire 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' 'AllowGameDVR' 0
}
Ajouter $G 'jeu-presence' 'Couper le GameBarPresenceWriter (le processus qui reste après avoir coupé la Game Bar)' `
    'Même Game Bar coupée, un petit processus "Game Bar Presence Writer" se lance à chaque jeu pour dire au Xbox network à quoi tu joues. On désactive sa classe COM (ActivationType = 0) : il ne se lance plus. On ne renomme jamais l exécutable, une mise à jour le remettrait et casserait la Game Bar.' $true 'Tes amis Xbox ne voient plus "joue à ...". La Game Bar (Win+G) marche toujours.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter' 'ActivationType' 0
}
Ajouter $G 'jeu-svchost' ("Regrouper les services système (SvcHostSplitThreshold, détecté $RamGo Go de RAM)") `
    'Depuis Windows 10, chaque service a son propre processus dès que tu as plus de 3,5 Go de RAM. En montant le seuil à ta RAM réelle, ils se regroupent comme avant : moins de processus dans le Gestionnaire des tâches. Verdict après relecture : placebo, personne n a mesuré un gain de FPS ni de RAM significatif (quelques dizaines de Mo). Décoché par défaut, coche si tu aimes un Gestionnaire des tâches plus court.' $false 'Un service qui plante entraîne les autres du même processus avec lui, comme sur Windows 7.' {
    Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Control' 'SvcHostSplitThresholdInKB' ($RamGo * 1024 * 1024)
}
Ajouter $G 'jeu-timer' 'Autoriser la résolution de timer fine pour les jeux (GlobalTimerResolutionRequests)' `
    'Depuis Windows 11, une appli qui demande un timer à 0,5 ms ne l obtient que pour elle-même et seulement au premier plan. Cette clé rétablit le comportement Windows 10 : la demande vaut pour tout le système. Un jeu qui demande un timer fin le garde même quand une autre fenêtre passe devant.' $true 'Consommation au repos très légèrement plus haute quand un programme demande un timer fin.' {
    Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' 'GlobalTimerResolutionRequests' 1
}
Ajouter $G 'jeu-souris' 'Couper l accélération de la souris (Améliorer la précision du pointeur)' `
    'Avec l accélération, la distance parcourue par le curseur dépend de la vitesse du geste : le même mouvement de main ne donne jamais le même mouvement à l écran. Ta mémoire musculaire ne peut rien apprendre. Tout joueur la coupe, c est la première chose à faire.' $true 'Le curseur demande un peu plus de mouvement de main sur le bureau. Monte le DPI de la souris si besoin.' {
    Reg-Ecrire 'HKCU:\Control Panel\Mouse' 'MouseSpeed' '0' 'String'
    Reg-Ecrire 'HKCU:\Control Panel\Mouse' 'MouseThreshold1' '0' 'String'
    Reg-Ecrire 'HKCU:\Control Panel\Mouse' 'MouseThreshold2' '0' 'String'
}
Ajouter $G 'jeu-hiber' 'Couper la mise en veille prolongée et le démarrage rapide' `
    'Libère hiberfil.sys (plusieurs Go) et force un vrai redémarrage à chaque boot au lieu de recharger une image figée. Un vrai boot évite les pilotes qui se retrouvent dans un état bizarre après une mise à jour.' $true 'Plus de mise en veille prolongée (la veille simple reste).' {
    Memoriser 'cmd|hibernation' @{ actif = ((powercfg /a) -match 'Mise en veille prolongée|Hibernate' | Where-Object { $_ -notmatch 'non disponible|not available' }).Count -gt 0 }
    powercfg /h off | Out-Null
    Log 'alim      hibernation et démarrage rapide coupés'
}
Ajouter $G 'jeu-parking' 'Désactiver le core parking' `
    'Windows peut endormir des cœurs au repos, et met un instant à les réveiller quand un jeu en a besoin. Sur un Ryzen avec le pilote chipset AMD ou un Intel récent, Windows gère bien tout seul. Utile surtout sur les vieux CPU ou les portables.' $false 'Consommation au repos un peu plus haute.' {
    Powercfg-Regler 'SUB_PROCESSOR' 'CPMINCORES' 100 'cœurs minimum actifs (%)'
}
Ajouter $G 'jeu-usb' 'Couper la suspension sélective USB' `
    'Windows éteint les ports USB inactifs pour économiser 0,1 W. Une souris ou un clavier qui se rendort peut mettre quelques millisecondes à répondre. Sur PC fixe, aucun intérêt à économiser.' (-not $EstPortable) 'Sur portable, un peu moins d autonomie.' {
    Powercfg-Regler '2a737441-1930-4402-8d77-b2bebba308a3' '48e6b7a6-50f5-4782-a5d4-53bb50f7e1e4' 0 'suspension sélective USB'
}
Ajouter $G 'jeu-pcie' 'Couper l économie d énergie PCI Express (ASPM)' `
    'Le lien PCIe de la carte graphique et du SSD peut passer en basse consommation au repos, avec un délai de réveil. Sur PC fixe, on laisse le lien toujours ouvert.' (-not $EstPortable) 'Sur portable, un peu moins d autonomie.' {
    Powercfg-Regler '501a4d13-42af-4429-9fd1-a8218c268e20' 'ee12f906-d277-404b-b6da-e5fa1a576df5' 0 'PCIe link state'
}
Ajouter $G 'jeu-reveil' 'Interdire aux minuteurs de réveil de sortir le PC de veille' `
    'Windows Update et certaines tâches peuvent réveiller le PC en pleine nuit pour faire leur travail. On coupe les minuteurs de réveil dans le plan d alimentation actif.' $true 'Le PC ne se réveille plus tout seul pour une mise à jour : elle se fera quand tu l allumes.' {
    Powercfg-Regler '238c9fa8-0aad-41ed-83f4-97be242c8f20' 'bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d' 0 'minuteurs de réveil'
}
Ajouter $G 'jeu-usb3' 'Couper la gestion d énergie des liens USB 3 (Link Power Management)' `
    'Comme la suspension sélective mais pour la couche USB 3 : le lien passe en basse consommation entre deux transferts. Un disque externe ou une manette USB peut caler une fraction de seconde au réveil. Sur fixe on garde le lien à fond.' (-not $EstPortable) 'Sur portable, un peu moins d autonomie.' {
    Powercfg-Regler '2a737441-1930-4402-8d77-b2bebba308a3' 'd4e98f31-5ffe-4ce1-be31-1b38b384c009' 0 'USB 3 Link Power Management'
}
if ($EstHdd) {
    Ajouter $G 'jeu-hdd' 'Ne jamais arrêter le disque dur (détecté : disque système HDD)' `
        'Windows arrête le disque dur après 20 minutes sans accès, et le relancer prend 2 à 5 secondes de blocage. Sur un HDD on garde le plateau en rotation.' $true 'Le disque tourne en permanence : un poil plus de bruit et d usure.' {
        Powercfg-Regler '0012ee47-9041-4b5d-9b77-535fba8b1442' '6738e2c4-e8a5-4a42-b16a-e040e769756e' 0 'arrêt du disque dur'
    }
}
Ajouter $G 'jeu-pilotes' 'Empêcher Windows Update d écraser tes pilotes' `
    'Windows Update installe parfois un pilote graphique plus vieux ou générique par-dessus celui que tu as posé (NVCleanstall, AMD). Cette clé garde la main.' $true 'Windows ne mettra plus aucun pilote à jour tout seul, c est toi qui les gères (Snappy, constructeur).' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' 'SearchOrderConfig' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' 'ExcludeWUDriversInQualityUpdate' 1
}
Ajouter $G 'jeu-nouveautes' 'Ne plus recevoir les nouveautés Windows en avance (Continuous Innovation)' `
    'Windows 11 propose "les dernières mises à jour dès qu elles sont disponibles" : ce sont les nouvelles fonctions poussées avant leur sortie officielle, celles qui cassent le plus souvent un pilote ou un anti-cheat. On reste sur les versions stables. Les correctifs de sécurité arrivent pareil.' $true 'Les nouvelles fonctions arrivent quelques semaines ou mois plus tard.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' 'IsContinuousInnovationOptedIn' 0
}
Ajouter $G 'jeu-f8' 'Remettre le menu F8 au démarrage (mode sans échec)' `
    'Windows 11 cache le menu de démarrage avancé. Sans lui, pour entrer en mode sans échec il faut faire planter le boot trois fois de suite. Avec cette option, F8 au démarrage suffit.' $true 'Le démarrage prend une fraction de seconde de plus (le menu attend F8).' {
    Memoriser 'cmd|bootmenupolicy' @{ valeur = ((bcdedit /enum '{current}') | Select-String 'bootmenupolicy') -replace '.*bootmenupolicy\s+', '' }
    bcdedit /set '{current}' bootmenupolicy legacy | Out-Null
    Log 'boot      bootmenupolicy = legacy (F8 actif)'
}

# ----- Carte réseau -------------------------------------------------------------
$G = 'Carte réseau (appliqué sur chaque carte physique active)'
Ajouter $G 'net-alim' 'Interdire à Windows d éteindre la carte réseau pour économiser l énergie' `
    'Windows peut couper la carte au repos, et elle met une seconde à revenir : c est le "le réseau a lâché 2 secondes" en pleine partie, surtout après une veille.' $true 'Sur portable, un peu moins d autonomie.' {
    foreach ($c in Cartes-Reseau) {
        $pm = Get-NetAdapterPowerManagement -Name $c.Name -ErrorAction SilentlyContinue
        if ($pm) { Memoriser "netpm|$($c.Name)" @{ carte = $c.Name; valeur = [string]$pm.AllowComputerToTurnOffDevice } }
        Disable-NetAdapterPowerManagement -Name $c.Name -ErrorAction SilentlyContinue
        Log "réseau    $($c.Name) : gestion de l alimentation coupée"
        Net-Attendre $c
    }
}
Ajouter $G 'net-eee' 'Couper Energy Efficient Ethernet / Green Ethernet' `
    'Même logique : la puce réseau s endort entre deux paquets pour économiser quelques milliwatts, et se réveille avec un délai. En jeu on veut la carte toujours réveillée.' $true 'Rien de visible.' {
    # Libellés vus : "Energy Efficient Ethernet", "Ethernet à économie d'énergie", "Green Ethernet", "Ethernet vert", "Advanced EEE",
    # "Power Saving Mode", "Gigabit Lite" (Realtek). Pas "EEE Max Support Speed", qui n'a pas de valeur Désactivé.
    foreach ($c in Cartes-Reseau) { Net-Propriete-Regler $c 'Energy.Efficient|conomie d|Green Ethernet|Ethernet vert|^Advanced EEE$|Power Saving|Gigabit Lite' '^(Disabled|Désactivé|Off)$' 'économie d énergie de la puce' }
}
Ajouter $G 'net-moderation' 'Modération des interruptions sur Medium (pas Désactivé)' `
    'La carte regroupe ses interruptions pour ne pas réveiller le CPU à chaque paquet. Medium garde le CPU disponible pour le jeu tout en livrant les paquets vite. Tout couper fait l inverse de ce que promettent les tutos : plus d interruptions, plus de temps CPU volé au jeu (mesuré au xperf par djdallmann sur trafic UDP de jeu).' $false 'Si ta carte n a pas cette option (souvent le cas sur Realtek), rien ne se passe.' {
    # Intel : "Interrupt Moderation Rate" (Off / Low / Medium / High / Adaptive). Realtek : "Modération interruption" (Désactivé / Activé), on garde Activé.
    foreach ($c in Cartes-Reseau) { Net-Propriete-Regler $c 'Interrupt Moderation|Modération interruption' '^(Medium|Moyen|Enabled|Activé)$' 'modération d interruptions' }
}
Ajouter $G 'net-decouverte' 'Décocher les protocoles de découverte réseau (LLDP, topologie de liaison)' `
    'Trois protocoles qui servent à dessiner la carte du réseau local. Ils tournent sur chaque paquet pour rien. TCP/IPv4 et IPv6 restent.' $true 'Le "mappage réseau" du Centre réseau ne voit plus les autres appareils. Personne ne l utilise.' {
    foreach ($c in Cartes-Reseau) {
        Net-Liaison-Couper $c 'ms_lldp' 'pilote LLDP'
        Net-Liaison-Couper $c 'ms_lltdio' 'découverte de topologie (E/S)'
        Net-Liaison-Couper $c 'ms_rspndr' 'répondeur de topologie'
    }
}
Ajouter $G 'net-partage' 'Décocher le partage de fichiers et d imprimantes Microsoft' `
    'Le protocole SMB côté serveur et client. Utile seulement si tu partages des dossiers entre PC de la maison ou vers un NAS.' $false 'Plus d accès aux dossiers partagés des autres PC ni au NAS, et les autres ne voient plus les tiens. Coche seulement si tu n as rien de tout ça.' {
    foreach ($c in Cartes-Reseau) {
        Net-Liaison-Couper $c 'ms_server' 'partage de fichiers et d imprimantes'
        Net-Liaison-Couper $c 'ms_msclient' 'client pour les réseaux Microsoft'
    }
}
Ajouter $G 'net-qos' 'Décocher le Planificateur de paquets QoS' `
    'QoS priorise certains paquets quand la ligne est saturée. Sur une connexion normale il ne sert pas. Si tu as du lag en jeu pendant qu un autre appareil télécharge, c est justement lui qu il faut remettre.' $false 'Plus de priorisation quand la ligne sature.' {
    foreach ($c in Cartes-Reseau) { Net-Liaison-Couper $c 'ms_pacer' 'planificateur QoS' }
}

# ----- Confort : Windows plus vif, sans effet sur les FPS ---------------------
$G = 'Confort (aucun gain de FPS, juste plus vif)'
Ajouter $G 'conf-bing' 'Plus de résultats web Bing dans le menu Démarrer' `
    'Chaque frappe dans Démarrer part sur Bing avant de chercher tes fichiers. On cherche en local seulement : plus rapide et rien n est envoyé.' $true 'Plus de suggestions web dans Démarrer.' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' 'BingSearchEnabled' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' 'DisableSearchBoxSuggestions' 1
}
Ajouter $G 'conf-explorateur' 'Explorateur : extensions de fichiers visibles, ouvrir sur "Ce PC"' `
    'Voir ".exe" et ".txt" évite de lancer un faux fichier, et "Ce PC" est plus utile que l accueil avec les fichiers récents.' $true '' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'HideFileExt' 0
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'LaunchTo' 1
}
Ajouter $G 'conf-menu-classique' 'Menu clic droit complet directement (sans "Afficher plus d options")' `
    'Le menu clic droit de Windows 11 cache la moitié des entrées derrière "Afficher plus d options". Cette clé rétablit le menu complet de Windows 10 d un seul clic. L Explorateur est relancé pour appliquer.' $true 'Le menu est plus long et sans icônes modernes. Les entrées Windows 11 (Copier le chemin, Partager) restent accessibles par Maj+clic droit.' {
    $cle = 'HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'
    Memoriser 'cmd|menuclassique' @{ existait = [bool](Test-Path 'HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}') }
    if (-not (Test-Path $cle)) { New-Item -Path $cle -Force | Out-Null }
    Set-ItemProperty -Path $cle -Name '(default)' -Value '' -ErrorAction SilentlyContinue
    Log 'registre  menu contextuel classique activé'
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
}
Ajouter $G 'conf-fin-tache' 'Bouton "Fin de tâche" dans le clic droit de la barre des tâches' `
    'Un clic droit sur une icône de la barre des tâches propose "Fin de tâche" : un programme figé se tue sans ouvrir le Gestionnaire des tâches. Option Windows 11 (Paramètres > Système > Pour les développeurs), juste cachée.' $true '' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' 'TaskbarEndTask' 1
}
Ajouter $G 'conf-ducking' 'Son : "Ne rien faire" quand Discord ou un appel s ouvre' `
    'Par défaut Windows baisse tous les autres sons de 80 % dès qu une appli de communication (Discord, Teams) prend le micro. Le jeu devient inaudible en vocal. C est l onglet Communications de la fenêtre Son, réglé sur "Ne rien faire".' $true '' {
    Reg-Ecrire 'HKCU:\Software\Microsoft\Multimedia\Audio' 'UserDuckingPreference' 3
}
Ajouter $G 'conf-edge' 'Edge : plus de préchargement au démarrage ni de processus en fond' `
    'Edge se lance à moitié au démarrage de Windows (Startup Boost) et reste en mémoire fenêtre fermée (Background Mode), même si tu utilises un autre navigateur. Deux stratégies documentées par Microsoft.' $true 'Edge met une seconde de plus à s ouvrir la première fois.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' 'StartupBoostEnabled' 0
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' 'BackgroundModeEnabled' 0
}
Ajouter $G 'conf-eclairage' 'Couper l éclairage dynamique (Dynamic Lighting)' `
    'Windows 11 pilote lui-même les LED RGB des périphériques compatibles, et son service tourne même sans LED. Si tu as iCUE, OpenRGB ou Armoury, ils se battent avec lui.' $false 'Windows ne gère plus tes LED : ton logiciel constructeur (ou rien) s en charge.' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Lighting' 'AmbientLightingEnabled' 0
}
Ajouter $G 'conf-accueil-parametres' 'Cacher la page "Accueil" de Paramètres (pubs Microsoft 365, Game Pass)' `
    'La première page de Paramètres est une vitrine : abonnement Microsoft 365, Game Pass, compte. On ouvre directement sur Système.' $false 'La carte "Périphériques récents" et le raccourci compte de cette page disparaissent avec elle.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' 'SettingsPageVisibility' 'hide:home' 'String'
}
Ajouter $G 'conf-reserve' 'Libérer le stockage réservé de Windows Update (environ 7 Go)' `
    'Windows garde 7 Go de côté pour ses mises à jour. Avec un disque qui a de la place, elles se font aussi bien sans cette réserve.' $true 'Une grosse mise à jour peut échouer si le disque est presque plein (Windows te le dira).' {
    Memoriser 'cmd|reserve' @{ etat = [string](Get-WindowsReservedStorageState -ErrorAction SilentlyContinue).ReservedStorageState }
    Set-WindowsReservedStorageState -State Disabled -ErrorAction SilentlyContinue | Out-Null
    Log 'disque    stockage réservé désactivé'
}
Ajouter $G 'conf-menus' 'Menus instantanés (MenuShowDelay 0, MouseHoverTime 10)' `
    'Windows attend 400 ms avant d ouvrir un sous-menu. On le passe à 0.' $true '' {
    Reg-Ecrire 'HKCU:\Control Panel\Desktop' 'MenuShowDelay' '0' 'String'
    Reg-Ecrire 'HKCU:\Control Panel\Mouse' 'MouseHoverTime' '10' 'String'
}
Ajouter $G 'conf-demarrage' 'Lancer les programmes de démarrage sans attendre (StartupDelayInMSec 0)' `
    'Windows retarde de 10 secondes les programmes qui se lancent au démarrage. On enlève le délai.' $true 'Si tu as beaucoup de programmes au démarrage, le bureau peut être moins réactif les premières secondes.' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize' 'StartupDelayInMSec' 0
}
Ajouter $G 'conf-fin' 'Fermer les programmes bloqués sans demander (AutoEndTasks)' `
    'À l extinction, Windows tue les programmes qui ne répondent pas au lieu d afficher la fenêtre "ce programme empêche l arrêt".' $true 'Un document non enregistré dans un programme figé est perdu à l extinction.' {
    Reg-Ecrire 'HKCU:\Control Panel\Desktop' 'AutoEndTasks' '1' 'String'
}
Ajouter $G 'conf-transparence' 'Couper la transparence' `
    'Les effets de flou derrière le menu Démarrer et la barre des tâches. Coûte un peu de GPU en permanence.' $true 'Interface plus plate.' {
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'EnableTransparency' 0
}
Ajouter $G 'conf-animations' 'Couper les animations de fenêtres' `
    'Les fenêtres apparaissent d un coup au lieu de glisser. Windows semble plus rapide parce qu il n attend plus la fin de l animation.' $false 'Interface plus sèche. Goût personnel.' {
    Reg-Ecrire 'HKCU:\Control Panel\Desktop\WindowMetrics' 'MinAnimate' '0' 'String'
    Reg-Ecrire 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' 'VisualFXSetting' 3
    Reg-Ecrire 'HKCU:\Control Panel\Desktop' 'UserPreferencesMask' ([byte[]](0x90, 0x12, 0x03, 0x80, 0x10, 0x00, 0x00, 0x00)) 'Binary'
}
Ajouter $G 'conf-accessibilite' 'Couper les raccourcis d accessibilité (touches rémanentes, filtre)' `
    'Appuyer 5 fois sur Shift en jeu ouvre la fenêtre des touches rémanentes. Plus jamais.' $true '' {
    Reg-Ecrire 'HKCU:\Control Panel\Accessibility\StickyKeys' 'Flags' '506' 'String'
    Reg-Ecrire 'HKCU:\Control Panel\Accessibility\Keyboard Response' 'Flags' '122' 'String'
    Reg-Ecrire 'HKCU:\Control Panel\Accessibility\ToggleKeys' 'Flags' '58' 'String'
}
Ajouter $G 'conf-acces-rapide' 'Explorateur : retirer "Accès rapide" du volet de gauche (HubMode)' `
    'Le volet de gauche de l Explorateur commence par "Accès rapide" et ses dossiers récents. Cette clé le retire, le volet commence à "Ce PC". Source : tenforums.com, tutoriel 4844 (Shawn Brink, 2018), toujours valable sur Windows 11.' $false 'Plus de raccourcis "Accès rapide" ni de dossiers récents dans le volet.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' 'HubMode' 1
}
Ajouter $G 'conf-corbeille' 'Explorateur : la Corbeille dans "Ce PC"' `
    'Ajoute la Corbeille à côté des disques dans "Ce PC" et dans le volet de gauche. Source : howtogeek.com, article 282820 (Walter Glenn).' $false 'Rien, la clé se retire au retour arrière.' {
    $cle = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}'
    Memoriser 'cmd|corbeille' @{ existait = (Test-Path $cle) }
    if (-not (Test-Path $cle)) { New-Item -Path $cle -Force | Out-Null }
    Log 'registre  Corbeille ajoutée dans Ce PC'
}
Ajouter $G 'conf-vlc-pistes' 'VLC : clic droit "VLC with mixed audio tracks" sur les .mp4' `
    'Ajoute une entrée au clic droit des .mp4 qui lance VLC avec toutes les pistes audio mélangées (--sout-all). Sert aux vidéos de jeu enregistrées avec la voix et le jeu sur deux pistes. Il faut VLC installé dans C:\Program Files\VideoLAN.' $false 'Une entrée de plus dans le clic droit des .mp4.' {
    $base = 'Registry::HKEY_CLASSES_ROOT\VLC.mp4\shell\PlayWithVLCMixAudio'
    Reg-Ecrire $base '(default)' 'VLC with mixed audio tracks' 'String'
    Reg-Ecrire $base 'Icon' '"C:\Program Files\VideoLAN\VLC\vlc.exe",0' 'String'
    Reg-Ecrire $base 'MultiSelectModel' 'Player' 'String'
    Reg-Ecrire "$base\command" '(default)' '"C:\Program Files\VideoLAN\VLC\vlc.exe" --sout-all --sout #display "%1%" --started-from-file --no-playlist-enqueue "%1"' 'String'
}

# ----- Avancé : décoché par défaut, tu lis avant de cocher ---------------------
$G = 'Avancé (décoché par défaut, lis l explication avant)'
Ajouter $G 'adv-priosep' 'Win32PrioritySeparation = 0x26 (quantum court, variable, boost x3 au premier plan)' `
    'Règle comment le planificateur découpe le temps CPU entre le programme au premier plan et le reste. 0x26 donne des tranches courtes et variables avec un boost x3 pour le jeu. Effet réel sur la répartition, aucun gain de FPS reproductible publié : à garder seulement si tu mesures un mieux (CapFrameX, 3 passes).' $false 'Les tâches de fond (téléchargement, encodage) avancent moins vite pendant que tu joues.' {
    Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl' 'Win32PrioritySeparation' 38
}
Ajouter $G 'adv-throttling' 'Couper le Power Throttling (PowerThrottlingOff)' `
    'Windows bride les programmes qu il juge "en arrière-plan" (EcoQoS) pour économiser de l énergie. Sur un PC fixe on ne veut brider personne : Discord, ton launcher, l overlay tournent à pleine vitesse même derrière le jeu.' $false 'Sur portable, moins d autonomie. Sur fixe, rien.' {
    Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' 'PowerThrottlingOff' 1
}
Ajouter $G 'adv-nagle' 'Couper l algorithme de Nagle (TcpAckFrequency, TCPNoDelay) sur la carte active' `
    'Nagle regroupe les petits paquets TCP avant de les envoyer, et retarde les accusés de réception. Quelques ms de gagnées sur un jeu en TCP (MMO, certains jeux Unity). Zéro effet sur un jeu en UDP, c est-à-dire quasiment tous les FPS.' $false 'Un peu plus de petits paquets sur la ligne. Rien de visible.' {
    foreach ($c in Cartes-Reseau) {
        $guid = (Get-NetAdapter -Name $c.Name).InterfaceGuid
        $chemin = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$guid"
        if (Test-Path $chemin) { Reg-Ecrire $chemin 'TcpAckFrequency' 1; Reg-Ecrire $chemin 'TCPNoDelay' 1 }
    }
}
Ajouter $G 'adv-boost' 'Boost du processeur en Aggressive (PERFBOOSTMODE), PC fixe Intel' `
    'Le mode boost du plan d alimentation décide à quelle vitesse le processeur monte en fréquence quand la charge arrive. Aggressive le fait monter tout de suite au lieu d attendre. Sur AMD le boost est géré par le firmware, la valeur ne change rien.' $false 'Sur portable : chauffe et batterie pour rien. Sur fixe, un peu plus de consommation au repos.' {
    Powercfg-Regler 'SUB_PROCESSOR' 'PERFBOOSTMODE' 2 'mode boost du processeur'
}
Ajouter $G 'adv-dyntick' 'Couper le tick dynamique (bcdedit disabledynamictick)' `
    'Le noyau arrête son horloge quand rien ne se passe et la relance à la demande. Avec un timer à 0,5 ms ça peut dériver. À cocher seulement si tu vois des micro-saccades que RivaTuner confirme, et à décocher si ça ne change rien.' $false 'Consommation au repos un peu plus haute.' {
    Memoriser 'cmd|dyntick' @{ valeur = ((bcdedit /enum '{current}') | Select-String 'disabledynamictick') -replace '.*disabledynamictick\s+', '' }
    bcdedit /set '{current}' disabledynamictick yes | Out-Null
    Log 'boot      disabledynamictick = yes'
}
Ajouter $G 'adv-rawmouse' 'RawMouseThrottleDuration = 8 (regroupement des rapports souris)' `
    'Windows regroupe les rapports Raw Input de la souris par fenêtres de temps. Avec une souris à 1000 Hz ou plus, une fenêtre plus courte livre les mouvements plus tôt au jeu. Plage documentée 3 à 20. Sur les builds récentes de Windows 11 la valeur par défaut est déjà 8 : la clé ne change alors rien (à vérifier chez toi avec ?, la valeur d avant est écrite dans bagarre.log). Contrôle avec MouseTester : zéro rapport manqué.' $false 'Aucune perte connue. Si le curseur devient bizarre, R remet la valeur d avant.' {
    Reg-Ecrire 'HKCU:\Control Panel\Mouse' 'RawMouseThrottleDuration' 8
}
Ajouter $G 'adv-fth' 'Couper le Fault Tolerant Heap (FTH)' `
    'Quand un programme plante plusieurs fois, Windows le relance avec un allocateur mémoire "tolérant" et plus lent, sans le dire. Un jeu qui a crashé trois fois tourne ensuite bridé. Coupé, il plante pareil mais tourne à pleine vitesse le reste du temps. Documenté par Microsoft (FTH, Win32 apps).' $false 'Un vieux programme instable que le FTH maintenait en vie peut replanter.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\FTH' 'Enabled' 0
}
Ajouter $G 'adv-llmnr' 'Couper LLMNR (résolution de noms multicast)' `
    'Quand un nom n est pas trouvé par le DNS, Windows le crie en multicast sur le réseau local (LLMNR). C est une porte d entrée connue pour intercepter des identifiants (Responder) et du bruit réseau pour rien. Recommandation sécurité standard en entreprise.' $false 'Taper \\NOM-DU-PC pour joindre un autre PC de la maison peut ne plus marcher (utilise son IP ou active mDNS côté NAS).' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' 'EnableMulticast' 0
}

# ----- NVIDIA ------------------------------------------------------------------
if ($EstNvidia) {
    $G = 'NVIDIA'
    Ajouter $G 'nv-telemetrie' 'Couper la télémétrie NVIDIA' `
        'Le pilote envoie des statistiques à NVIDIA. Deux clés, aucun effet sur le jeu.' $true '' {
        Reg-Ecrire 'HKLM:\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client' 'OptInOrOutPreference' 0
        Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup' 'SendTelemetryData' 0
    }
    Ajouter $G 'nv-pstate' 'Bloquer la carte en P0 (DisableDynamicPstate)' `
        'Au repos la carte descend en fréquence, et met quelques images à remonter quand une scène se charge d un coup : c est le micro-freeze après un menu ou un chargement. Cette clé la garde à sa fréquence max tant que Windows tourne. Vérifiable avec nvidia-smi (Perf P0). Le réglage "Privilégier les performances maximales" du panneau fait presque pareil sans redémarrage, cette clé est le cran au-dessus.' $false 'Carte plus chaude et plus gourmande au repos, ventilateurs qui ne s arrêtent plus sur certaines cartes.' {
        $classe = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
        $cle = Get-ChildItem $classe -ErrorAction SilentlyContinue | Where-Object { (Reg-Lire $_.PSPath 'DriverDesc') -match 'NVIDIA' } | Select-Object -First 1
        if ($cle) { Reg-Ecrire $cle.PSPath 'DisableDynamicPstate' 1 } else { Log 'nvidia    clé du pilote introuvable, DisableDynamicPstate non posé' }
    }
}

# Ce que fait la case une fois cochée, affiché en étiquette devant chaque ligne : 'off' (coupe le truc, le défaut),
# 'on' (l'ajoute ou l'autorise), 'set' (change une valeur). Un item absent d'ici est 'off'.
$Actions = @{
    'jeu-timer' = 'on'; 'jeu-f8' = 'on'
    'conf-menu-classique' = 'on'; 'conf-fin-tache' = 'on'; 'conf-corbeille' = 'on'; 'conf-vlc-pistes' = 'on'
    'jeu-svchost' = 'set'; 'jeu-hdd' = 'set'; 'net-moderation' = 'set'; 'conf-explorateur' = 'set'
    'conf-menus' = 'set'; 'conf-demarrage' = 'set'; 'conf-fin' = 'set'; 'conf-ducking' = 'set'
    'adv-priosep' = 'set'; 'adv-rawmouse' = 'set'; 'adv-boost' = 'set'; 'nv-pstate' = 'set'
}
function Item-Action($it) { if ($Actions[$it.Id]) { $Actions[$it.Id] } else { 'off' } }

# Détection de ce qui est déjà fait. Par défaut le bloc Appliquer est rejoué en simulation ($Bagarre.Simulation) : les
# fonctions d'écriture comparent au lieu d'écrire. Les items qui lancent une commande directe ont leur test ici,
# ils ne doivent JAMAIS être rejoués en simulation (bcdedit, powercfg /h, schtasks, explorer relancé).
$Verifs = @{
    'jeu-hiber' = { (Reg-Lire 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' 'HibernateEnabled') -eq 0 }
    'jeu-f8' = { [bool]((bcdedit /enum '{current}' 2>$null) -match 'bootmenupolicy\s+Legacy') }
    'net-alim' = {
        $cartes = @(Cartes-Reseau)
        if ($cartes.Count -eq 0) { $null }
        else { @($cartes | ForEach-Object { [string](Get-NetAdapterPowerManagement -Name $_.Name -ErrorAction SilentlyContinue).AllowComputerToTurnOffDevice }) -notcontains 'Enabled' }
    }
    'conf-menu-classique' = { Test-Path 'HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' }
    'conf-reserve' = { [string](Get-WindowsReservedStorageState -ErrorAction SilentlyContinue).ReservedStorageState -eq 'Disabled' }
    'conf-corbeille' = { Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}' }
    'adv-dyntick' = { [bool]((bcdedit /enum '{current}' 2>$null) -match 'disabledynamictick\s+Yes') }
}
# Rend $true (déjà fait), $false (à faire) ou $null (rien à comparer sur cette machine)
function Detecter-Item($it) {
    if ($Verifs[$it.Id]) { try { return (& $Verifs[$it.Id]) } catch { return $null } }
    $Bagarre.Verif = New-Object System.Collections.ArrayList
    $Bagarre.Simulation = $true
    try { & $it.Appliquer } catch {} finally { $Bagarre.Simulation = $false }
    if ($Bagarre.Verif.Count -eq 0) { return $null }
    return ($Bagarre.Verif -notcontains $false)
}
