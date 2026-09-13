#Requires -Version 5.1
param([switch]$Liste, [string]$Capture, [string]$Depuis)  # -Liste : le catalogue en texte, sans rien appliquer. -Capture dossier : chaque onglet en PNG, sans fenetre. -Depuis : dossier du clone (pose par la relance admin).
# bagarre.ps1 : GENERE par build.ps1 a partir de src/ et textes/. Ne pas editer ce fichier, edite les sources.
# UTF-8 SANS BOM : "irm" garde le BOM dans le texte et PowerShell le prend pour une commande. Pour le lancer en local :
#   & ([scriptblock]::Create([IO.File]::ReadAllText("bagarre.ps1", [Text.Encoding]::UTF8))) -Liste

$Textes = @{}
$Textes['accueil'] = @'
Ce pack enlève ce qui tourne pour rien et règle ce qui compte pour jouer.
Pas de sauvegarde avant : si ça casse, tu réinstalles, c'est le principe d'un Windows tout frais.

Dans l'ordre des onglets, à gauche :

  1. Installation          30 min     Windows propre, mises à jour, pilotes
  2. Facile                15 min     débloat en deux clics, DirectX, Visual C++, tes applis
  3. Le script à cocher    10 min     services, vie privée, jeu, carte réseau, confort
  4. NVIDIA                15 min     pilote nu, ancien Panneau de configuration
  5. Dur                   20 min     tu lis tout avant de toucher
  6. Maintenance           plus tard  nettoyer et vérifier, des mois après
  7. DNS                   1 min      le résolveur le plus rapide depuis chez toi
  8. Audit IA              10 min     une IA vérifie ton PC et trouve ce qui manque

Facile suffit pour un PC de bureau. Le script à cocher est le vrai niveau pour jouer.
Dur, tu comprends chaque ligne avant de cocher.

Règle du pack : chaque opti dit ce qu'elle change et ce que tu perds.
Tu ne comprends pas une ligne, tu ne la coches pas.

Les boutons "(winget)" ouvrent une console qui installe la version du jour de l'outil.
Win11Debloat et WinUtil se lancent tels quels, dans leur propre console.

Tout ce que le script à cocher modifie est noté dans C:\ProgramData\bagarre
(bagarre-avant.json pour les valeurs d'avant, bagarre.log pour le détail).
"Tout remettre comme avant", onglet 3, restaure exactement ces valeurs.

Pour rouvrir bagarre plus tard, la même commande dans un Terminal :
  irm https://raw.githubusercontent.com/klNuno/windows-bagarre/main/bagarre.ps1 | iex
'@
$Textes['audit'] = @'
Le pack est générique. Ton PC ne l'est pas : ta carte réseau, ton GPU, tes programmes,
tes jeux. L'audit prend une photo de ton PC et la donne à une IA avec un prompt qui sait
ce que le pack a fait, ce qu'il refuse de faire, et comment juger une opti.

1) Bouton "Collecter le rapport". 30 secondes. Il écrit rapport-pc.txt et AUDIT.txt (le prompt)
   dans un dossier bagarre-audit sur ton Bureau, et l'ouvre. Il ne modifie rien. Le rapport ne
   contient ni nom de compte, ni mot de passe, ni clé de licence. Ouvre-le quand même avant de
   l'envoyer, c'est ton PC.

2) Bouton "Copier le prompt" (ou ouvre AUDIT.txt et copie tout).

3) Choisis ton IA :
   - Claude Code, Codex, Gemini CLI ou tout agent en terminal : ouvre-le dans le dossier
     bagarre-audit et colle le prompt. Il lira rapport-pc.txt tout seul et peut aller vérifier des trucs.
   - ChatGPT, Claude.ai, un chat web : colle le prompt, puis joins rapport-pc.txt
     (ou colle son contenu à la suite).

4) Lis la réponse comme le reste du pack : chaque proposition doit dire ce que ça change,
   ce que tu perds, et d'où ça vient. Une proposition sans source ou sans contrepartie,
   tu ne l'appliques pas. Une chose à la fois, tu mesures avec RivaTuner, tu gardes ou tu remets.

L'IA ne touche pas à ton PC. Elle lit et propose. C'est toi qui appliques.
'@
$Textes['audit-prompt'] = @'
Tu es un expert Windows 11 orienté jeu et latence, prudent, qui préfère une opti mesurable à dix optis de forum.
Tu audites un PC dont l'état est dans le fichier rapport-pc.txt (à côté de ce prompt, ou joint au message).
Réponds en français, tutoiement, ton direct, pas de blabla.

CONTEXTE
Ce PC a suivi le pack "windows bagarre edition" :
- Windows 11 frais, Windows Update à jour, pilotes chipset/réseau du constructeur.
- Win11Debloat (mode par défaut) et WinUtil (tweaks Standard).
- Pilote NVIDIA installé nu via NVCleanstall : sans NVIDIA App, MSI High, HDCP coupé, Ansel coupé, MPO gardé
  (coupé seulement en cas d écran noir ou scintillement), signature reconstruite (méthode compatible EAC).
  Panneau de configuration NVIDIA classique depuis le Store, faible latence Activé (Ultra si pas de cap FPS),
  performances max, cache shaders illimité, G-Sync + V-Sync Activé dans le Panneau + cap RTSS sous le taux de l écran.
- Script à cocher bagarre.ps1 : services inutiles (télémétrie, fax, démo, Edge update...), télémétrie, CEIP et rapports
  d erreur au minimum, Copilot/Recall/Click to Do/Widgets/IA Bloc-notes et Paint coupés, Game DVR et PresenceWriter coupés,
  GlobalTimerResolutionRequests=1, timer 0,507 ms via une tâche planifiée SetTimerResolution, accélération souris coupée,
  veille prolongée et démarrage rapide coupés, suspension USB, USB3 LPM, ASPM PCIe et minuteurs de réveil coupés,
  pilotes exclus de Windows Update, Continuous Innovation refusé, menu F8, AutoRun coupé, ARSO coupé, carte réseau
  (alimentation, EEE, LLDP/topologie décochés, Interrupt Moderation Medium), confort (menu clic droit classique,
  Fin de tâche dans la barre, Edge sans Startup Boost, Explorateur).
  Options décochées par défaut : SvcHostSplitThreshold (placebo), Win32PrioritySeparation 0x26, PowerThrottlingOff,
  Nagle, disabledynamictick, RawMouseThrottleDuration, FTH off, LLMNR off, presse-papiers, Dynamic Lighting,
  P0 NVIDIA, core parking.

CE QUE LE PACK REFUSE, NE LE PROPOSE PAS
- Désactiver HVCI / intégrité de la mémoire, Secure Boot, Defender, le pare-feu, Windows Update, l'UAC.
- Nettoyeurs de registre, "optimiseurs" payants, scripts qui font 200 changements d'un coup.
- Réglages BIOS (hors de portée du pack).
- Plan "Ultimate performance", tweaks prefetch/superfetch, "débrider les 20 % de bande passante", tweaks placebo
  (LargeSystemCache, IRQ8Priority, files d'attente souris/clavier, TcpWindowSize, désactiver le fichier d'échange).
- Désactiver un service dont tu n'es pas sûr : NvContainer, Windows Audio, Themes, Cryptographic Services,
  Windows Time, Storage Service, Device Install, Windows Management Instrumentation restent.

TA MISSION, DANS CET ORDRE
1. Vérification du pack : pour chaque point du CONTEXTE, dis s'il est FAIT, PAS FAIT ou INCERTAIN d'après le rapport,
   avec la ligne du rapport qui le prouve. Liste ce qui manque, avec la case du script ou l'étape du tuto à refaire.

2. Ce qui cloche : pilotes vieux (compare la date du pilote GPU et réseau à aujourd'hui), MSI absent sur le GPU ou la
   carte réseau, programmes en démarrage automatique inutiles, services tiers en automatique (launchers, updaters,
   RGB), bloat Store encore présent, autre antivirus en doublon, erreurs système répétées (WHEA, disque, pilote),
   disque presque plein, HAGS ou optimisations fenêtrées incohérentes avec le GPU, DNS lent ou du FAI.

3. Optis propres à CETTE config, que le pack générique ne peut pas connaître :
   - le modèle exact de CPU (E-cores / P-cores, X3D, portable), de GPU, de carte réseau (Realtek, Intel, Killer,
     Marvell) et ce qu'il faut régler chez eux précisément ;
   - les programmes installés (Discord, launchers, RGB, overlays) et lesquels coûtent en jeu ;
   - l'écran (Hz, G-Sync) et la cohérence V-Sync / cap FPS / faible latence ;
   - la RAM (barrettes, vitesse annoncée vs XMP probable, mais sans étape BIOS : signale seulement).

4. Pour CHAQUE proposition, ce format, sinon elle ne vaut rien :
   - Quoi : le réglage exact (clé de registre, commande, menu), prêt à appliquer.
   - Pourquoi : le mécanisme en deux phrases, pas "ça optimise".
   - Ce que tu perds : la contrepartie, même petite. "Rien" est rarement vrai.
   - Source : doc constructeur, doc Microsoft, dépôt maintenu, avec le nom et l'année. Pas de vidéo, pas de "on dit".
   - Gain attendu : mesurable ou pas, et comment le mesurer (RivaTuner temps d'image, MeasureSleep, ping, LatencyMon).
   - Réversible : comment revenir en arrière.
   Classe-les : FAIRE (gain net, sans risque) / TESTER (une à la fois, mesurer) / NON (placebo ou nuisible, dis pourquoi).

5. Termine par les 5 actions les plus utiles pour ce PC précis, dans l'ordre, une ligne chacune.

RÈGLES
- Tu ne modifies rien toi-même, même si tu as accès au terminal. Tu proposes, l'utilisateur applique.
  Si tu es un agent avec accès au PC, tu peux lire (registre, Get-*, powercfg /query) pour préciser un point,
  jamais écrire.
- Si le rapport ne permet pas de conclure, dis INCERTAIN et dis quelle commande lancer pour trancher.
- Pas d'estimation de FPS inventée. "Quelques ms de latence" seulement si tu peux dire d'où elles viennent.
- Court. Une opti qui demande un paragraphe pour se justifier n'est probablement pas une opti.
'@
$Textes['dns'] = @'
Quad9 bloque les domaines malveillants connus et ne garde pas ton adresse IP dans ses journaux.
Cloudflare est en général le plus rapide. Google garde des journaux. Le DNS du FAI est souvent le plus
lent, sauf chez Free où il est très bon.

Un écart sous 5 ms ne se sent pas. Si ta box est à moins de 5 ms de la meilleure, garde-la.

Pour chiffrer le DNS choisi (DoH : ta box et ton FAI ne voient plus les noms demandés) :
Paramètres > Réseau et Internet > ta carte > Attribution du serveur DNS > Modifier > DNS chiffré :
Chiffré de préférence. Facultatif, zéro effet sur le ping.

"Tout remettre comme avant" (onglet 3) remet aussi le DNS d'avant.
'@
$Textes['dur'] = @'
DUR (20 min) : lis tout avant de toucher

Ici tu changes une chose à la fois, tu joues 30 minutes, tu regardes le graphe de temps d'image
de RivaTuner, tu gardes ou tu remets. Une opti que tu ne peux pas mesurer n'existe pas.
Le protocole de mesure propre est dans l onglet Maintenance ("Mesurer avant / après").

1) Timer 0,507 ms
   Le script à cocher a créé la tâche "bagarre timer" (SetTimerResolution.exe, open source GPL,
   dépôt valleyofdoom/TimerResolution). Vérifie avec MeasureSleep (bouton, onglet Maintenance) : environ 0,5 ms attendu.
   Si MeasureSleep montre 1 ms ou 15,6 ms : la clé GlobalTimerResolutionRequests n'est pas posée
   (case jeu-timer du script) ou la tâche n'a pas démarré (Planificateur de tâches, "bagarre timer").
   Process Lasso n'est plus dans le pack : 30 s d'attente au démarrage en gratuit, timer payant
   après un mois. ThreadPilot (AGPL) existe pour l'affinité par processus, sans ProBalance ni timer,
   curiosité seulement.

6) Souris
   Accélération coupée par le script. Ensuite : 1000 Hz dans le logiciel de la souris,
   DPI natif (400 / 800 / 1600), sensibilité réglée dans le jeu, pas dans Windows (6/11 = 1:1).
   RawMouseThrottleDuration (case adv-rawmouse) : à tester seulement à 4000 Hz et plus, et souvent
   déjà à 8 par défaut sur Windows 11 récent (la valeur d avant est dans bagarre.log, bouton de l onglet 3).

7) Win32PrioritySeparation (case adv-priosep)
   0x26 = quantum court, variable, boost x3 au premier plan. Peut aider un jeu CPU-bound avec Discord
   et un navigateur derrière. Peut aussi faire crépiter l'audio. Mesure.

8) Mémoire
   16 Go de RAM et des jeux récents : ISLC (Intelligent Standby List Cleaner, Wagnardsoft) vide la
   liste d'attente quand la RAM libre passe sous 1 Go, ça évite les saccades de swap. 32 Go et plus :
   inutile. La compression mémoire de Windows reste activée dans tous les cas (la couper fait swapper
   plus tôt).

9) Cœurs pour le jeu (AutoGpuAffinity, facultatif)
   Un script qui teste sur quel cœur poser l'interruption GPU et donne le meilleur. Long (1 h), à faire
   sur un PC déjà stable. Dépôt valleyofdoom/AutoGpuAffinity.
   MSI Util v3 : pour REGARDER que la carte graphique est bien en MSI (NVCleanstall l'a fait), pas
   pour écrire. Son pilote inpoutx64.sys est bloqué par Windows depuis KB5121003 (2026) : si l'outil
   ne se lance plus, c'est ça, et tu n'en as pas besoin.

10) Stockage
   DirectStorage (Forspoken, Ratchet & Clank, Starfield) : le jeu sur le NVMe, pas sur un SATA, et
   la compression NTFS jamais sur un dossier de jeu (CompactGUI : uniquement les vieux jeux 2D).
   Le cache de shaders (%LOCALAPPDATA%\NVIDIA\DXCache) ne se "nettoie" pas : le vider fait
   recompiler tous les shaders à la partie suivante.

11) Boost CPU (case à cocher dans powercfg, PC fixe Intel uniquement, facultatif)
   powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2 (Aggressive) puis
   powercfg /setactive SCHEME_CURRENT. Le processeur monte plus vite en fréquence. Sur AMD le boost
   est géré par le firmware, la clé ne fait rien. Sur portable, non : chauffe pour rien.

12) Si tu es en AMD (une page suffit)
   Pilote via le site AMD, installation "pilote seul" (pas Adrenalin complet) ou Radeon Software
   Slimmer (open source). Anti-Lag 2 activé par jeu si dispo. AFMF (génération d'images) off en
   compétitif. Sur un Ryzen X3D, laisse le core parking : c'est lui qui garde le jeu sur le CCD avec
   le cache. Tout le reste du pack s'applique pareil.

13) Mises à jour de fonctionnalités
   Paramètres > Windows Update > Options avancées : suspendre jusqu'à 5 semaines quand une grosse
   version (25H2, 26H1) sort, le temps que les pilotes et anti-cheats suivent. Pas plus : les
   correctifs de sécurité en dépendent. Le "Xbox Mode" / mode plein écran Xbox n'apporte rien sur un
   PC fixe, c'est pour les consoles portables.

Les vidéos du pack précédent (chaîne Khorvie Tech), retrouvées via la Wayback Machine :
- "BOOST PC PERFORMANCE | Win32 Priority Separation Benchmarks" (mai 2024, 3 min) : passée en privé.
  Benchmark sur une seule machine, une seule scène. Retenu comme case Avancé décochée, pas plus.
- "Debunk'd Mouse and Keyboard Data Queue Sizes" (juillet 2024) : supprimée. Concluait que le tweak
  des files d'attente souris / clavier ne change rien. Pas dans le pack.
- "The ONLY Windows PC OPTIMIZATION Guide 2024" (avril 2024, 40 min, 1,6 M de vues) : passée en privé.
  Les timecodes du pack tombaient dans "network tweaks" (21:35). Ce qui était utile est dans
  le groupe Carte réseau du script, avec l'explication. Le reste (unpark CPU via outil tiers,
  "win tweaker") est couvert par le script ou volontairement absent.

Ce qu'on ne fait pas, et pourquoi :
- HVCI / intégrité de la mémoire off : les anti-cheats le demandent, les mises à jour d'octobre 2026
  la réactivent de toute façon, et le gain est de 1 à 3 %.
- Nettoyeur de registre : rien à gagner, tout à casser.
- Plan "Ultimate performance" : identique à Hautes performances sur un fixe depuis 1903.
- Désactiver le service Windows Update, Defender, le pare-feu : non.
- Tweaks de prefetch / superfetch : le SSD s'en moque, SysMain aide sur HDD.
- "Débrider" la bande passante (20 % réservée) : mythe, la clé n'a jamais fait ça.
- HPET / useplatformclock, TdrLevel, DisablePreemption, MouseDataQueueSize, NetworkThrottlingIndex,
  SystemResponsiveness=0, IPv6 off, C-states off, Interrupt Moderation "Disabled" : testés par
  d'autres, rien de mesurable ou nuisible. Renommer GameBarPresenceWriter.exe : le script le coupe
  proprement (clé ActivationType), jamais en renommant.
- Lossless Scaling, ExplorerPatcher, ViveTool, ParkControl, HIDUSBF : soit payants, soit cassés à
  chaque mise à jour, soit couverts par le script.
'@
$Textes['facile'] = @'
FACILE (15 min) : deux commandes et deux installeurs

Les deux boutons du haut ouvrent chaque outil dans sa propre console, en administrateur.
Ils téléchargent la version du jour, rien à mettre à jour ici. Les commandes sont notées pour info.

1) Win11Debloat (bouton) : enlever ce que Windows a installé sans demander
   & ([scriptblock]::Create((irm "https://debloat.raphi.re/")))
   Mode par défaut. Retire les applis sponsorisées, Copilot, les pubs du menu Démarrer,
   la télémétrie, et demande avant chaque groupe. Mis à jour plusieurs fois par mois, connaît 24H2 et 25H2.
   OneDrive : il propose de le désinstaller. Dis oui si tu ne t'en sers pas, mais AVANT vérifie que
   Documents / Images ne sont pas "dans OneDrive" (clic droit > Propriétés > Emplacement) : sinon
   ils partent avec.

2) WinUtil de Chris Titus (bouton) : installer tes programmes d un coup
   irm https://christitus.com/win | iex
   Onglet Install : coche Steam, Discord, navigateur, 7-Zip, VLC, il installe tout via winget.
   Onglet Tweaks : preset "Standard" seulement. Pas l'onglet Advanced, le script à cocher
   de l onglet 3 fait pareil en expliquant chaque ligne.
   Jamais la version "windev" (branche de développement).
   Pour refaire la même install sur un autre PC : "winget export -o mes-applis.json" ici,
   "winget import mes-applis.json" là-bas.

3) DirectX et Visual C++ : les librairies que les jeux réclament
   Sans elles un jeu plante avec "VCRUNTIME140.dll introuvable".
   - DirectX : bouton ci-dessus (winget Microsoft.DirectX). Pour les vieux jeux.
   - Visual C++ : bouton ci-dessus. Ce qu il lance, si tu préfères le taper dans un Terminal admin :

   '2005','2008','2010','2012','2013' | ForEach-Object {
     winget install --id "Microsoft.VCRedist.$_.x86" -e --accept-package-agreements --accept-source-agreements
     winget install --id "Microsoft.VCRedist.$_.x64" -e --accept-package-agreements --accept-source-agreements
   }
   winget install --id 'Microsoft.VCRedist.2015+.x86' -e --accept-package-agreements --accept-source-agreements
   winget install --id 'Microsoft.VCRedist.2015+.x64' -e --accept-package-agreements --accept-source-agreements

   Vient de Microsoft, se met à jour avec "winget upgrade --all".

4) Petits trucs de clavier et de recherche
   - Touche Copilot sur un clavier récent : Paramètres > Personnalisation > Saisie de texte >
     "Personnaliser la touche Copilot" (depuis KB5124010) pour en faire une recherche ou une appli.
     Sinon PowerToys > Gestionnaire de clavier.
   - Si tu as installé Gemini ou Copilot en appli : leur overlay se colle sur Alt+Espace. Coupe-le
     dans leurs réglages, ou tu l'auras en plein jeu.
   - Si tu as coupé l'indexation (case svc-recherche du script) : Everything (voidtools, gratuit)
     retrouve n'importe quel fichier en une seconde sans index Windows.

5) Audio (5 min, ça évite les crépitements)
   - Clic droit sur le haut-parleur > Sons > onglet Communications : "Ne rien faire" (sinon Windows
     baisse ton son de 80 % quand Discord sonne).
   - Périphérique de lecture > Propriétés > Améliorations : "Désactiver toutes les améliorations".
     Onglet Avancé : 24 bits, 48000 Hz (le format des jeux et de Discord, zéro rééchantillonnage).
   - Nahimic / Sonic Studio / Realtek Audio Console : désinstalle, le pilote nu suffit (voir Maintenance).
'@
$Textes['installation'] = @'
1) quand t'installes Windows 11
- bypass compte local : "start ms-cxh:localonly"
   - Juste après le premier bureau, dans un Terminal admin :  fsutil 8dot3name set 1
     Ça coupe la génération des noms courts "PROGRA~1" sur les disques neufs (moins d'écritures
     par fichier créé). À faire avant d'installer quoi que ce soit, ça ne se rattrape pas après.

2) Windows Update avant de continuer

3) Pilotes, dans l'ordre :
   a. Chipset et carte réseau : site du fabricant de ta carte mère (ou du portable), ton modèle exact.
   b. Carte graphique NVIDIA : PAS maintenant, c est l onglet 4. NVIDIA.
      AMD : site AMD.
   c. Windows Update encore une fois : depuis 24H2 il finit le reste (audio, USB, Bluetooth).
   d. Snappy Driver Installer Origin (bouton ci-dessus) : dernier recours, ne coche que ce qui manque.
'@
$Textes['maintenance'] = @'
MAINTENANCE : quand le PC a vécu

- Autoruns (bouton) : tout ce qui se lance au démarrage. Options > Hide Microsoft
  entries, puis décoche ce que tu ne reconnais pas (launchers, updaters). Décoche, ne supprime pas.
- Geek Uninstaller (bouton) : désinstalle proprement et enlève les restes. Mieux que Paramètres > Applis.
- MeasureSleep (bouton) : vérifie le timer. Attendu environ 0,5 ms après le script.
  1 ms ou 15,6 ms : voir le tuto Dur, point 1.

Suites constructeur à virer (elles sont là sans qu'on te demande) : Nahimic, Killer Intelligence
Center, Armoury Crate, MSI Center, Dragon Center, Sonic Studio. Chacune pose un service et un
overlay audio ou réseau. Pour les ventilos : FanControl (open source). Pour les LED : OpenRGB, ou le
logiciel de la marque seul (iCUE, Synapse) sans ses "modules".

Nettoyage disque, dans l'ordre :
1. Windows + R > cleanmgr > Nettoyer les fichiers système : anciennes mises à jour, corbeille.
2. Paramètres > Système > Stockage > Assistant de stockage : activé, tous les mois, corbeille 30 jours,
   Téléchargements jamais (il efface ce que tu n'as pas encore rangé).
3. Terminal admin, WinSxS :
   Dism /Online /Cleanup-Image /AnalyzeComponentStore     (dit s'il y a quelque chose à nettoyer)
   Dism /Online /Cleanup-Image /StartComponentCleanup     (jamais /ResetBase : plus de désinstallation de mise à jour)
4. BleachBit (open source, winget install BleachBit.BleachBit) si tu veux plus : caches navigateurs, logs.
   Ne coche jamais "Free disk space" ni "Memory" : lent et inutile sur SSD.
5. DriverStore Explorer (RAPR) : supprime les vieux pilotes NVIDIA empilés (plusieurs Go).
6. SSD : Optimize-Volume -DriveLetter C -ReTrim dans un terminal admin (TRIM, une fois par mois
   l'Assistant de stockage le fait déjà). CrystalDiskInfo pour la santé et la température.

Pilotes : Windows Update ne les touche plus (case jeu-pilotes). Tu les mets à jour toi-même :
NVIDIA via NVCleanstall, le reste depuis le site du constructeur, seulement si un truc marche mal.
DDU (Display Driver Uninstaller) seulement quand tu changes de marque de carte graphique, pas à
chaque pilote : NVCleanstall "clean installation" suffit.

Defender qui pompe : Windows a un outil officiel pour voir quel fichier coûte (PowerShell admin).
  New-MpPerformanceRecording -RecordTo C:\defender.etl    (joue 10 min, puis Ctrl+C)
  Get-MpPerformanceReport -Path C:\defender.etl -TopFiles 10 -TopExtensions 10
Le dossier qui ressort va dans Exclusions (dossier du jeu ou du launcher). Jamais tout le disque.

Le PC se réveille tout seul / ne dort pas (terminal admin) :
  powercfg /lastwake         (qui l'a réveillé)
  powercfg /waketimers       (qui a le droit de le réveiller, vide après la case jeu-reveil)
  powercfg /requests         (ce qui l'empêche de dormir : souvent un navigateur avec une vidéo)
  powercfg /sleepstudy       (portable : rapport HTML de ce qui a vidé la batterie en veille)
Wi-Fi qui décroche : netsh wlan show wlanreport, puis ouvre le rapport HTML indiqué.
Plantages ou écrans bleus : Observateur d'événements > Système, filtre source "WHEA-Logger" :
une erreur WHEA = matériel (RAM, overclock, alim), pas Windows.

Mesurer avant / après (le seul moyen de savoir si une opti fait quelque chose) :
  Outil : CapFrameX (gratuit) ou PresentMon (Intel, open source). RivaTuner pour voir en direct.
  1. Même jeu, même scène (un benchmark intégré ou un replay), même résolution.
  2. Une passe de chauffe (jetée), puis 3 passes de 60 s AVANT, 3 passes APRÈS, en alternant si tu
     peux (avant, après, avant, après...) pour lisser la température.
  3. Regarde la médiane des FPS, le 1 % low et le p99 du temps d'image. Pas la moyenne.
  4. Un écart sous 3 % avec des 1 % low qui bougent dans les deux sens = pas d'effet. Remets comme avant.
  PresentMon te dit aussi le "PresentMode" : "Hardware: Independent Flip" = le jeu est présenté sans
  copie (fenêtré optimisé ou plein écran), "Composed: Flip" = il passe par le compositeur (une image
  de latence en plus). C'est comme ça qu'on vérifie que MPO et les optimisations fenêtrées marchent.

Dev Drive (si tu compiles ou tu as des projets lourds) : Paramètres > Système > Stockage > Disques
avancés > Créer un Dev Drive. Partition ReFS avec Defender en mode performance. Pas pour les jeux.

RegCleaner et PureRa, qui étaient dans l ancien pack, sont retirés. Verdict 2026 : obsolètes,
aucun gain sur un Windows moderne, un risque de casser une clé. Les anciens .reg
(Corbeille dans Ce PC, Accès rapide, VLC) sont des cases décochées du groupe Confort, onglet 3.
'@
$Textes['nvidia'] = @'
NVIDIA (15 min) : le pilote nu, puis l'ancien Panneau de configuration

À savoir en 2026 : depuis le pilote 610.47 (mai 2026) le Panneau de configuration classique
n'est plus dans le pilote. Il s'installe depuis le Store (étape 2), et disparaît à chaque
installation propre : tu le réinstalles après.

1) NVCleanstall (bouton : winget installe la dernière version)
   - "Manual", dernier pilote Game Ready pour ta carte.
   - Composants : Display Driver, et PhysX si tu joues à des jeux qui l'utilisent. Rien d'autre.
     Pas de NVIDIA App, pas de GeForce Experience, pas de USB-C, pas de Stereo 3D.
     NVIDIA HD Audio : garde-le seulement si ton son sort par le câble HDMI / DisplayPort de l'écran.
   - Page "Installation Tweaks", coche comme sur la capture (bouton "Capture : NVCleanstall") SAUF la ligne MPO (voir plus bas). Ce que ça fait :
     . Perform a Clean Installation : repart de zéro.
     . Disable Ansel : overlay de capture, inutile.
     . Disable Driver Telemetry.
     . Enable Message Signaled Interrupts, priorité High : la carte parle au CPU par MSI
       au lieu de l'ancienne ligne d'interruption partagée. Moins de latence image prête / image affichée.
     . Disable HDCP : le chiffrement anti-copie du câble. Exigé par Netflix 4K et les Blu-ray, par rien d'autre.
       Actif, il provoque des micro-coupures quand la liaison se renégocie (alt-tab, sortie de veille).
       Tu perds : Netflix / Disney+ en 4K dans le navigateur (la 1080p passe).
     . Rebuild digital signature + "Use method compatible with Easy-Anti-Cheat" + "Automatically accept" :
       NVCleanstall a modifié le pilote (HDCP, MSI), la signature NVIDIA ne colle plus, Windows refuserait.
       Il re-signe. La méthode EAC garde le fichier du pilote intact, seul l'installeur change,
       donc l'anti-cheat voit un pilote NVIDIA officiel. Validé par le mainteneur du pack sur les
       anti-cheats courants. Si un jeu refuse de lancer après : réinstalle le pilote sans ces deux cases.
     . Disable Multiplane Overlay (MPO) : DÉCOCHÉ par défaut maintenant. MPO est ce qui permet au jeu
       fenêtré d'être présenté sans copie (les "optimisations pour les jeux fenêtrés" en dépendent).
       Coche-le seulement si tu as des écrans noirs ou des scintillements en multi-écran, c'est le
       correctif officiel NVIDIA (clé OverlayTestMode=5). Une grosse mise à jour Windows peut la
       réécrire : si le bug revient, repasse par NVCleanstall.
   - Install. L'écran clignote et des messages rouges passent, c'est normal, ne touche à rien.
   La fois suivante, NVCleanstall propose "paramètres précédents", plus besoin de recocher.

2) Panneau de configuration NVIDIA (l ancien), bouton ci-dessus. Ce qu il lance :
   winget install --id 9NF8H0H7WMLT --source msstore
   Il a besoin du service NVIDIA Display Container (NvContainer) : ne le désactive jamais.

   Réglages (bouton "Capture : Panneau NVIDIA"), Gérer les paramètres 3D > Paramètres globaux :
   - Mode de faible latence : Activé. Le pilote garde une seule image d'avance. "Ultra" force zéro
     image d'avance et coûte des saccades quand le CPU est à la limite : c'est le réglage d'avant
     Reflex. Si un jeu propose Reflex, Reflex prend le dessus, normal.
   - Gestion de l'alimentation : Privilégier les performances maximales. Sur les pilotes récents
     (616.xx) le réglage ne s'applique pas toujours : vérifie au repos avec "nvidia-smi -q -d CLOCK"
     dans un terminal, si les fréquences retombent à l'idle c'est ignoré, et ce n'est pas grave.
   - Taille du cache de shaders : Illimitée. Le défaut (4 Go) sature, un shader évincé se recompile
     en pleine partie : pic de temps d'image.
   - Filtrage de texture, qualité : Hautes performances.
   - Optimisation threadée : Activé.
   - Synchronisation verticale et G-Sync, deux cas :
     . Écran G-Sync / compatible : G-Sync activé dans "Configuration de G-SYNC", V-Sync "Activé" ICI
       dans le Panneau, V-Sync OFF dans chaque jeu, et un cap de FPS 3 à 4 sous le taux de l'écran
       (RivaTuner, tuto Dur, ou Reflex qui le fait tout seul). C'est la combinaison documentée par
       Blur Busters : zéro tearing, latence minimale. Le "paramètre de l'application" de l'ancien tuto
       laissait le jeu remettre sa V-Sync classique par-dessus G-Sync.
     . Sans G-Sync : V-Sync Désactivé, cap RivaTuner seul, Reflex si le jeu l'a.
     Jeu en fenêtré ou sur un portable hybride (Optimus) : la V-Sync du Panneau ne s'applique pas
     toujours, règle-la dans le jeu.
   - Processeur graphique OpenGL : ta carte, pas "auto".
   - Smooth Motion (génération d'images par le pilote) : jamais en global. Par jeu, solo seulement,
     jamais en compétitif (ajoute une image de latence).
   Configurer Surround et PhysX : PhysX sur ta carte NVIDIA.
   Régler la taille et la position du bureau : second écran en "Pas de mise à l'échelle".
   Modifier la résolution : plage dynamique de sortie "Complète", format RGB 4:4:4. Le pilote choisit
   parfois "Limitée" sur une TV ou un écran HDMI : les noirs deviennent gris.

   Paramètres Windows > Système > Affichage > Graphiques :
   - "Optimisations pour les jeux fenêtrés" activé. Windows présente les images du fenêtré comme en
     plein écran, la latence baisse. Retour en arrière si un jeu clignote.
   - Planification GPU à accélération matérielle (HAGS) : garde activé. DLSS Frame Generation et
     Smooth Motion l'exigent. Le couper ne fait rien gagner sur une carte récente.
   - Auto HDR : off en compétitif, ça ajoute un traitement par image. On pour les jeux solo si l'écran
     est vraiment HDR (600 nits et plus).

3) MSI Afterburner et RivaTuner (bouton)
   Pas pour overclocker. Pour la courbe de ventilation et l'overlay RivaTuner (FPS, temps d'image,
   températures). C'est ton outil pour VOIR qu'une opti change quelque chose au lieu de le croire.
   Un seul overlay à la fois : RivaTuner OU Steam OU Discord OU la Game Bar. Deux overlays
   empilés, c'est un hook de plus par image.

Si tu as quand même installé la NVIDIA App (ou si un jeu te l'a imposée) :
   Paramètres > Fonctionnalités : overlay OFF, Instant Replay OFF, Freestyle OFF. Jeux : "optimiser
   automatiquement" OFF (elle réécrit tes réglages). Le reste du tuto s'applique pareil, le Panneau
   classique et l'App écrivent dans le même profil.
'@
$Textes['reseau'] = @'
CARTE RÉSEAU (5 min)

Le script à cocher fait tout ça tout seul, groupe "Carte réseau".
Ce tuto sert si tu veux le faire à la main ou vérifier. Captures : les deux boutons "Capture" au-dessus.

Panneau de configuration > Centre réseau > Modifier les paramètres de la carte
> clic droit sur ta carte > Propriétés.

1) Gestion de l'alimentation (bouton Configurer > onglet Gestion de l'alimentation)
   Décoche "Autoriser l'ordinateur à éteindre ce périphérique".
   Pourquoi : Windows coupe la carte au repos, elle met une seconde à revenir.
   C'est le "le réseau a lâché 2 secondes" après une veille.

2) Onglet Avancé (capture "onglet Avancé")
   - Energy Efficient Ethernet / Green Ethernet / Power Saving Mode : Désactivé.
     La puce s'endort entre deux paquets et se réveille avec un délai.
   - Interrupt Moderation Rate : Medium, PAS Désactivé. Désactivé = plus d'interruptions,
     plus de temps CPU volé au jeu. Souvent absent sur Realtek, tant pis.
   - Le reste : laisse par défaut. Jumbo Frame, Receive Buffers à fond, etc.
     n'apportent rien en jeu, c'est de l'UDP en petits paquets.

3) Liste des protocoles (capture "protocoles"), ce qu'on décoche
   - Pilote de protocole LLDP Microsoft
   - Répondeur de découverte de topologie de la couche de liaison
   - Pilote E/S de mappage de découverte de topologie
   Ces trois-là dessinent la carte du réseau local. Inutile.
   On GARDE : TCP/IPv4, TCP/IPv6 (des jeux et Xbox Live s'en servent), Client réseaux Microsoft
   et Partage de fichiers si tu as un NAS ou des dossiers partagés, Planificateur QoS
   si un autre appareil de la maison télécharge pendant que tu joues.
'@

# ===== 00-noyau.ps1 =====
# ---------------------------------------------------------------------------
# Noyau : où on est, élévation, détection machine, outils d'écriture avec retour arrière.
# ---------------------------------------------------------------------------
$Depot = 'https://raw.githubusercontent.com/klNuno/windows-bagarre/main'
$Version = '2026-09-13'
$ErrorActionPreference = 'Continue'

# Lancé depuis un clone (powershell -File bagarre.ps1) : outils et images sont à côté.
# Lancé par "irm ... | iex" : $Here est vide, ils sont téléchargés depuis $Depot au besoin.
$Here = if ($Depuis) { $Depuis } elseif ($PSCommandPath -and (Test-Path (Join-Path (Split-Path -Parent $PSCommandPath) 'outils'))) { Split-Path -Parent $PSCommandPath } else { $null }

# Admin et thread STA (la fenêtre en a besoin). Sinon on se relance élevé, et on rend la main.
# -Liste et -Capture (modes de test) tournent sans admin.
# La relance passe par une copie locale du script (UTF-8 avec BOM, lisible par -File) : pas de "irm | iex" ni de
# fenêtre cachée sur la ligne de commande élevée, Defender classe ce motif en cheval de Troie (Commando.A!ml, vu le 2026-09-13).
$EstAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$EstSta = [Threading.Thread]::CurrentThread.GetApartmentState() -eq 'STA'
if (-not $Liste -and -not $Capture -and (-not $EstAdmin -or -not $EstSta)) {
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
# La commande passe par un petit .ps1 dans le dossier bagarre, pas par -EncodedCommand (motif suspect pour Defender).
$script:ConsoleN = 0
function Console-Lancer($titre, $commande) {
    $script:ConsoleN++
    $texte = "`$Host.UI.RawUI.WindowTitle = 'bagarre : $titre'`r`nWrite-Host ''`r`nWrite-Host '  $titre' -ForegroundColor Cyan`r`nWrite-Host ''`r`n$commande`r`n"
    $fichier = Join-Path $Dossier ("console-{0}.ps1" -f $script:ConsoleN)
    [IO.File]::WriteAllText($fichier, $texte, (New-Object Text.UTF8Encoding $true))
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -File `"$fichier`"" | Out-Null
    Log "console   $titre"
}

function Winget-Installer($titre, [string[]]$ids) {
    $cmd = ($ids | ForEach-Object { "winget install --id '$_' -e --accept-package-agreements --accept-source-agreements" }) -join '; '
    Console-Lancer $titre $cmd
}

# ===== 10-catalogue.ps1 =====
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
    if (Get-Service WSAIFabricSvc -ErrorAction SilentlyContinue) {
        Memoriser 'svc|WSAIFabricSvc' @{ nom = 'WSAIFabricSvc'; start = (Reg-Lire 'HKLM:\SYSTEM\CurrentControlSet\Services\WSAIFabricSvc' 'Start') }
        Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WSAIFabricSvc' -Name 'Start' -Value 3 -ErrorAction SilentlyContinue
        Log 'service   WSAIFabricSvc en manuel (pile IA, ne démarre plus tout seul)'
    }
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
    'Depuis Windows 11, une appli qui demande un timer à 0,5 ms ne l obtient que pour elle-même et seulement au premier plan. Cette clé rétablit le comportement Windows 10 : la demande vaut pour tout le système. C est ce que Process Lasso ou un outil de timer resolution exploite.' $true 'Consommation au repos très légèrement plus haute quand un programme demande un timer fin.' {
    Reg-Ecrire 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' 'GlobalTimerResolutionRequests' 1
}
Ajouter $G 'jeu-timer-demarrage' 'Timer à 0,507 ms au démarrage (SetTimerResolution en tâche planifiée)' `
    'Le complément de la clé du dessus : un programme de 40 lignes (SetTimerResolution, open source, GPL) demande un timer à 0,507 ms dès l ouverture de session et reste en mémoire. C est exactement ce que fait Process Lasso, sans les 30 secondes d attente de la version gratuite. 0,507 plutôt que 0,500 : mesuré sur plus de 30 machines, le réveil tombe pile sur le tick. Vérifie avec MeasureSleep (onglet Maintenance).' (-not $EstPortable) 'Consommation au repos un peu plus haute. Sur portable, laisse décoché.' {
    $exe = Outil-Obtenir 'SetTimerResolution.exe'
    if (-not $exe) { Log 'timer     SetTimerResolution.exe indisponible (pas de réseau ?), ignoré'; return }
    $dest = $Dossier
    Memoriser 'cmd|timer' @{ existait = [bool](Get-ScheduledTask -TaskName 'bagarre timer' -ErrorAction SilentlyContinue) }
    schtasks /Create /TN 'bagarre timer' /TR "`"$dest\SetTimerResolution.exe`" --resolution 5070 --no-console" /SC ONLOGON /RL HIGHEST /F | Out-Null
    Start-Process -FilePath (Join-Path $dest 'SetTimerResolution.exe') -ArgumentList '--resolution 5070 --no-console' -WindowStyle Hidden
    Log 'timer     tâche "bagarre timer" créée (0,507 ms au logon) et lancée'
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
    }
}
Ajouter $G 'net-eee' 'Couper Energy Efficient Ethernet / Green Ethernet' `
    'Même logique : la puce réseau s endort entre deux paquets pour économiser quelques milliwatts, et se réveille avec un délai. En jeu on veut la carte toujours réveillée.' $true 'Rien de visible.' {
    foreach ($c in Cartes-Reseau) { Net-Propriete-Regler $c 'Energy.Efficient|Green Ethernet|EEE|Power Saving' 'Disabled|Désactivé|Off' 'économie d énergie de la puce' }
}
Ajouter $G 'net-moderation' 'Modération des interruptions sur Medium (pas Désactivé)' `
    'La carte regroupe ses interruptions pour ne pas réveiller le CPU à chaque paquet. Medium garde le CPU disponible pour le jeu tout en livrant les paquets vite. Tout couper fait l inverse de ce que promettent les tutos : plus d interruptions, plus de temps CPU volé au jeu (mesuré au xperf par djdallmann sur trafic UDP de jeu).' $false 'Si ta carte n a pas cette option (souvent le cas sur Realtek), rien ne se passe.' {
    foreach ($c in Cartes-Reseau) { Net-Propriete-Regler $c '^Interrupt Moderation Rate' 'Medium|Moyen' 'modération d interruptions' }
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
Ajouter $G 'adv-dyntick' 'Couper le tick dynamique (bcdedit disabledynamictick)' `
    'Le noyau arrête son horloge quand rien ne se passe et la relance à la demande. Avec un timer à 0,5 ms ça peut dériver. À cocher seulement si MeasureSleep montre une résolution instable après le timer.' $false 'Consommation au repos un peu plus haute.' {
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

# ===== 20-dns.ps1 =====
# ---------------------------------------------------------------------------
# Test DNS : mesure les résolveurs depuis chez toi, applique celui que tu choisis
# ---------------------------------------------------------------------------
function Dns-Carte {
    Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Virtual|VMware|Hyper-V|Tailscale|TAP|WireGuard|Bluetooth' } | Sort-Object -Property LinkSpeed -Descending | Select-Object -First 1
}

function Dns-Actuels($adapt) {
    @((Get-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -AddressFamily IPv4).ServerAddresses)
}

# Résout 6 noms courants sur chaque serveur, 3 fois, garde la médiane. Rend une liste Nom / Serveurs / Mediane.
function Dns-Mesurer($adapt) {
    $actuels = Dns-Actuels $adapt
    $candidats = [ordered]@{
        'Actuel (box / FAI)'   = @($actuels)
        'Quad9 (9.9.9.9)'      = @('9.9.9.9', '149.112.112.112')
        'Cloudflare (1.1.1.1)' = @('1.1.1.1', '1.0.0.1')
        'Google (8.8.8.8)'     = @('8.8.8.8', '8.8.4.4')
    }
    $noms = 'youtube.com', 'steampowered.com', 'discord.com', 'twitch.tv', 'epicgames.com', 'wikipedia.org'
    $resultats = @()
    foreach ($nom in $candidats.Keys) {
        $serveur = $candidats[$nom][0]
        if (-not $serveur) { continue }
        $temps = @()
        foreach ($tour in 1..3) {
            foreach ($d in $noms) {
                $t = Measure-Command { try { Resolve-DnsName -Name $d -Server $serveur -Type A -DnsOnly -NoHostsFile -ErrorAction Stop | Out-Null } catch {} }
                $temps += $t.TotalMilliseconds
            }
        }
        $tri = $temps | Sort-Object
        $mediane = [math]::Round($tri[[int]($tri.Count / 2)], 1)
        $resultats += [pscustomobject]@{ Nom = $nom; Serveurs = $candidats[$nom]; Mediane = $mediane; Actuel = ($nom -like 'Actuel*') }
        Log ("dns       {0,-22} {1,7} ms" -f $nom, $mediane)
    }
    $resultats
}

function Dns-Appliquer($adapt, $r) {
    Memoriser "dns|$($adapt.ifIndex)" @{ ifIndex = $adapt.ifIndex; serveurs = (Dns-Actuels $adapt) }
    if ($r.Actuel) { Set-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -ResetServerAddresses }
    else { Set-DnsClientServerAddress -InterfaceIndex $adapt.ifIndex -ServerAddresses $r.Serveurs }
    SauverEtat
    Log "dns       $($adapt.Name) = $($r.Serveurs -join ', ') ($($r.Nom))"
}

# ===== 30-restaurer.ps1 =====
# ---------------------------------------------------------------------------
# Retour arrière et application
# ---------------------------------------------------------------------------
function Tout-Restaurer {
    if ($Avant.Count -eq 0) { Log 'Rien à restaurer : bagarre-avant.json est vide.'; return }
    Log "Restauration de $($Avant.Count) réglages..."
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
                'cmd|timer' {
                    if (-not $v.existait) { schtasks /Delete /TN 'bagarre timer' /F 2>$null | Out-Null }
                    Get-Process SetTimerResolution -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                }
                'task|*' { if ($v.etat -ne 'Disabled') { Enable-ScheduledTask -TaskPath $v.chemin -TaskName $v.nom -ErrorAction SilentlyContinue | Out-Null } }
                'netpm|*' { if ($v.valeur -eq 'Enabled') { Enable-NetAdapterPowerManagement -Name $v.carte -ErrorAction SilentlyContinue } }
                'netadv|*' { Set-NetAdapterAdvancedProperty -Name $v.carte -RegistryKeyword $v.mot -RegistryValue $v.valeur -ErrorAction SilentlyContinue }
                'netb|*' { if ($v.actif) { Enable-NetAdapterBinding -Name $v.carte -ComponentID $v.composant -ErrorAction SilentlyContinue } }
                'dns|*' {
                    if ($v.serveurs -and $v.serveurs.Count -gt 0) { Set-DnsClientServerAddress -InterfaceIndex $v.ifIndex -ServerAddresses $v.serveurs }
                    else { Set-DnsClientServerAddress -InterfaceIndex $v.ifIndex -ResetServerAddresses }
                }
            }
            Log "restauré  $id"
        } catch { Log "ÉCHEC restauration $id : $_" }
    }
    powercfg /setactive SCHEME_CURRENT | Out-Null
    $Avant.Clear()
    Remove-Item $EtatFichier -ErrorAction SilentlyContinue
    Log 'Terminé. Redémarre pour que tout reprenne effet.'
}

function Appliquer-Items($liste) {
    $liste = @($liste)
    if ($liste.Count -eq 0) { Log 'Rien de coché.'; return }
    Log "Application de $($liste.Count) réglages..."
    foreach ($it in $liste) {
        Log "> $($it.Titre)"
        try { & $it.Appliquer } catch { Log "ÉCHEC $($it.Id) : $_" }
        SauverEtat
    }
    Log "Terminé. Les valeurs d avant sont dans $EtatFichier, le détail dans $LogFichier. Redémarre le PC."
}

# ===== 40-collecte.ps1 =====
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

# ===== 50-fenetre.ps1 =====
# ---------------------------------------------------------------------------
# Mode -Liste : le catalogue en texte, sans rien appliquer (test)
# ---------------------------------------------------------------------------
if ($Liste) {
    Write-Host "Machine : $Machine"
    $Items | ForEach-Object { '{0,-24} {1} {2}' -f $_.Id, $(if ($_.Coche) { '[x]' } else { '[ ]' }), $_.Titre }
    return
}

# ---------------------------------------------------------------------------
# La fenêtre : un volet d'onglets à gauche, une page par étape du pack, le journal en bas.
# Tout tourne sur le thread de la fenêtre, Log appelle Rafraichir pour qu'elle reste vivante.
# ---------------------------------------------------------------------------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$Xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="windows bagarre edition" Width="1200" Height="780" MinWidth="960" MinHeight="620"
        WindowStartupLocation="CenterScreen" Background="#1B1B1F" Foreground="#E8E8E8" FontFamily="Segoe UI" FontSize="13">
  <Window.Resources>
    <Style TargetType="Button">
      <Setter Property="Background" Value="#2A2A31"/>
      <Setter Property="Foreground" Value="#F0F0F0"/>
      <Setter Property="BorderBrush" Value="#3C3C46"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="12,6"/>
      <Setter Property="Margin" Value="0,0,8,8"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="4" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
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
      <Setter Property="Margin" Value="0,0,0,10"/>
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
      <ColumnDefinition Width="230"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>
    <Grid.RowDefinitions>
      <RowDefinition Height="*"/>
      <RowDefinition Height="150"/>
    </Grid.RowDefinitions>

    <DockPanel Grid.Column="0" Grid.RowSpan="2" Background="#141416">
      <StackPanel DockPanel.Dock="Top" Margin="16,18,16,10">
        <TextBlock Text="BAGARRE" FontSize="24" FontWeight="Bold" Foreground="#F2C14E"/>
        <TextBlock Text="windows bagarre edition" Foreground="#8A8A95"/>
      </StackPanel>
      <TextBlock DockPanel.Dock="Bottom" Name="NavMachine" Margin="16,8,16,14" Foreground="#8A8A95" TextWrapping="Wrap" FontSize="11"/>
      <ListBox Name="Nav" Background="Transparent" BorderThickness="0" SelectedIndex="0">
        <ListBoxItem Content="Accueil"/>
        <ListBoxItem Content="1. Installation"/>
        <ListBoxItem Content="2. Facile"/>
        <ListBoxItem Content="3. Le script à cocher"/>
        <ListBoxItem Content="4. NVIDIA"/>
        <ListBoxItem Content="5. Dur"/>
        <ListBoxItem Content="6. Maintenance"/>
        <ListBoxItem Content="7. DNS"/>
        <ListBoxItem Content="8. Audit IA"/>
      </ListBox>
    </DockPanel>

    <Grid Grid.Column="1" Grid.Row="0" Name="Pages" Margin="20,16,20,8">

      <DockPanel Name="PageAccueil">
        <TextBlock DockPanel.Dock="Top" Text="Tu viens de réinstaller Windows 11" Style="{StaticResource Titre}"/>
        <TextBox Name="TexteAccueil"/>
      </DockPanel>

      <DockPanel Name="PageInstallation" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="1. Installation (30 min) : Windows propre, mises à jour, pilotes" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnFsutil" Content="fsutil 8dot3name set 1"/>
          <Button Name="BtnWindowsUpdate" Content="Ouvrir Windows Update"/>
          <Button Name="BtnSnappy" Content="Snappy Driver Installer Origin (winget)"/>
        </WrapPanel>
        <TextBox Name="TexteInstallation"/>
      </DockPanel>

      <DockPanel Name="PageFacile" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="2. Facile (15 min) : débloat en deux clics, DirectX, Visual C++, tes applis" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnDebloat" Content="Win11Debloat" Style="{StaticResource Principal}"/>
          <Button Name="BtnWinUtil" Content="WinUtil (Chris Titus)" Style="{StaticResource Principal}"/>
          <Button Name="BtnDirectX" Content="DirectX (winget)"/>
          <Button Name="BtnVcredist" Content="Visual C++ 2005 à 2022 (winget)"/>
        </WrapPanel>
        <Border DockPanel.Dock="Top" Background="#141416" CornerRadius="4" Padding="12" Margin="0,0,0,10">
          <StackPanel>
            <TextBlock Text="Tes applis, installées d'un coup par winget (coche, puis le bouton) :" Margin="0,0,0,6"/>
            <WrapPanel Name="ListeApplis"/>
            <Button Name="BtnApplis" Content="Installer les applis cochées" Margin="0,8,0,0" HorizontalAlignment="Left"/>
          </StackPanel>
        </Border>
        <TextBox Name="TexteFacile"/>
      </DockPanel>

      <DockPanel Name="PageOptis" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="3. Le script à cocher (10 min)" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Style="{StaticResource Intro}" Text="Les cases cochées par défaut sont sûres pour tout PC. Passe la souris sur une ligne : le Pourquoi et ce que tu perds s'affichent à droite. Tu ne comprends pas une ligne, tu ne la coches pas. Avant d'appliquer, l'état de chaque clé, service et réglage est sauvé : Tout remettre restaure. Redémarre après."/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnAppliquer" Content="Appliquer les cases cochées" Style="{StaticResource Principal}"/>
          <Button Name="BtnRestaurer" Content="Tout remettre comme avant"/>
          <Button Name="BtnDefaut" Content="Revenir aux cases par défaut"/>
          <Button Name="BtnReseau" Content="Carte réseau à la main (tuto)"/>
          <Button Name="BtnImgProtocoles" Content="Capture : protocoles"/>
          <Button Name="BtnImgAvance" Content="Capture : onglet Avancé"/>
          <Button Name="BtnJournal" Content="Ouvrir bagarre.log"/>
        </WrapPanel>
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
                <TextBlock Name="OptiTitre" FontWeight="SemiBold" FontSize="14" TextWrapping="Wrap" Text="Passe la souris sur une case."/>
                <TextBlock Name="OptiEtiquette1" Text="Pourquoi" Style="{StaticResource Etiquette}"/>
                <TextBlock Name="OptiPourquoi" TextWrapping="Wrap" Foreground="#DADADA"/>
                <TextBlock Name="OptiEtiquette2" Text="Ce que tu perds" Style="{StaticResource Etiquette}"/>
                <TextBlock Name="OptiAttention" TextWrapping="Wrap" Foreground="#DADADA"/>
              </StackPanel>
            </ScrollViewer>
          </Border>
        </Grid>
      </DockPanel>

      <DockPanel Name="PageNvidia" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="4. NVIDIA (15 min) : le pilote nu, puis l'ancien Panneau de configuration" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnNvclean" Content="NVCleanstall (winget)" Style="{StaticResource Principal}"/>
          <Button Name="BtnPanneau" Content="Panneau de configuration NVIDIA (Store)"/>
          <Button Name="BtnAfterburner" Content="MSI Afterburner + RivaTuner (winget)"/>
          <Button Name="BtnInspector" Content="NVIDIA Profile Inspector (winget)"/>
          <Button Name="BtnImgNvclean" Content="Capture : NVCleanstall"/>
          <Button Name="BtnImgPanneau" Content="Capture : Panneau NVIDIA"/>
        </WrapPanel>
        <TextBox Name="TexteNvidia"/>
      </DockPanel>

      <DockPanel Name="PageDur" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="5. Dur (20 min) : lis tout avant de toucher" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnIslc" Content="ISLC (winget)"/>
          <Button Name="BtnCompact" Content="CompactGUI (winget)"/>
          <Button Name="BtnAutoGpu" Content="AutoGpuAffinity (dépôt)"/>
          <Button Name="BtnTimerDepot" Content="TimerResolution (dépôt)"/>
        </WrapPanel>
        <TextBox Name="TexteDur"/>
      </DockPanel>

      <DockPanel Name="PageMaintenance" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="6. Maintenance : quand le PC a vécu" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnMeasure" Content="MeasureSleep (vérifier le timer)" Style="{StaticResource Principal}"/>
          <Button Name="BtnCleanmgr" Content="Nettoyage de disque (cleanmgr)"/>
          <Button Name="BtnDismAnalyse" Content="DISM : analyser WinSxS"/>
          <Button Name="BtnDismNettoyer" Content="DISM : nettoyer WinSxS"/>
          <Button Name="BtnTrim" Content="TRIM du disque système"/>
          <Button Name="BtnAutoruns" Content="Autoruns (winget)"/>
          <Button Name="BtnGeek" Content="Geek Uninstaller (winget)"/>
          <Button Name="BtnRapr" Content="DriverStore Explorer (winget)"/>
          <Button Name="BtnBleach" Content="BleachBit (winget)"/>
          <Button Name="BtnCrystal" Content="CrystalDiskInfo (winget)"/>
          <Button Name="BtnFan" Content="FanControl (winget)"/>
          <Button Name="BtnRgb" Content="OpenRGB (winget)"/>
          <Button Name="BtnDdu" Content="DDU (winget)"/>
          <Button Name="BtnCapframe" Content="CapFrameX + PresentMon (winget)"/>
        </WrapPanel>
        <TextBox Name="TexteMaintenance"/>
      </DockPanel>

      <DockPanel Name="PageDns" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="7. DNS : qui répond le plus vite depuis chez toi ?" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Style="{StaticResource Intro}" Text="Le DNS transforme un nom (youtube.com) en adresse IP. Un DNS lent ajoute quelques dizaines de ms à CHAQUE nouveau site ou serveur de jeu contacté. Le test résout 6 noms courants sur chaque serveur, 3 fois, et garde la médiane. Une trentaine de secondes, la fenêtre ne répond pas pendant ce temps."/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnDnsTester" Content="Tester les DNS" Style="{StaticResource Principal}"/>
          <Button Name="BtnDnsAppliquer" Content="Utiliser le DNS sélectionné" IsEnabled="False"/>
        </WrapPanel>
        <TextBlock DockPanel.Dock="Top" Name="DnsCarte" Foreground="#B0B0B8" Margin="0,0,0,8" TextWrapping="Wrap"/>
        <ListBox DockPanel.Dock="Top" Name="DnsListe" Background="#141416" BorderThickness="0" Height="150" FontFamily="Consolas"/>
        <TextBox Name="TexteDns" Margin="0,10,0,0"/>
      </DockPanel>

      <DockPanel Name="PageAudit" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="8. Audit IA (10 min) : une IA vérifie ton PC et trouve ce qui manque" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnCollecter" Content="1. Collecter le rapport (30 s, ne modifie rien)" Style="{StaticResource Principal}"/>
          <Button Name="BtnPrompt" Content="2. Copier le prompt d'audit"/>
          <Button Name="BtnDossierAudit" Content="Ouvrir le dossier du rapport"/>
        </WrapPanel>
        <TextBox Name="TexteAudit"/>
      </DockPanel>
    </Grid>

    <DockPanel Grid.Column="1" Grid.Row="1" Margin="20,0,20,14">
      <TextBlock DockPanel.Dock="Top" Text="Journal" Foreground="#8A8A95" Margin="0,0,0,4"/>
      <TextBox Name="Journal" FontSize="12"/>
    </DockPanel>
  </Grid>
</Window>
'@

try {
    $script:Fenetre = [Windows.Markup.XamlReader]::Parse($Xaml)
} catch {
    Add-Content -Path $LogFichier -Value "ÉCHEC fenêtre : $_"
    [Windows.MessageBox]::Show("La fenêtre n'a pas pu s'ouvrir :`n$_`n`nDétail dans $LogFichier", 'bagarre') | Out-Null
    return
}

# Tous les contrôles nommés dans $C, le journal à portée de Log
$script:C = @{}
foreach ($m in [regex]::Matches($Xaml, '(?<![:\w])Name="(\w+)"')) { $n = $m.Groups[1].Value; $C[$n] = $Fenetre.FindName($n) }
$script:Journal = $C.Journal

# ---------------------------------------------------------------------------
# Textes des onglets et navigation
# ---------------------------------------------------------------------------
$C.TexteAccueil.Text = $Textes['accueil']
$C.TexteInstallation.Text = $Textes['installation']
$C.TexteFacile.Text = $Textes['facile']
$C.TexteNvidia.Text = $Textes['nvidia']
$C.TexteDur.Text = $Textes['dur']
$C.TexteMaintenance.Text = $Textes['maintenance']
$C.TexteDns.Text = $Textes['dns']
$C.TexteAudit.Text = $Textes['audit']
$C.NavMachine.Text = "$Machine`nbagarre $Version"

$script:PagesNoms = 'Accueil', 'Installation', 'Facile', 'Optis', 'Nvidia', 'Dur', 'Maintenance', 'Dns', 'Audit'
$C.Nav.Add_SelectionChanged({
    $i = $script:C.Nav.SelectedIndex
    for ($k = 0; $k -lt $script:PagesNoms.Count; $k++) {
        $script:C["Page$($script:PagesNoms[$k])"].Visibility = if ($k -eq $i) { 'Visible' } else { 'Collapsed' }
    }
})

# ---------------------------------------------------------------------------
# Onglet 3 : une case par item du catalogue, l'explication au survol
# ---------------------------------------------------------------------------
function Opti-Montrer($titre, $pourquoi, $attention) {
    $script:C.OptiTitre.Text = $titre
    $script:C.OptiPourquoi.Text = $pourquoi
    $script:C.OptiAttention.Text = if ($attention) { $attention } else { 'Rien de notable.' }
    $script:C.OptiEtiquette2.Visibility = if ($null -eq $attention) { 'Collapsed' } else { 'Visible' }
}

$script:Cases = @{}
$script:Defauts = @{}
$groupe = ''
foreach ($it in $Items) {
    if ($it.Groupe -ne $groupe) {
        $groupe = $it.Groupe
        $tb = New-Object Windows.Controls.TextBlock
        $tb.Text = $groupe
        $tb.Style = $Fenetre.FindResource('Groupe')
        [void]$C.ListeOptis.Children.Add($tb)
    }
    $cb = New-Object Windows.Controls.CheckBox
    $cb.Content = $it.Titre
    $cb.IsChecked = [bool]$it.Coche
    $cb.Tag = $it
    $cb.Add_MouseEnter({ param($s, $e) Opti-Montrer $s.Tag.Titre $s.Tag.Pourquoi $s.Tag.Attention })
    $cb.Add_Checked({ param($s, $e) $s.Tag.Coche = $true })
    $cb.Add_Unchecked({ param($s, $e) $s.Tag.Coche = $false })
    [void]$C.ListeOptis.Children.Add($cb)
    $Cases[$it.Id] = $cb
    $Defauts[$it.Id] = [bool]$it.Coche
}

$C.BtnAppliquer.Add_Click({
    $coches = @($script:Items | Where-Object { $_.Coche })
    if ($coches.Count -eq 0) { Log 'Rien de coché.'; return }
    $q = [Windows.MessageBox]::Show("Appliquer $($coches.Count) réglages ?`n`nL'état d'avant est sauvé dans $EtatFichier, le bouton Tout remettre le restaure.", 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Appliquer-Items $coches
    [Windows.MessageBox]::Show('Terminé. Redémarre le PC pour que tout prenne effet.', 'bagarre') | Out-Null
})
$C.BtnRestaurer.Add_Click({
    if ($script:Avant.Count -eq 0) { Log 'Rien à restaurer : aucun réglage appliqué sur ce PC.'; return }
    $q = [Windows.MessageBox]::Show("Remettre les $($script:Avant.Count) réglages comme avant ?", 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Tout-Restaurer
    [Windows.MessageBox]::Show('Restauré. Redémarre le PC.', 'bagarre') | Out-Null
})
$C.BtnDefaut.Add_Click({ foreach ($id in $script:Cases.Keys) { $script:Cases[$id].IsChecked = $script:Defauts[$id] } })
$C.BtnReseau.Add_Click({ Opti-Montrer 'Carte réseau à la main' $Textes['reseau'] $null })
$C.BtnImgProtocoles.Add_Click({ Image-Ouvrir 'reseau-protocoles.png' })
$C.BtnImgAvance.Add_Click({ Image-Ouvrir 'reseau-avance.png' })
$C.BtnJournal.Add_Click({ if (Test-Path $LogFichier) { Start-Process notepad $LogFichier } else { Log 'Pas encore de journal.' } })

# ---------------------------------------------------------------------------
# Onglets 1, 2, 4, 5, 6 : des boutons qui lancent, installent ou ouvrent
# ---------------------------------------------------------------------------
$C.BtnFsutil.Add_Click({ Console-Lancer 'fsutil 8dot3name set 1' 'fsutil 8dot3name set 1; fsutil 8dot3name query' })
$C.BtnWindowsUpdate.Add_Click({ Ouvrir 'ms-settings:windowsupdate' })
$C.BtnSnappy.Add_Click({ Winget-Installer 'Snappy Driver Installer Origin' 'GlennDelahoy.SnappyDriverInstallerOrigin' })

$C.BtnDebloat.Add_Click({ Console-Lancer 'Win11Debloat' '& ([scriptblock]::Create((irm "https://debloat.raphi.re/")))' })
$C.BtnWinUtil.Add_Click({ Console-Lancer 'WinUtil (Chris Titus)' 'irm https://christitus.com/win | iex' })
$C.BtnDirectX.Add_Click({ Winget-Installer 'DirectX' 'Microsoft.DirectX' })
$C.BtnVcredist.Add_Click({
    $ids = foreach ($an in '2005', '2008', '2010', '2012', '2013', '2015+') { "Microsoft.VCRedist.$an.x86"; "Microsoft.VCRedist.$an.x64" }
    Winget-Installer 'Visual C++ 2005 à 2022' $ids
})

$script:Applis = @(
    @{ Nom = 'Steam'; Id = 'Valve.Steam'; Coche = $true }
    @{ Nom = 'Discord'; Id = 'Discord.Discord'; Coche = $true }
    @{ Nom = '7-Zip'; Id = '7zip.7zip'; Coche = $true }
    @{ Nom = 'VLC'; Id = 'VideoLAN.VLC'; Coche = $true }
    @{ Nom = 'Firefox'; Id = 'Mozilla.Firefox'; Coche = $false }
    @{ Nom = 'Brave'; Id = 'Brave.Brave'; Coche = $false }
    @{ Nom = 'Chrome'; Id = 'Google.Chrome'; Coche = $false }
    @{ Nom = 'Everything (recherche de fichiers)'; Id = 'voidtools.Everything'; Coche = $false }
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
    $ids = @($script:C.ListeApplis.Children | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })
    if ($ids.Count -eq 0) { Log 'Aucune appli cochée.'; return }
    Winget-Installer "$($ids.Count) applis" $ids
})

$C.BtnNvclean.Add_Click({ Winget-Installer 'NVCleanstall' 'TechPowerUp.NVCleanstall' })
$C.BtnPanneau.Add_Click({ Console-Lancer 'Panneau de configuration NVIDIA' 'winget install --id 9NF8H0H7WMLT --source msstore --accept-package-agreements --accept-source-agreements' })
$C.BtnAfterburner.Add_Click({ Winget-Installer 'MSI Afterburner et RivaTuner' 'Guru3D.Afterburner', 'Guru3D.RTSS' })
$C.BtnInspector.Add_Click({ Winget-Installer 'NVIDIA Profile Inspector' 'Orbmu2k.nvidiaProfileInspector' })
$C.BtnImgNvclean.Add_Click({ Image-Ouvrir 'nvcleanstall.png' })
$C.BtnImgPanneau.Add_Click({ Image-Ouvrir 'panneau-nvidia.png' })

$C.BtnIslc.Add_Click({ Winget-Installer 'ISLC' 'Wagnardsoft.ISLC' })
$C.BtnCompact.Add_Click({ Winget-Installer 'CompactGUI' 'IridiumIO.CompactGUI' })
$C.BtnAutoGpu.Add_Click({ Ouvrir 'https://github.com/valleyofdoom/AutoGpuAffinity' })
$C.BtnTimerDepot.Add_Click({ Ouvrir 'https://github.com/valleyofdoom/TimerResolution' })

$C.BtnMeasure.Add_Click({
    $exe = Outil-Obtenir 'MeasureSleep.exe'
    if ($exe) { Console-Lancer 'MeasureSleep : attendu environ 0,5 ms, Ctrl+C pour arrêter' "& '$exe'" }
})
$C.BtnCleanmgr.Add_Click({ Start-Process cleanmgr | Out-Null; Log 'console   cleanmgr' })
$C.BtnDismAnalyse.Add_Click({ Console-Lancer 'DISM : analyse de WinSxS' 'Dism /Online /Cleanup-Image /AnalyzeComponentStore' })
$C.BtnDismNettoyer.Add_Click({ Console-Lancer 'DISM : nettoyage de WinSxS (jamais /ResetBase)' 'Dism /Online /Cleanup-Image /StartComponentCleanup' })
$C.BtnTrim.Add_Click({ Console-Lancer 'TRIM du disque système' "Optimize-Volume -DriveLetter $($env:SystemDrive[0]) -ReTrim -Verbose" })
$C.BtnAutoruns.Add_Click({ Winget-Installer 'Autoruns' 'Microsoft.Sysinternals.Autoruns' })
$C.BtnGeek.Add_Click({ Winget-Installer 'Geek Uninstaller' 'GeekUninstaller.GeekUninstaller' })
$C.BtnRapr.Add_Click({ Winget-Installer 'DriverStore Explorer' 'lostindark.DriverStoreExplorer' })
$C.BtnBleach.Add_Click({ Winget-Installer 'BleachBit' 'BleachBit.BleachBit' })
$C.BtnCrystal.Add_Click({ Winget-Installer 'CrystalDiskInfo' 'CrystalDewWorld.CrystalDiskInfo' })
$C.BtnFan.Add_Click({ Winget-Installer 'FanControl' 'Rem0o.FanControl' })
$C.BtnRgb.Add_Click({ Winget-Installer 'OpenRGB' 'OpenRGB.OpenRGB' })
$C.BtnDdu.Add_Click({ Winget-Installer 'Display Driver Uninstaller' 'Wagnardsoft.DisplayDriverUninstaller' })
$C.BtnCapframe.Add_Click({ Winget-Installer 'CapFrameX et PresentMon' 'CXWorld.CapFrameX', 'Intel.PresentMon' })

# ---------------------------------------------------------------------------
# Onglet 7 : DNS
# ---------------------------------------------------------------------------
$script:DnsAdapt = $null
$script:DnsResultats = @()
$C.BtnDnsTester.Add_Click({
    $adapt = Dns-Carte
    if (-not $adapt) { Log 'Aucune carte réseau active trouvée.'; return }
    $script:DnsAdapt = $adapt
    $script:C.DnsCarte.Text = "Carte : $($adapt.Name) ($($adapt.InterfaceDescription)). DNS actuel : $((Dns-Actuels $adapt) -join ', ') (souvent ta box)."
    $script:C.DnsListe.Items.Clear()
    $script:C.BtnDnsAppliquer.IsEnabled = $false
    Log 'Test DNS en cours...'
    $script:DnsResultats = @(Dns-Mesurer $adapt)
    foreach ($r in $script:DnsResultats) { [void]$script:C.DnsListe.Items.Add(('{0,-24} {1,7} ms' -f $r.Nom, $r.Mediane)) }
    $script:C.BtnDnsAppliquer.IsEnabled = $true
    Log 'Test terminé. Sélectionne une ligne puis "Utiliser le DNS sélectionné", ou ne change rien.'
})
$C.BtnDnsAppliquer.Add_Click({
    $i = $script:C.DnsListe.SelectedIndex
    if ($i -lt 0) { Log 'Sélectionne une ligne dans la liste.'; return }
    Dns-Appliquer $script:DnsAdapt $script:DnsResultats[$i]
})

# ---------------------------------------------------------------------------
# Onglet 8 : audit IA
# ---------------------------------------------------------------------------
$script:DossierAudit = Join-Path ([Environment]::GetFolderPath('Desktop')) 'bagarre-audit'
$C.BtnCollecter.Add_Click({
    if (-not (Test-Path $script:DossierAudit)) { New-Item -Path $script:DossierAudit -ItemType Directory -Force | Out-Null }
    [IO.File]::WriteAllText((Join-Path $script:DossierAudit 'AUDIT.txt'), $Textes['audit-prompt'], (New-Object Text.UTF8Encoding $true))
    Log 'Collecte en cours, environ 30 secondes...'
    Collecter-Rapport (Join-Path $script:DossierAudit 'rapport-pc.txt')
    Ouvrir $script:DossierAudit
})
$C.BtnPrompt.Add_Click({ [Windows.Clipboard]::SetText($Textes['audit-prompt']); Log 'Prompt copié dans le presse-papiers. Colle-le dans ton IA avec rapport-pc.txt.' })
$C.BtnDossierAudit.Add_Click({ if (Test-Path $script:DossierAudit) { Ouvrir $script:DossierAudit } else { Log 'Pas encore de rapport : bouton 1 d abord.' } })

# ---------------------------------------------------------------------------
# Mode -Capture dossier : rend chaque onglet en PNG sans afficher la fenêtre ni demander l'admin (preuve visuelle en dev)
# ---------------------------------------------------------------------------
if ($Capture) {
    if (-not (Test-Path $Capture)) { New-Item -Path $Capture -ItemType Directory -Force | Out-Null }
    Log "bagarre $Version, $Machine (capture)"
    $racine = $Fenetre.Content
    $racine.Measure((New-Object Windows.Size 1200, 780))
    $racine.Arrange((New-Object Windows.Rect 0, 0, 1200, 780))
    Opti-Montrer $Items[0].Titre $Items[0].Pourquoi $Items[0].Attention   # le volet d'explication rempli, comme au survol
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) {
        $C.Nav.SelectedIndex = $k
        $racine.UpdateLayout()
        $bmp = New-Object Windows.Media.Imaging.RenderTargetBitmap 1200, 780, 96, 96, ([Windows.Media.PixelFormats]::Pbgra32)
        $bmp.Render($racine)
        $enc = New-Object Windows.Media.Imaging.PngBitmapEncoder
        $enc.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bmp))
        $fs = [IO.File]::Create((Join-Path $Capture ('{0}-{1}.png' -f $k, $PagesNoms[$k].ToLower())))
        $enc.Save($fs); $fs.Close()
    }
    Write-Host "Captures dans $Capture"
    return
}

Log "bagarre $Version, $Machine"
if ($Avant.Count -gt 0) { Log "$($Avant.Count) réglages déjà appliqués sur ce PC (bagarre-avant.json). Tout remettre les restaure." }
$Fenetre.ShowDialog() | Out-Null
