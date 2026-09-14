#Requires -Version 5.1
param([switch]$Liste, [string]$Capture, [switch]$Essai, [switch]$Vieux, [switch]$Amd, [string]$Depuis)  # -Liste : le catalogue en texte, sans rien appliquer. -Capture dossier : chaque onglet en PNG, sans fenetre. -Essai : ouvre la fenetre invisible 1,5 s et note son etat. -Vieux : force l avertissement "installation pas recente". -Amd : simule une carte AMD dediee. -Depuis : dossier du clone (pose par la relance admin).
# bagarre.ps1 : GENERE par build.ps1 a partir de src/ et textes/. Ne pas editer ce fichier, edite les sources.
# UTF-8 SANS BOM : "irm" garde le BOM dans le texte et PowerShell le prend pour une commande. Pour le lancer en local :
#   & ([scriptblock]::Create([IO.File]::ReadAllText("bagarre.ps1", [Text.Encoding]::UTF8))) -Liste

$Textes = @{}
$Textes['en'] = @{}
$Textes['en']['accueil'] = @'
This pack removes what runs for nothing and sets what matters for gaming. Fresh Windows, the steps in order, one thing at a time.
Every line says what it changes and what you lose. If you do not understand a line, do not tick it.
Everything the script changes is written to C:\ProgramData\bagarre. "Restore everything" puts exactly those values back.
@BtnRestaurerAccueil, BtnJournalAccueil, BtnCommande
'@
$Textes['en']['amd'] = @'
Your card is an AMD: the driver comes from AMD's site, Adrenalin is its panel, everything is set inside it.

## 1. The driver, from AMD's site
@BtnAmd
- Pick your card and take the latest "Recommended" driver. i@ Not the Auto-Detect tool, not Windows Update: one installs the full suite, the other an outdated driver.
- In the installer: "Minimal install". i@ The driver and Adrenalin, nothing else.
! Do not tick "Factory reset" in the installer without a reason: it wipes your Adrenalin profiles.

## 2. Adrenalin: Gaming > Global settings
- Radeon Anti-Lag: On. i@ Anti-Lag 2 per game when the game has it.
- Radeon Boost, Radeon Chill, Image Sharpening: Off. i@ They change the rendering or the FPS behind your back.
- AFMF (frame generation): never globally. i@ Per game, single-player only: in multiplayer the added latency is felt.
- Shader cache: AMD optimized. i@ A game stutters after a driver update: "Reset shader cache", once.
Leave the rest at default. i@ Enhanced Sync, FreeSync, V-Sync, texture filtering: screen by screen and game by game, never globally.
! On a Ryzen X3D, leave core parking alone: it is what keeps the game on the CCD with the cache.

## 3. What Adrenalin runs for nothing
- Record and stream: Instant Replay OFF, Desktop recording OFF.
- In-game overlay (Alt+R): OFF. i@ One overlay at a time: RivaTuner or Steam or Discord.
- Preferences: "Open on startup" OFF, "Automatic updates" set to Notify only.
@BtnAfterburner
The RivaTuner overlay (FPS, frame time) is your only way to know that a tweak changes anything.
'@
$Textes['en']['audit'] = @'
The pack is generic, your PC is not. The audit takes a snapshot of your PC and hands it to an AI with a prompt that knows what the pack did, what it refuses, and how to judge a tweak.

## 1. The report
@BtnCollecter
30 seconds, changes nothing. Writes rapport-pc.txt and AUDIT.txt into bagarre-audit on your Desktop. No account name, no password, no license key. Open it anyway before sending it.

## 2. The prompt
@BtnPrompt, BtnDossierAudit

## 3. Your AI
- Terminal agent (Claude Code, Codex, Gemini CLI): open it in the bagarre-audit folder and paste the prompt. It reads the report by itself.
- Web chat (ChatGPT, Claude.ai): paste the prompt, then attach rapport-pc.txt.
Read the answer like the rest of the pack: a proposal with no source or no downside, you do not apply. The AI does not touch your PC, you apply.
'@
$Textes['en']['audit-prompt'] = @'
You are a Windows 11 expert focused on gaming and latency, careful, who prefers one measurable tweak to ten forum tweaks.
You are auditing a PC whose state is in the file rapport-pc.txt (next to this prompt, or attached to the message).
Answer in the language of the person asking, informal, direct, no filler. If the report is missing, ask for it first.

CONTEXT: WHAT THE PACK HAS ALREADY DONE
This PC went through the "windows bagarre edition" pack (repo github.com/klNuno/windows-bagarre):
- Fresh Windows 11, Windows Update current, chipset and network drivers from the manufacturer.
- Win11Debloat (default mode) and WinUtil (Standard tweaks).
- NVIDIA card: bare driver via NVCleanstall (no NVIDIA App, MSI High, HDCP off, Ansel off, MPO off,
  signature rebuilt with the EAC compatible method). Classic Control Panel from the Store: Low Latency Mode On,
  unlimited shader cache, threaded optimization, RGB output full range. The rest at default, set per game when
  needed (power management, filtering, V-Sync, G-Sync).
  AMD card instead: driver from AMD's site in minimal install, Anti-Lag on, Boost/Chill/AFMF off, instant replay and
  the Adrenalin overlay off, the rest at default.
- Checkbox script bagarre.ps1, boxes ticked by default: useless services (telemetry, fax, demo, Edge update),
  telemetry, CEIP and error reports at minimum, Copilot/Recall/Click to Do/Widgets/Notepad and Paint AI off,
  Game DVR and PresenceWriter off, GlobalTimerResolutionRequests=1, MPO off (OverlayTestMode=5), mouse acceleration
  off, hibernation and fast startup off, USB suspend, USB3 LPM, PCIe ASPM and wake timers off, drivers excluded from
  Windows Update, Continuous Innovation declined, F8 menu, AutoRun off, ARSO off, network card (power management,
  EEE, LLDP/topology unticked, Interrupt Moderation Medium), comfort (classic right-click menu, End task in the
  taskbar, Edge without Startup Boost, File Explorer, Communications "Do nothing").
  Boxes unticked by default, to propose only with a reason specific to this PC: SvcHostSplitThreshold,
  Win32PrioritySeparation 0x26, PowerThrottlingOff, Nagle, disabledynamictick, RawMouseThrottleDuration, FTH off,
  LLMNR off, clipboard, Dynamic Lighting, NVIDIA P0, core parking, Aggressive boost (Intel only).
- DNS tested from the PC (nine resolvers), the fastest applied if the gap with the router was over 5 ms.

DO NOT PROPOSE, IT IS DECIDED
- Disabling HVCI / memory integrity, Secure Boot, Defender, the firewall, Windows Update, UAC.
- Registry cleaners, paid "optimizers", scripts that make 200 changes at once.
- BIOS settings: out of the pack's scope, only point them out.
- "Ultimate performance" plan, prefetch/superfetch, "unlocking the 20% reserved bandwidth", LargeSystemCache,
  IRQ8Priority, mouse/keyboard data queues, TcpWindowSize, page file off, HPET, TdrLevel, IPv6 off, C-states off,
  Interrupt Moderation Disabled, a timer resolution tool running in the background.
- Disabling a service you are not sure about: NvContainer, Windows Audio, Themes, Cryptographic Services,
  Windows Time, Storage Service, Device Install, WMI stay.
- A global NVIDIA or AMD setting that belongs per game (max performance, filtering, V-Sync, Smooth Motion).

YOUR MISSION, IN THIS ORDER
1. CHECK: for every point of the CONTEXT, DONE / NOT DONE / UNCERTAIN based on the report, with the report line that
   proves it. List what is missing with the script box or the pack step to redo.
2. WHAT IS WRONG: old drivers (compare the GPU and network driver dates to today), MSI missing on the GPU or the
   network card, useless startup programs, third-party services set to automatic (launchers, updaters, RGB), Store
   bloat still present, duplicate antivirus, repeated system errors (WHEA, disk, driver), drive almost full, HAGS or
   windowed optimizations inconsistent with the GPU, slow or ISP DNS.
3. TWEAKS SPECIFIC TO THIS BUILD, which the generic pack cannot know:
   - the exact CPU (E-cores / P-cores, X3D, laptop), the GPU, the network card (Realtek, Intel, Killer, Marvell)
     and what exactly to set for them;
   - the installed programs (Discord, launchers, RGB, overlays) and which ones cost in game;
   - the screen (Hz, G-Sync / FreeSync) and the consistency of V-Sync / FPS cap / low latency;
   - the RAM (sticks, advertised speed vs probable XMP): point it out only, no BIOS step.
4. FORMAT OF EVERY PROPOSAL, otherwise it is worthless:
   - What: the exact setting (registry key, command, menu), ready to apply.
   - Why: the mechanism in two sentences, not "it optimizes".
   - What you lose: the tradeoff, even a small one. "Nothing" is rarely true.
   - Source: manufacturer doc, Microsoft doc, maintained repo, with the name and the year. No video, no "people say".
   - Expected gain: measurable or not, and how to measure it (RivaTuner frame time, ping, LatencyMon).
   - Reversible: how to go back.
   Rank: DO (net gain, no risk) / TEST (one at a time, measure) / NO (placebo or harmful, say why).
5. END: the 5 most useful actions for this specific PC, in order, one line each.

RULES
- You change nothing yourself, even with terminal access. You propose, the user applies. An agent with access to the
  PC may read (registry, Get-*, powercfg /query) to clarify a point, never write.
- If the report does not allow a conclusion, say UNCERTAIN and give the command that settles it.
- No made-up FPS estimate. "A few ms of latency" only if you can say where they come from.
- Short. A tweak that needs a paragraph to justify itself is probably not a tweak.
'@
$Textes['en']['dns'] = @'
DNS turns a name (youtube.com) into an address. i@ A slow DNS adds a few tens of ms to every new site or game server contacted. Zero effect on ping once in a match.

## Test from home
@BtnDnsTester
Nine resolvers, six common names each, three times, median kept. The lines fill in as it goes, the fastest gets a frame. i@ A server unreachable on the first round does not get the other two. Cloudflare, Google and Quad9 have servers everywhere; the others mostly in Europe and North America.
@DnsListe
@BtnDnsAppliquer

## Which one to keep
A gap under 5 ms cannot be felt: if your router is within 5 ms of the best, keep it. i@ Your router relays to your ISP's DNS with a cache: fast for the sites you already visit.
The fastest is not always the right one. i@ AdGuard blocks ads, Quad9 and dns0 block malicious sites, Google keeps logs, Mullvad keeps none. A DNS that blocks domains can break a site or a launcher: if something stops loading, go back to Cloudflare or your router.
"Restore everything" also puts the previous DNS back.
'@
$Textes['en']['dur'] = @'
One thing at a time. You change, you play half an hour with RivaTuner open, you keep or you revert. i@ A tweak you cannot measure does not exist.

## 1. Priority and cores per game
@BtnThreadPilot | BtnLasso
ThreadPilot: open source, free, Windows 11 only. Per program, a priority, cores, a power plan. i@ Its rules hold as long as it runs: put it on startup. Useful on a two-CCD Ryzen or an Intel with E-cores, to keep a game on the right cores.
Process Lasso: free with a purchase reminder, paid Pro edition. The same per-program rules, plus ProBalance. i@ ProBalance lowers on its own the priority of whatever hogs the CPU in the background. Some advanced features turn off after 14 days without Pro.
If you have no stutter, you need neither.

## 2. Memory tweak: 16 GB and recent games
@BtnIslc
ISLC empties the standby list when free RAM drops under 1 GB. i@ It avoids swap stutter on a recent game with 16 GB. 32 GB and more: useless. Windows memory compression stays on.

## 3. The GPU interrupt core
@BtnAutoGpu
AutoGpuAffinity tests which core to put the GPU interrupt on and keeps the best one. i@ One hour, on an already stable PC. Redo it after a card or driver change.
'@
$Textes['en']['facile'] = @'
Two tools, each in its own console. They fetch today's version, nothing to update here.

## 1. Win11Debloat: remove what Windows installed without asking
@BtnDebloat
Default mode. Removes sponsored apps, Copilot, ads, telemetry. It asks before each group.
! OneDrive: before saying yes to its removal, check that Documents and Pictures are not "in OneDrive" (right-click > Properties > Location). Otherwise they leave with it.

## 2. Chris Titus's WinUtil: your programs in one go
@BtnWinUtil
Install tab: tick what you want, it installs everything through winget. Tweaks tab: the "Standard" preset only, the checkbox script does the rest and explains every line.

## 3. The libraries games ask for
Without them a game crashes with "VCRUNTIME140.dll not found".
@BtnVcredist, BtnDirectX

## 4. Sound, it avoids crackling
- Communications "Do nothing" (otherwise Windows lowers your volume when Discord rings): it is a box in the checkbox script, already ticked.
- Playback device > Properties > Enhancements: disable all. Advanced tab: 24 bit, 48000 Hz.
@BtnSon
'@
$Textes['en']['installation'] = @'
## Right after the first desktop
Before you install anything.
@BtnFsutil
Turns off PROGRA~1 short names on new drives. i@ Every file created cost one more write for an 8.3 name nothing uses anymore. It cannot be fixed once programs are installed.

## Windows Update
Click until there is nothing left, reboot between each batch.
@BtnWindowsUpdate

## Drivers, in order
- Chipset and network card: your motherboard (or laptop) maker's site, your exact model.
- Graphics card: not now, that is step 4.
- An exclamation mark in Device Manager = a missing driver. Last resort: Snappy, tick only what is missing.
@BtnPeripheriques, BtnSnappy
'@
$Textes['en']['maintenance'] = @'
Months after the install, once the PC has lived. One button, one sentence: you know what you are opening.

## What starts on its own
@BtnAutoruns
Autoruns lists everything that starts with Windows. Options > Hide Microsoft entries, then untick what you do not recognize. i@ Launchers, updaters, RGB suites: each one takes RAM and CPU in the background. Untick, do not delete: ticking again is enough if something is missing.

## The drive fills up
@BtnCleanmgr
Disk Cleanup, then "Clean up system files". i@ Old updates, recycle bin, temporary files, error reports.
@BtnDismNettoyer
Compacts old updates in WinSxS, several GB after a year. i@ Never /ResetBase: you would lose update uninstall.
@BtnStockage
Storage Sense cleans up on its own. i@ Monthly, recycle bin 30 days, Downloads never.
@BtnCrystal
Drive health and temperature. i@ A "Caution" or "Bad" drive gets replaced, it does not get repaired.

## The PC wakes on its own, does not sleep, crashes
@BtnReveil
lastwake says who woke it, requests what keeps it awake. i@ Often a browser with a video, or a network card allowed to wake the PC.
@BtnEvenements
Blue screens: System log, source "WHEA-Logger". i@ A WHEA error = hardware (RAM, overclock, PSU), not Windows.
@BtnWlan
Wi-Fi dropping: the Windows Wi-Fi report says when and why.

## Defender hogging while you play
@BtnDefenderEnregistrer, BtnDefenderExclusions
Start the recording, play ten minutes, press Enter in the console. The report gives the most scanned folders: the game's one goes into Exclusions. i@ Never the whole drive, never Downloads: that is where the nasty stuff comes in.
'@
$Textes['en']['nvidia'] = @'
The bare driver through NVCleanstall, then the OG Control Panel from the Store. i@ Since driver 610.47 (May 2026) the OG Control Panel is no longer in the driver. It comes from the Store and disappears with every clean install: you reinstall it afterwards.

## 1. NVCleanstall: the bare driver
@BtnNvclean, BtnImgNvclean
- "Manual", latest Game Ready driver for your card.
- Components: Display Driver, PhysX. Nothing else. i@ NVIDIA HD Audio only if your sound goes through the monitor cable. No NVIDIA App, no telemetry, no GeForce Experience.
- Installation Tweaks: tick as on the screenshot, MPO line included. i@ MPO (Multiplane Overlay) is behind the black screens, flicker and windowed stutter NVIDIA has documented since 2022. Off, Windows composes everything itself: zero effect in full screen. The checkbox script sets the same key, ticked by default.
- HDCP: on = Netflix and Disney+ in 4K in the browser, off = slight fps boost. i@ The screenshot turns it off. A game never uses it, 1080p always works. You want 4K: untick "Disable HDCP".
! Rebuild digital signature + Easy Anti-Cheat compatible method: the driver file stays intact, only the installer is re-signed. A game refuses to start: reinstall without those two boxes.
The screen flickers and red messages scroll by during the install, that is normal.

## 2. The OG Control Panel
@BtnPanneau
Manage 3D settings > Global settings:
- Low Latency Mode: On. i@ Not Ultra: Ultra sets a hidden FPS cap. Reflex takes over when a game has it.
- Shader Cache Size: Unlimited. i@ The default fills up and recompiles mid-game: stutter after a few hours of play.
- Threaded Optimization: On.
Change resolution: Output color format RGB, Output dynamic range Full. i@ Otherwise blacks can look grey: the card sends a limited range (16-235) to a screen expecting 0-255. On many screens it is already right.
Leave the rest at default. i@ Power management, texture filtering, V-Sync: set per game if a game asks for it, never globally. Globally it costs watts or sharpness for nothing.

## 3. Afterburner and RivaTuner: to see, not to overclock
@BtnAfterburner
The RivaTuner overlay (FPS, frame time) is your only way to know that a tweak changes anything. i@ One overlay at a time: RivaTuner or Steam or Discord. If the NVIDIA App got installed anyway: overlay OFF, Instant Replay OFF, "optimize automatically" OFF.
'@
$Textes['en']['reseau'] = @'
The Network card group of the script does all of this by itself. This guide is for checking, or doing it by hand.

Control Panel > Network and Sharing Center > Change adapter settings > right-click your card > Properties.

1. Configure > Power Management: untick "Allow the computer to turn off this device". Otherwise the network drops for 2 seconds after sleep.

2. Advanced tab: Energy Efficient Ethernet, Green Ethernet, Power Saving Mode set to Disabled. Interrupt Moderation set to Medium, not Disabled. The rest at default, Jumbo Frame and Receive Buffers bring nothing in games.

3. Protocols to untick: Microsoft LLDP Protocol Driver, Link-Layer Topology Discovery Responder, Link-Layer Topology Discovery Mapper I/O Driver. Keep TCP/IPv4 and IPv6.
'@
$Textes['fr'] = @{}
$Textes['fr']['accueil'] = @'
Ce pack enlève ce qui tourne pour rien et règle ce qui compte pour jouer. Windows tout frais, les étapes dans l'ordre, une chose à la fois.
Chaque ligne dit ce qu'elle change et ce que tu perds. Tu ne comprends pas une ligne, tu ne la coches pas.
Tout ce que le script modifie est noté dans C:\ProgramData\bagarre. "Tout remettre comme avant" restaure exactement ces valeurs.
@BtnRestaurerAccueil, BtnJournalAccueil, BtnCommande
'@
$Textes['fr']['amd'] = @'
Ta carte est une AMD : le pilote vient du site AMD, Adrenalin est son panneau, tout se règle dedans.

## 1. Le pilote, depuis le site AMD
@BtnAmd
- Choisis ta carte et prends le dernier pilote "Recommended". i@ Pas l'outil Auto-Detect, pas Windows Update : l'un installe la suite complète, l'autre un pilote en retard.
- Dans l'installeur : "Installation minimale". i@ Le pilote et Adrenalin, sans le reste.
! Ne coche pas "Réinitialisation d'usine" dans l'installeur sans raison : ça efface tes profils Adrenalin.

## 2. Adrenalin : Jeux > Paramètres globaux
- Radeon Anti-Lag : Activé. i@ Anti-Lag 2 par jeu quand le jeu l'a.
- Radeon Boost, Radeon Chill, Netteté de l'image : Désactivé. i@ Ils changent le rendu ou les FPS derrière ton dos.
- AFMF (génération d'images) : jamais en global. i@ Par jeu, solo seulement : en multi la latence ajoutée se sent.
- Cache de shaders : Optimisé AMD. i@ Un jeu saccade après une mise à jour du pilote : "Réinitialiser le cache de shaders", une fois.
Le reste, laisse par défaut. i@ Enhanced Sync, FreeSync, V-Sync, filtrage des textures : c'est écran par écran et jeu par jeu, jamais en global.
! Sur un Ryzen X3D, laisse le core parking : c'est lui qui garde le jeu sur le CCD avec le cache.

## 3. Ce qu'Adrenalin fait tourner pour rien
- Enregistrer et diffuser : Relecture instantanée OFF, Enregistrement du bureau OFF.
- Superposition dans le jeu (Alt+R) : OFF. i@ Un seul overlay à la fois : RivaTuner ou Steam ou Discord.
- Préférences : "Ouvrir au démarrage" OFF, "Mises à jour automatiques" sur Notifier seulement.
@BtnAfterburner
L'overlay RivaTuner (FPS, temps d'image) est ton seul moyen de savoir qu'une opti change quelque chose.
'@
$Textes['fr']['audit'] = @'
Le pack est générique, ton PC ne l'est pas. L'audit prend une photo de ton PC et la donne à une IA avec un prompt qui sait ce que le pack a fait, ce qu'il refuse, et comment juger une opti.

## 1. Le rapport
@BtnCollecter
30 secondes, ne modifie rien. Écrit rapport-pc.txt et AUDIT.txt dans bagarre-audit sur ton Bureau. Ni nom de compte, ni mot de passe, ni clé de licence. Ouvre-le quand même avant de l'envoyer.

## 2. Le prompt
@BtnPrompt, BtnDossierAudit

## 3. Ton IA
- Agent en terminal (Claude Code, Codex, Gemini CLI) : ouvre-le dans le dossier bagarre-audit et colle le prompt. Il lit le rapport tout seul.
- Chat web (ChatGPT, Claude.ai) : colle le prompt, puis joins rapport-pc.txt.
Lis la réponse comme le reste du pack : une proposition sans source ou sans contrepartie, tu ne l'appliques pas. L'IA ne touche pas à ton PC, c'est toi qui appliques.
'@
$Textes['fr']['audit-prompt'] = @'
Tu es un expert Windows 11 orienté jeu et latence, prudent, qui préfère une opti mesurable à dix optis de forum.
Tu audites un PC dont l'état est dans le fichier rapport-pc.txt (à côté de ce prompt, ou joint au message).
Réponds en français, tutoiement, ton direct, pas de blabla. Si le rapport manque, demande-le avant tout.

CONTEXTE : CE QUE LE PACK A DÉJÀ FAIT
Ce PC a suivi le pack "windows bagarre edition" (dépôt github.com/klNuno/windows-bagarre) :
- Windows 11 frais, Windows Update à jour, pilotes chipset et réseau du constructeur.
- Win11Debloat (mode par défaut) et WinUtil (tweaks Standard).
- Carte NVIDIA : pilote nu via NVCleanstall (sans NVIDIA App, MSI High, HDCP coupé, Ansel coupé, MPO coupé,
  signature reconstruite méthode compatible EAC). Panneau de configuration classique depuis le Store : faible latence
  Activé, cache de shaders illimité, optimisation threadée, sortie RGB plage complète. Le reste par défaut,
  réglé jeu par jeu si besoin (gestion de l'alimentation, filtrage, V-Sync, G-Sync).
  Carte AMD à la place : pilote du site AMD en installation minimale, Anti-Lag activé, Boost/Chill/AFMF coupés,
  relecture instantanée et overlay Adrenalin coupés, le reste par défaut.
- Script à cocher bagarre.ps1, cases cochées par défaut : services inutiles (télémétrie, fax, démo, Edge update),
  télémétrie, CEIP et rapports d'erreur au minimum, Copilot/Recall/Click to Do/Widgets/IA Bloc-notes et Paint coupés,
  Game DVR et PresenceWriter coupés, GlobalTimerResolutionRequests=1, MPO coupé (OverlayTestMode=5), accélération
  souris coupée, veille prolongée et démarrage rapide coupés, suspension USB, USB3 LPM, ASPM PCIe et minuteurs de
  réveil coupés, pilotes exclus de Windows Update, Continuous Innovation refusé, menu F8, AutoRun coupé, ARSO coupé,
  carte réseau (alimentation, EEE, LLDP/topologie décochés, Interrupt Moderation Medium), confort (menu clic droit
  classique, Fin de tâche dans la barre, Edge sans Startup Boost, Explorateur, Communications "Ne rien faire").
  Cases décochées par défaut, à proposer seulement avec une raison propre à ce PC : SvcHostSplitThreshold,
  Win32PrioritySeparation 0x26, PowerThrottlingOff, Nagle, disabledynamictick, RawMouseThrottleDuration, FTH off,
  LLMNR off, presse-papiers, Dynamic Lighting, P0 NVIDIA, core parking, boost Aggressive (Intel seulement).
- DNS testé depuis le PC (neuf résolveurs), le plus rapide appliqué si l'écart avec la box dépassait 5 ms.

NE PROPOSE PAS, C'EST DÉCIDÉ
- Désactiver HVCI / intégrité de la mémoire, Secure Boot, Defender, le pare-feu, Windows Update, l'UAC.
- Nettoyeurs de registre, "optimiseurs" payants, scripts qui font 200 changements d'un coup.
- Réglages BIOS : hors de portée du pack, signale seulement.
- Plan "Ultimate performance", prefetch/superfetch, "débrider les 20 % de bande passante", LargeSystemCache,
  IRQ8Priority, files d'attente souris/clavier, TcpWindowSize, fichier d'échange coupé, HPET, TdrLevel, IPv6 off,
  C-states off, Interrupt Moderation Disabled, outil de timer resolution en fond.
- Désactiver un service dont tu n'es pas sûr : NvContainer, Windows Audio, Themes, Cryptographic Services,
  Windows Time, Storage Service, Device Install, WMI restent.
- Un réglage NVIDIA ou AMD en global qui se règle jeu par jeu (performances max, filtrage, V-Sync, Smooth Motion).

TA MISSION, DANS CET ORDRE
1. VÉRIFICATION : pour chaque point du CONTEXTE, FAIT / PAS FAIT / INCERTAIN d'après le rapport, avec la ligne du
   rapport qui le prouve. Liste ce qui manque avec la case du script ou l'étape du pack à refaire.
2. CE QUI CLOCHE : pilotes vieux (compare la date du pilote GPU et réseau à aujourd'hui), MSI absent sur le GPU ou la
   carte réseau, programmes en démarrage automatique inutiles, services tiers en automatique (launchers, updaters,
   RGB), bloat Store encore présent, antivirus en doublon, erreurs système répétées (WHEA, disque, pilote), disque
   presque plein, HAGS ou optimisations fenêtrées incohérentes avec le GPU, DNS lent ou du FAI.
3. OPTIS PROPRES À CETTE CONFIG, que le pack générique ne peut pas connaître :
   - le CPU exact (E-cores / P-cores, X3D, portable), le GPU, la carte réseau (Realtek, Intel, Killer, Marvell)
     et ce qu'il faut régler chez eux précisément ;
   - les programmes installés (Discord, launchers, RGB, overlays) et lesquels coûtent en jeu ;
   - l'écran (Hz, G-Sync / FreeSync) et la cohérence V-Sync / cap FPS / faible latence ;
   - la RAM (barrettes, vitesse annoncée vs XMP probable) : signale seulement, pas d'étape BIOS.
4. FORMAT DE CHAQUE PROPOSITION, sinon elle ne vaut rien :
   - Quoi : le réglage exact (clé de registre, commande, menu), prêt à appliquer.
   - Pourquoi : le mécanisme en deux phrases, pas "ça optimise".
   - Ce que tu perds : la contrepartie, même petite. "Rien" est rarement vrai.
   - Source : doc constructeur, doc Microsoft, dépôt maintenu, avec le nom et l'année. Pas de vidéo, pas de "on dit".
   - Gain attendu : mesurable ou pas, et comment le mesurer (RivaTuner temps d'image, ping, LatencyMon).
   - Réversible : comment revenir en arrière.
   Classe : FAIRE (gain net, sans risque) / TESTER (une à la fois, mesurer) / NON (placebo ou nuisible, dis pourquoi).
5. FIN : les 5 actions les plus utiles pour ce PC précis, dans l'ordre, une ligne chacune.

RÈGLES
- Tu ne modifies rien toi-même, même avec accès au terminal. Tu proposes, l'utilisateur applique. Un agent avec accès
  au PC peut lire (registre, Get-*, powercfg /query) pour préciser un point, jamais écrire.
- Si le rapport ne permet pas de conclure, dis INCERTAIN et donne la commande qui tranche.
- Pas d'estimation de FPS inventée. "Quelques ms de latence" seulement si tu peux dire d'où elles viennent.
- Court. Une opti qui demande un paragraphe pour se justifier n'est probablement pas une opti.
'@
$Textes['fr']['dns'] = @'
Le DNS transforme un nom (youtube.com) en adresse. i@ Un DNS lent ajoute quelques dizaines de ms à chaque nouveau site ou serveur de jeu contacté. Zéro effet sur le ping une fois en partie.

## Tester depuis chez toi
@BtnDnsTester
Neuf résolveurs, six noms courants chacun, trois fois, médiane gardée. Les lignes se remplissent au fur et à mesure, le plus rapide est encadré. i@ Un serveur injoignable au premier tour n'a pas droit aux deux autres. Cloudflare, Google et Quad9 ont des serveurs partout ; les autres surtout en Europe et en Amérique du Nord.
@DnsListe
@BtnDnsAppliquer

## Lequel garder
Un écart sous 5 ms ne se sent pas : si ta box est à moins de 5 ms de la meilleure, garde-la. i@ Ta box relaie vers le DNS de ton FAI avec un cache : rapide pour les sites que tu visites déjà.
Le plus rapide n'est pas forcément le bon. i@ AdGuard bloque les pubs, Quad9 et dns0 les sites malveillants, Google garde des journaux, Mullvad n'en garde pas. Un DNS qui bloque des domaines peut casser un site ou un launcher : si un truc ne charge plus, reviens sur Cloudflare ou ta box.
"Tout remettre comme avant" remet aussi le DNS d'avant.
'@
$Textes['fr']['dur'] = @'
Une chose à la fois. Tu changes, tu joues une demi-heure avec RivaTuner ouvert, tu gardes ou tu remets. i@ Une opti que tu ne peux pas mesurer n'existe pas.

## 1. Priorité et cœurs par jeu
@BtnThreadPilot | BtnLasso
ThreadPilot : open source, gratuit, Windows 11 seulement. Par programme, une priorité, des cœurs, un plan d'alimentation. i@ Ses règles tiennent tant qu'il tourne : mets-le au démarrage. Utile sur un Ryzen à deux CCD ou un Intel avec des E-cores, pour garder un jeu sur les bons cœurs.
Process Lasso : gratuit avec un rappel d'achat, version Pro payante. Les mêmes règles par programme, plus ProBalance. i@ ProBalance baisse tout seul la priorité de ce qui pompe le CPU en fond. Certaines fonctions avancées se coupent après 14 jours sans la Pro.
Si tu n'as pas de saccades, tu n'as besoin d'aucun des deux.

## 2. Opti mémoire : 16 Go et des jeux récents
@BtnIslc
ISLC vide la liste d'attente quand la RAM libre passe sous 1 Go. i@ Ça évite les saccades de swap sur un jeu récent avec 16 Go. 32 Go et plus : inutile. La compression mémoire de Windows reste activée.

## 3. Le cœur de l'interruption GPU
@BtnAutoGpu
AutoGpuAffinity teste sur quel cœur poser l'interruption GPU et garde le meilleur. i@ Une heure, sur un PC déjà stable. À refaire après un changement de carte ou de pilote.
'@
$Textes['fr']['facile'] = @'
Deux outils, chacun dans sa console. Ils téléchargent la version du jour, rien à mettre à jour ici.

## 1. Win11Debloat : enlever ce que Windows a installé sans demander
@BtnDebloat
Mode par défaut. Retire les applis sponsorisées, Copilot, les pubs, la télémétrie. Il demande avant chaque groupe.
! OneDrive : avant de dire oui à sa désinstallation, vérifie que Documents et Images ne sont pas "dans OneDrive" (clic droit > Propriétés > Emplacement). Sinon ils partent avec.

## 2. WinUtil de Chris Titus : tes programmes d'un coup
@BtnWinUtil
Onglet Install : coche ce que tu veux, il installe tout via winget. Onglet Tweaks : preset "Standard" seulement, le script à cocher fait le reste en expliquant chaque ligne.

## 3. Les librairies que les jeux réclament
Sans elles un jeu plante avec "VCRUNTIME140.dll introuvable".
@BtnVcredist, BtnDirectX

## 4. Son, ça évite les crépitements
- Communications "Ne rien faire" (sinon Windows baisse ton son quand Discord sonne) : c'est une case du script à cocher, déjà cochée.
- Périphérique de lecture > Propriétés > Améliorations : tout désactiver. Onglet Avancé : 24 bits, 48000 Hz.
@BtnSon
'@
$Textes['fr']['installation'] = @'
## Juste après le premier bureau
Avant d'installer quoi que ce soit.
@BtnFsutil
Coupe les noms courts PROGRA~1 sur les disques neufs. i@ Chaque fichier créé coûtait une écriture de plus pour un nom 8.3 dont plus rien ne se sert. Ça ne se rattrape pas une fois les programmes installés.

## Windows Update
Tu cliques jusqu'à ce qu'il n'y ait plus rien, redémarre entre chaque série.
@BtnWindowsUpdate

## Pilotes, dans l'ordre
- Chipset et carte réseau : site du fabricant de ta carte mère (ou du portable), ton modèle exact.
- Carte graphique : pas maintenant, c'est l'étape 4.
- Un point d'exclamation dans le Gestionnaire de périphériques = un pilote qui manque. Dernier recours : Snappy, ne coche que ce qui manque.
@BtnPeripheriques, BtnSnappy
'@
$Textes['fr']['maintenance'] = @'
Des mois après l'installation, quand le PC a vécu. Un bouton, une phrase : tu sais ce que tu ouvres.

## Ce qui se lance tout seul
@BtnAutoruns
Autoruns liste tout ce qui démarre avec Windows. Options > Hide Microsoft entries, puis décoche ce que tu ne reconnais pas. i@ Launchers, updaters, suites RGB : chacun prend de la RAM et du CPU en fond. Décoche, ne supprime pas : recocher suffit si un truc manque.

## Le disque se remplit
@BtnCleanmgr
Nettoyage de disque, puis "Nettoyer les fichiers système". i@ Anciennes mises à jour, corbeille, fichiers temporaires, rapports d'erreur.
@BtnDismNettoyer
Compacte les vieilles mises à jour dans WinSxS, plusieurs Go après un an. i@ Jamais /ResetBase : tu perdrais la désinstallation des mises à jour.
@BtnStockage
L'Assistant de stockage fait le ménage tout seul. i@ Tous les mois, corbeille 30 jours, Téléchargements jamais.
@BtnCrystal
Santé et température des disques. i@ Un disque "Prudence" ou "Mauvais" se remplace, il ne se répare pas.

## Le PC se réveille tout seul, ne dort pas, plante
@BtnReveil
lastwake dit qui l'a réveillé, requests ce qui l'empêche de dormir. i@ Souvent un navigateur avec une vidéo, ou une carte réseau autorisée à réveiller le PC.
@BtnEvenements
Écrans bleus : journal Système, source "WHEA-Logger". i@ Une erreur WHEA = matériel (RAM, overclock, alim), pas Windows.
@BtnWlan
Wi-Fi qui décroche : le rapport Wi-Fi de Windows dit quand et pourquoi.

## Defender qui pompe en jeu
@BtnDefenderEnregistrer, BtnDefenderExclusions
Tu lances l'enregistrement, tu joues dix minutes, Entrée dans la console. Le rapport donne les dossiers les plus scannés : celui du jeu va dans Exclusions. i@ Jamais tout le disque, jamais Téléchargements : c'est par là que les saletés arrivent.
'@
$Textes['fr']['nvidia'] = @'
Le pilote nu par NVCleanstall, puis le Panneau de configuration OG depuis le Store. i@ Depuis le pilote 610.47 (mai 2026) le Panneau OG n'est plus dans le pilote. Il vient du Store et disparaît à chaque installation propre : tu le réinstalles après.

## 1. NVCleanstall : le pilote nu
@BtnNvclean, BtnImgNvclean
- "Manual", dernier pilote Game Ready pour ta carte.
- Composants : Display Driver, PhysX. Rien d'autre. i@ NVIDIA HD Audio seulement si ton son sort par le câble de l'écran. Pas de NVIDIA App, pas de télémétrie, pas de GeForce Experience.
- Installation Tweaks : coche comme sur la capture, ligne MPO comprise. i@ Le MPO (Multiplane Overlay) est derrière les écrans noirs, scintillements et saccades en fenêtré que NVIDIA documente depuis 2022. Coupé, Windows compose tout lui-même : zéro effet en plein écran. Le script à cocher pose la même clé, la case est cochée d'office.
- HDCP : activé = Netflix et Disney+ en 4K dans le navigateur, désactivé = léger boost de fps. i@ La capture le coupe. Un jeu ne s'en sert jamais, la 1080p passe toujours. Tu veux le 4K : décoche "Disable HDCP".
! Rebuild digital signature + méthode compatible Easy Anti-Cheat : le fichier du pilote reste intact, seul l'installeur est re-signé. Un jeu refuse de se lancer : réinstalle sans ces deux cases.
L'écran clignote et des messages rouges passent pendant l'installation, c'est normal.

## 2. Le Panneau de configuration OG
@BtnPanneau
Gérer les paramètres 3D > Paramètres globaux :
- Mode de faible latence : Activé. i@ Pas Ultra : Ultra pose un cap de FPS caché. Reflex prend le dessus quand un jeu l'a.
- Taille du cache de shaders : Illimitée. i@ Le défaut sature et recompile en pleine partie : saccades après quelques heures de jeu.
- Optimisation threadée : Activé.
Modifier la résolution : Format de couleur de sortie RGB, Plage dynamique de sortie Complète. i@ Sinon les noirs peuvent être gris : la carte envoie une plage limitée (16-235) à un écran qui attend du 0-255. Sur beaucoup d'écrans c'est déjà bon.
Le reste, laisse par défaut. i@ Gestion de l'alimentation, filtrage des textures, V-Sync : ça se règle jeu par jeu si un jeu le demande, jamais en global. En global ça coûte des watts ou de la netteté pour rien.

## 3. Afterburner et RivaTuner : pour voir, pas pour overclocker
@BtnAfterburner
L'overlay RivaTuner (FPS, temps d'image) est ton seul moyen de savoir qu'une opti change quelque chose. i@ Un seul overlay à la fois : RivaTuner ou Steam ou Discord. Si la NVIDIA App s'est installée quand même : overlay OFF, Instant Replay OFF, "optimiser automatiquement" OFF.
'@
$Textes['fr']['reseau'] = @'
Le groupe Carte réseau du script fait tout ça tout seul. Ce tuto sert à vérifier, ou à le faire à la main.

Panneau de configuration > Centre réseau > Modifier les paramètres de la carte > clic droit sur ta carte > Propriétés.

1. Configurer > Gestion de l'alimentation : décoche "Autoriser l'ordinateur à éteindre ce périphérique". Sinon le réseau lâche 2 secondes après une veille.

2. Onglet Avancé : Energy Efficient Ethernet, Green Ethernet, Power Saving Mode sur Désactivé. Interrupt Moderation sur Medium, pas Désactivé. Le reste par défaut, Jumbo Frame et Receive Buffers n'apportent rien en jeu.

3. Protocoles à décocher : pilote LLDP Microsoft, répondeur de découverte de topologie, pilote E/S de mappage de topologie. On garde TCP/IPv4 et IPv6.
'@
$Logos = @{}
$Logos['adguard'] = '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'
$Logos['bitsum'] = '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'
$Logos['christitus'] = 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAABNhSURBVFhHbZh5VFvXnccfoOVpA4PZBQLtOxIIEEJIQkJsBm+AAa8YY/BKvMRLjO3YsZ3FW7w7tmOniZ3FiWs7W5O47TTuftqZ9LRNJ21n2rRpmjntmUo9M+2c+fMz5z2cpnNm/vied9/TOfd99P0t974raBr7f6WKrsjktW/KFIyeyMxdcTqjTG7JaMLLMrpAX0bt7czoXenMXEcqU+Roz+hdiYzKlcjo3OlMcWB+RvR1ZER3ImPwxjNF7lim3BvP1AR6MjWBvoze1JoxOCIZnSOa0TmTGYO3NyM60xmNuz2jcUUyOl8ko3HFMhpnLKN1tM3Klcho3cmMwtGe0fq6fy0YO1f9pWLBFspGDuHe9iLe7S9ROH8P2sgytME+1P5u9N4uCt2dFLrT6HwdKDwp1K4UBd5eChsXI7qSFHhiVPijtPYNsuvx4zz72l0mHt7DHFcYvSOKwd2BwTcP0dmJ1pNG64mR72vD4Emid7f/TdK91p1E7WyX3vtXQdPQl9FERtGmN1IyfIiKkSNo29cjhgbRB+eh9kuTpcl3p9F7OlH50uR421E4YojmKCX+XoyBburi/TTF2/GHfMSTjSwaiLP/8DYGJzeiNQcpcMcxeLsQnWk0zjQ6Z5x8d4J8CcSRQO+UNDvWORIYXEkMzmRWUAd7M2LzIKqW5Siia1C1TSCGl6NtWIS2rhu1vwONN43O04Xo7SbX20GOO4pob6bAVEdrWy+xaAf2qmr8NaUkg2a6GkzUG3NpthcwvGIp5voWdLUB5riTiI4UGmcHWls7+Y52DPYEOnsSja0djS2JaE1Q4Eox191BvrU1K6j93Rmxvh+xYRHq0BBiaAna+sXo6/rQ+btQ+doRPR1o3d2o3N2oA53MaUhQ7m3A6/Gxel6cR1cv4vz2cd4+PsOPrp/hl7eucu/oPk6uXcquTRMsGR5irsmBvrYBjS2Gzp5CZ0lisLWjsyXQ2lNoHJ2o7Wl07i4KvV3MsScoskaygtrbkRH93Wh83Wj9vWh9PWi93WjdnWjcKdTedjQPAEV3N4a6FDVNUZxOG+sXp7m5f5xvn93Bh889xscvneCzW8/w16/e5r+/8S6/u32Tn9+7xdsvXuLgo/uxBCKINQ3kO5MUOFKyRFsCg68XQ2Ah+aFBChoGEG3tGGxR5trCWUHpTmbUUtK62tG7EhjkZE2id6XQulNovEl0njR6Zw96Vxf5zhaq7XZWzYvy4p41vHNwkg/O7ebnzz3Gb18+yh9fv8i/f+VL/Of9u2S/cYf/+v6b/PnH9/ng/j1WTWxAY3STb4+it8Yx2BKzcwcXYO7bTM28aVSBRSgcSQpcbRjM9VlB7UpmNJ4UOlccg6uNfOkHZ1xOWJ0zhd6dQufunAW0JynzNDG0uI+T0yO8tnMp3z2xi4+uHeVXN07w2e1z/PHdK3x27yr/dv8Gf/ruq/zHP7xI9pu3+f0P3+fA3r1UOOsx2MNorK1yYYieNKJ/HuWpceZEV5Ln7UPpTKJ3RjHYQllB505mNM52NBKUux2dK4HOJV0lR9spcqTQOTtRuNPkWepJ9HZy8KGVXNq2lG8c284H5/fy4aWDfPzCCT69eZ7f37nCZ+88z++/doNPvnqdj+9e5tM7l/nz+3f54Zu3CMVT5FqD5LljiM42NI4Y+d4U+b4O9F6pgBLyM60zhtbRmhX07lRGCqXoiMs/in8nrSNOgVVK4jS5rnZEe5D+wXk8tW0lrx5cz/fPP8pPrx7hNy+f4pOb5/ndzYt8+uVn+fSN5/nsvZf5w/tf5pP3bvDJ3cv84e3r/OZb77Fqcj1CjR+FO47WFUdjj6JzxtDLQFG09gdyxhEd0awgOuIZg68Tg7cDtT0mg34ujSNOvlWaJIXCKZV/PYsHejmze4LXj0xzZ+8UN/dMcmtmih9eOsJvb13md7ev8cmd5/nkjev89u0X+dP33uDP92/yi5fP8tO3bvLE0eMY3GFUjigFriR6Rxy9Q6rsNhlMY2udlb0N0SZVsT2W0UghlQrDk5KLRbZZctCZkBNZK1Wbs41yTz0TKxbz7N5JnplayKWpxZzbMMLMojgXJof4ztkD/PjZ43z/7BFe3bGex4d7ubJznH+89ji/u3uZ71w/z/atWynxRlBbI/Kf18tgregcUVkaW2RW9lZEW4sEGM/IIX0QYglUDvUDB7V2yc0EGmuYaqeXdUv7ubx9OedWdXFqWRcnJ5ZwYnyAAwtj3Nmzjl++cIp7B7dxeF6CC+NLuPHoRl7evZpvHtvBd649zaLeboocDYjmFvTmGFpLC1rbrDSW8BdjawuipelzwPYvwvoAUnLyc0jREUNvCWF1uJke7uHGrlUcXdzCgZ4mdnZFObpsAZcmB3lr7ySf3brAz648waklXUxHfEy2eTm0MMIbu8b44PnTDPR0Umitkx3SWePoJLcsTWgszeisYTTmJlmipRm1+f8BlCQt1p87qZYhY1JPwuf2sn1JF28cXMednSt4a2Ydd/Zs5d7hR/jB6Ud5d+84/3x5Px89e4gXN45yaEGca1vGeHl6hHd3r+a7F46wfuUIc2x+FJYwGnsCraWZfLukMFpLCK35gayNaCyN/z+g5JhGWrSltVOuphiG2gYa6oLsXdrDm/vG+acze/jw6nF+duUMv7h6ih+ceIR7M+N89Mx+fnJhPz+9cIhvHZvhW2cO868vnOS3zz3F984fYtvalRRafeTUNqOyx9FZW9Bbm9Bbm9FbmtCaG9FZmjDYwtKzrKB2tGXUrjhqZ5tcCJK0jllJ1ZXvjKGyJVDVhknFk1zdNsrX943yk0uH+Ojm83zy4jP86NR+bm8f481H1vLZqxf51XPH+faBLfzgiT38yyvX+OObL/DxjWPcP7OXfetWU2xyklvbSJ7sYASdOfxALfJVb4lgsLaiNTdnBY07nhE9CRlQ7Wj934D2KPlS0/R0klfbQkeqiy/tGuMru5bw3RO7uX/2OG/s3sCXJgZ4YkGcQ/OjXJ0c4tRgmlemRnl22QJe37eNX798ng/OzfCtCwc4unsLJdV2VNYmFFIrkaG+kAQmXfWWVmksASYyWm87oiuG2hFFJZf3rLS2VlRSRfm70LoT2L1Bzu6Y4NaOZby4aSkH53cy09PKubFFHB3p4aF4HRtb3GyPBXht2wTX169ka5uf27tW87UjG3n/0mH2TW+goNyCztaEytKMxhxGW/uFa9JVuteZI9I4K4iueEbjaUfjjstS/x2gxhpBZY+gcCVQOdsoMrmYXjbEKzMbObdiPtNhHzu7Wzk41MNTKxZwcmyAGzvW8eqezVzdsIpzq4fY0e7n8PwmubBuHd9HZzxOvtGJpiaIxtKApqYRba3kmAyEpqb5b4BiTdMXDsqArpi8/EjhlZcgqbM7WlE6o3Ln11b76Ono5uzOaa5sWMHRgRRrIz66a8o4MbaEd57cz9dPHuaFbetYWWejv2oOW+IuLk7289K+DRzZso7qWic6Ux2a2np0NQG0NU1/g5sFexBu6d4cnnVQdEtr7xdFIrkndXppxyE3TFsEteRqbQiTM8TuDes5OTXKxTX9XN68klNrhjg/McLbB3fxndOP8/Wn9nNsdD6XppZxZk0f17Yv48KudQz09KCrdKMyh+W58msDGKRGXRuWnZMg/w+gSq7iGCpHq5x/siwtKKVJpGStnc0RtaVFfq6u9NPRnuapTcu5vm2UO/uneWXnel6aXsPllQNcGx/h5vQa7u7axDeenOHLj05x4aFRdq4axGRyoKppRrDE5fkNlnoZUFMjAc7m4edjTW14NsQqe1tG5YyhtLeitEk514pSyj0JRvp31SH0NWHUNRFyzFEU5jAlJgcPjfZxZfMgr81McXtmM6/v3MDrW6a4Oz3JWzs28pWZLbx/bB+3H9vEk5ODtHpsFFbYUFnbEMxxFFJYrVLfk5yTikNysglNzQN9DqiwJjIKexKFLYbCFiXP2kKeLYxCVhNKSxDRHEZt7kCwdiFITd3iZ3heL0+ODXHmoSXcOryZe0d286PTx/jw/Gm+d/JJ3jt2gNeffISn1y9noK2FslITBpMXsTaI3hFG64iglNyTW0oYrbke0eRFa66Tx9JzdW1LVtC40hmtpxut9N3hSf6tmjWeGKKnDbU/guiR9mdJRHcShSNEocvJ6iUL2TvazyOjSU5vHeWlg1v52uknuX/hFO+cfpKr+7exY7iXpeE6Rrrm4QimUFQ3oqoNycumrtqP3tww61xNA6LJj7bWi87sQ2euQyctd5KDamd7RnR3yB/foishu6iwRWTl2SMInggKZxiVyYuqohqjx0a6J8LM+mEOruxjui/MVE8jq7qaGU2HGemK0N8aoCNgpd1RybJGD2cPPcH+ky9RFVuNwtGFUB6koLqOIsnNmkZEUz0akx99rR9djRd9jZd8Ux2GqrqsoLK1ZZSOOCqHVCizYVbYWlFYJcAogtS8bSFKrA4GB3p4YmaSp3et4uz2pZycXMSh4W7WxIO0OSuonJOHJldgjlLAUaRloMHN44Mprh05zMyxG3iHDuAZfZyK+ARFvnloqiPkltWjrArJVa021aGTQKvdFFZ7KTS6soLSHpWL5HNASWrnLLDSHsPgTKExBUikO7lz7QwvH5nmhYeX8sK2pTwzNcC5lQPsXdDJaFs9AdNcyrVKHHMNLGwIcGhkEdfW9nNp5mH6l27DvGAv7vEL+MbOEBp7mrqhAzg7p8j3dqGoiSCYGsmrDsr9Mb/KQ2GFIyuonK0Z0R2XlzqVo41cixTemPxNXBTso6puHspiB/nFpRzcvp43ju3h7sw6XtkxxpVNw1yeHOXYssVsn59mVTJCb8DD/DovO/v7Ob92jBu7JphaspiaUD/WwQNYVpzGOHgU29IzBNdcIr7uNK1rHicwspeqzkk0vh5yjQ3oqwLMqfRIjVpqM61y1crfCYEuqtqWYIovozI8iMHUgpBvQtDosdiqeWb/w9w7+Riv7NvIlV1jnN+8lGPjA+xYkGYs2sRQ0M/mrhQn16zk8tZNTAwOUlpbR3HLCOYlB6gdPox56DHMg0cwLTyEsW8v5sFD+Mefpmn9GRrHH6e0eQhlZQh9ZTAr5NnCGYUzSmm4D1t6Oc7uMUyxEflESzA2IxS6EYqtCMUVCGo1DlMVT02v4/bZI1w/sZuLeya4sHOcc1vXMDM8n0dHB3np4D5uPnGQyf5etEVWDHX9lHc/hGXkEI6RA1gX7aKmdxumebsx9h+gfMFjGIeOYF9xnPqJp4mvfYrK5iFyS4JZQelNZyoTK3DN24C1Y4LS0IC8080zNSBUeBGKPQhzHQiFtQgFRoQcHXPyixlePMjFEye4feE4b104yrdvXOT+9Yt89foVnjl+lI5kGjG/EsEYpji6ksrOjdQu2E3Ngkeo7ttBWXozVT1bqO7ZjqlvF6aFe6nsn6Fm4QyBkccIDjyC6OzNChWJ5Rlz11qKm0coqFuEXjokqm0ltypATrkbocyLUDILmVtoQVVYQ562FEFRQHm5lY5IOysWLmbd6ChrhofoTqWZU2JCEEvJLa9D7ezEUD9IZWqKsvQmSju3UNm7nfKuLRi7H6KqYzPlyU0Ut2+kKL6RgtYpjB0bqe3YgDk5kRXKWocyBcH58pmdaO+Qj8HyTE0IpW6EEic5FX5yy/3klftRlnlRlrpQFztQF9nI0VYjqKsRcksQlCUIeUUIYjlCkROhvIEcs9S2UsxpGKIsNk55agNz2zdS1budqp6tGNObKY1PUhyfwhAeIz88hiY4QkV0NcWhJRgjI1mhMNCbUdsS5FQ3k2dqQWFqJs9Yj1DsJrfMh8IYQGkMPlA9yoogqsp6lGUBlGUN5FaGESpC5JTWoaqoJ7ekjtyKEHmmNnJq4qhtHZQ0DVMRG6csMUlh2xSmnu1Ud2+hon0dZfFJ+ZrfuBSNbxEaZy8GzzxES5J8V0dWEC3RjLq2hdzKILmVUlj9KCoDCKVeciWYqgYU1fXkGuvJrWxAYWxEWR0mr7IZoSxETkUjORUhcsuDKCvqUZUHUVc1oTQ2oa5uocDTRXH9YkpbllMcWc3c6FqMHZtlqLmR1ZS0raG4ZRUFwUEM7l4UVREUlU2ojY0YpB21qqIhI+1ehRKXnHOS8ip85JT5ZUBFVYi8qgZZMqD08qom8iqbUFSEUFeHUFc1oK4MoiqvQ1XqR10WQCwPojeFMdils+x5FDUsobBxGcWt45THJylvm6CibUK+z68fpsDXR5G7k7wSPzn5NsQyP1pjMCso5vr+oqluRJhrI6fMTk65g9xyD4rKevIqQ+RUNZJb3UheVaO82KtNTSjK61GUBdFUNaKtDiJWBVBWBskrC5JbGkA0NqOtCqMzRTDYkhT6+igODVPUtJySyBqMifVUxNZSGVtLaXQCQ2CIOb5e5rqSqOY6EcRK1EV21MXOvwqCwfZxTqE9Kxiqs0JRTTan1JoVSpxZZUUwm1cRygqVoWyOMZRVGBuzSmNDNrfUm1WV1WXF8rqsstSTzSt1ZnNK3dmcUl9WKAlkc8ubsnkVLdm8inBWXdWa1Znj2Tnu7uzcwEC2sGE0W9a6JlsaGc8WN63IlkfGssXhVVmdb1FWyjd9TWNWNceaFVRl2VxNZTbXUPvx/wDVBsq3XGXBOAAAAABJRU5ErkJggg=='
$Logos['cloudflare'] = 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAVZSURBVFhH7ZhdaBxVFMdvmo+dmaVgBeuTL4L4JIgviog23TRpkt2Z2XxZP6gPggHRKlbE2o9YiqkUKlQFtdRqLcbSF6UlNS1qVNI29FP7ZS2WFvWhEdKiTXZ3duaev5w7M+lkd5OWdDEL9sKfmb333Ht/99xzz7BXCCEEdQidLL3bs/WjZOuXZ0uuqf1BbcYH2ZZYPXNNlLypbUGXAXQYQNssqysOmdbHXEtPKbisGWuQbfq4arQrRF0GPFM7Tk/fGRfS0tcxdZHRbCptgGwjB1t7RJClvYPOCgRMGy61xxKCLH1jRQLaRp7aYvW3AGek/y9gazWwSAANAmgUgKmpyYrsrqeyAlo60CRACwWoaz7otQRoZQvw4oOglhqA6xm8sN90KgtgOg4kayAbBWj5Y6CBT4GLp0D5DIhc4Opl4PSPoL71oM75QEIUjzGVygKYrAXMuZCfrQX9M4qJQg5AOQDutaqzh0Gv1oOahO/xwrEKddOAZkzFGn25KUCQgDteWl7GN7kyAlq+AMQxWjheoWYEuFj4B4C90CBA69oBmQfgFUOVEi/j3FEVp2itKR5/xoBmHWRCQHbfD/lWJ2jZQ0D7HcD5475nCkGmUuBJ+vAVdXCmPd03DJiqg0zF4fX1gi6PgHiGsVHg3DDgXAW8bDHIdGLAXw9BpuYCC4IdSdUVz3vDgIsEvPdf9j2l9igS/OyRQoDriWN15ALojVZQTwfk603w2m8Hcd7kuObMcMOAnGRba0E/D/pAhZPNRFz2bQXt3OC/O2OgU0PAmybQXANKBrE5LSCvIlUH4rzVNAf480x5AD32PkFuXgE6stcfE3zI/MIZQZq6v+VTAnJDSxXQUgPqsUH9W4C/RwDpRCbL+LGnFLzLqHJ+HgylwsJTEN5gH5wldwMXT/tU3MZjkA8qt63xt7utFGA6rhKpu/QeyKGvADdYHQ/ijl0DVKvmCf1JVUyq5MzK+8B8gHghajE5YOwK5O6PkGm7jbKPCpJfrAccPmB8sr0gsUvQlUuQ3fcBrVUlAJO1kNY8eAd2BxPnC7aIV+pAHtwFb+tqeNvXwduxAd62tXA/Xh1oDdzNK+Bteh7ofRxYvwT09hPIP/sAMvWCMs2CMosEZVvikKtaId99QfWnkz9MHD75ySr/227pBYCc63qfinitVBxlQJd+A50dBp0ZAp0eAv1yAHRmP+jEd6ATg6CT36snjvYDx/YAP+1Vi8mm51FmoSBn6b3wdm4Eju+d6IO/Lvie51g81A80zwFZWgSwQwcaq0Dffh7sWgm4SVvMGZElIyqsm1zyKy04HXcBF09EalVm9cODw4h7sjebqosB3cZqyPPHIp3LW/K9z0AO7iisLirekX2ghqoooKEAZXM1aFsPvOEBePt3lU8H+yG/6YN86WHIr7fCO7in2CbU8ADovWWgxbzFHIPxazFIFnuxChwn5dT4QkG5hCAvWUtuUzWcRBWyJexCOY2CYOsgi09xBFBa6t88nFQdZZLllZuKwU1p8FhmDNkSNqHy/AWzJgHyFjOcrpRPaZSJaDyiaH2obEqjnKnDSWnk8NPUEbapupRG4djh+PnQPuiTC965nm1KepC3mBtdHiSQ6mhOFk/ANoHU5GzLHuK6cAwlrovUT9emPBwCTvWpI0s1qKf03Rz89t9DG25jgdsDTdiHYttQpexsQ317Weo9GFPNMxVgxegW4M1qMmCFXr/Zhqeu3zxb66nQC0xXXWA6Se1JdTc93b+s/1qdKnPsQ1IYAp2iLm/GtnNlpVyiU1q/SlYsMXHLT4tFDLbxnGcbh8nSR2dFaX2UbON3atcHonD/AsNCW8rpOz1wAAAAAElFTkSuQmCC'
$Logos['controld'] = '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'
$Logos['crystaldiskinfo'] = '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'
$Logos['dns0'] = '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'
$Logos['drapeau-en'] = 'iVBORw0KGgoAAAANSUhEUgAAAEgAAAAwCAYAAACynDzrAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAANOSURBVGhD7Zq/axRBFMfH/0A7rcRC7LTSxiqChdpY2AgWahexUEGtBDtTBCIeGFBEIrFRkCsC4o/CQoi/tfBAFIN4xuCpnBfNXbwzjryDGWd3Z3Z23r6ZbebBN+TH7Mzc530SkkfY0d2n+KPVm4d5vfMA776d42q1O11+6OQUX7VhlCQj+yf42fMzw1w4VuPTe49bA+vEM/B8ek9sdh2s8YVWJ/F6+1++8jf7RiUT9nTjiPwA8mTtVj4/cSXxENTtBw2+btvpzCGugRcpqnnuYuJsU2CdKHg+vadr1mw5wa/enJV7impdr/Nn67cnzmbPN+3IXAjiy6aqARWxRg3782ORvz9yJvMFiA+bqgLkYo0ISMLEwvb9hzyETVUAcrVGFUMCggphU0hAWGtUGZhuA582hQJUxhq1mGkzXzb5BkRhDZRo+hBQ3sbUNvkEpGs0xhq10RJQ3iGUNvkAZGou1hp17wygvAMpbKIGpGtoWWusgPIOL2sTFSBTEymsKQwo7yJYmygA6RpHaY0TIBHdpTA2vfvQku9jAL1sNOX7oqitUVMYEITKJlEYQGr5skaNEyARKpvKAPJpjRqmzmdcMjZ5R6t7b+4j/1yb4p/GJjNpXbvFV7o9uRYD6G+/z7/dmMnsDZkfv8QXZ1/ItaLg23r88r3MaygSBm+qKgyg0BUBWYrBOBMuUEUaew5nYOgC69LPhgqDmW/6QjH/EwFZEgFZEgFZEgFZEgFZEgFZEgFZEgFZEn+TtiT+LWapCMhS6HkQZLr+mP9cWk5suPJrKXde87u5INdiAA3andx50+B7W66F6i0PeP3uq8zdiwY1UTSNXl2nfBhAUJjppeuoVcQZkG7cipkNQ2EBiXKdhWPGroUBUVkDyovCAEp/S/u2qRAgKmvgYjAbFoUBBLNwXaN82ZQLiMoa9TLwg08UBhA8D/vomubDJiMg3QWw1qgXoAIEMTWQ0qYMINOhZaxRQwlIRNdMKpsSgHQHUVjjGxDE1NiyNg0BmTansiYEIBFdk8vYxHQbUlsTEhDE1HCMTYn/coXyYY2aEIBEdM13tUkC8mmNmpCAIGVtGgLybY2a0IBEsDaxENaoqQoQBGMTAxDpT1Jbo6ZKQCIuNv0D76xzXBJnmLUAAAAASUVORK5CYII='
$Logos['drapeau-fr'] = 'iVBORw0KGgoAAAANSUhEUgAAAEgAAAAwCAYAAACynDzrAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACLSURBVGhD7dAxEYBAEATBN4UAROAQf0iA/JNJuKy3qgXsrHXd76TpPecxau2H/ja9/dDfBAoCBYGCQEGgIFAQKAgUBAoCBYGCQEGgIFAQKAgUBAoCBYGCQEGgIFAQKAgUBAoCBYGCQEGgIFAQKAgUBAoCBYGCQEGgIFAQKAgUBAoCBYGCQEGgIFD4AO3KjiyUFE3SAAAAAElFTkSuQmCC'
$Logos['google'] = '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'
$Logos['microsoft'] = 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAK3SURBVFhH7ZZNTxNRGIVPVEgIJmykbEygA7QNW4QOhp3y4UJpQXYujCv/BJQWFv4FE6PSDvVrpRuZmZYCCXHDwoX/wZhAh+nQ0jp4X3OnE1q0i96uhmQmeTKrk/v03ElzgKvw/Foeu2k+GoqaDwdl5y1IOT4on8SCk0y+3TN+iK4VHRMJDXJyB1FReI7z4hB9F4Lm0lDUjEln5bhkm7GgMJVFyS7FpFM2EQnNWAisqjBSedirqjhJHfaaBjuhYrYhGB+USzGJfi+OUCU+LIy9NEKlBemcxkMRV/BsYw+UzIuzXgCldkAJHfMNQX5VvIn4MHFRUc4WeS5YZXfCYVfQcg7RxEnmQGs6aEXD3KUGfcE2uaKC/jfYPq0F/Qbbp7Wg5xv0vKB/xe3TWtDzDbprhq8Sfpgo549HyFyQ/jStmerG/v9LpR3Wd0Gpwj9rho9NMxYsl2NSjTchSiXu5Ep8D86X0L+q4TiVRy2hoSpKUkdtTUd1JYeZC0Emo4dNI8TuItwx0wjRGLqXCdefahh9nkf42dcOcHNP0ui9EMQhdeE7C+AbG3DeovDcAQugQDeIcI3to5/lMMBUBIT5XM/RD3Q3BN+eTEIpGshaFjKGODynGEd4zUYdORU/WQ4W2+4ADRZTYZGO+w3BLXMKWyeET1XC+1NxeE4pMryhiNtclfZAlO+AAoh2QEzFg4Zg1owiU7TxziIohjj1XBWvWJgdIMCbcA5TO0AHkQZizX8zyJgyFC8L+g0K0FLQ8w16XtC/YgFaCvoNCnA1Bf0rFqCl4KY55ayRDxVCtiQOzymGjZcUcQUrtOseJgr/YTkQa578zhVniufOdOKzSxSeU4xaU4OnfDLxJoTJ1UUvN/ix2IfM0SzSx/PYPJ4ThufSRzNIs16+hJmGe7wBfogw2/UcfcGthqCHn781AQSrxMzkmAAAAABJRU5ErkJggg=='
$Logos['msi'] = 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAA5KSURBVFhHvVgHWJVHmyV/Sf5ks5tiQwTpHamCYAOxICpqEDAI1l8xNgwqiiFKVIqigigdpCggIEgREGURhVgwgChoRI0GC1Lu127hUu/ZZ76LxP8muyZuds/zzMPlu/ebOfPOvOc9M0pK74DUqqp/ZJbkaWXlF87PTskIKoqKLbi4P7ju8q5vmisCv/uhLPRIYWFcQkh2ZvaX6WcLJ54sqx7lDvxVsZ8/HVEPH35wrKZm/JkzZx0KYuJ2FB85Vli+N7j1+81+A/c9V+Dn+a54vGAJGr5c0f+977bOS/tC6s+HR57Kj43flJqdN+VgVZWqe3Pz+4r9/q8R0Hr3s8jbtebZiWkrLuwLPVLtu6PklveaHxsXe4gezl6AFzbT8UrfDF3qeujSMEC7kQVeTnHEI+dFaHBdKqpdufbeVb+dRaUhBw9mpp7yOlZfbxokkP2H4jh/GLto+pPkigq7nNhY37L9wadq1m++3fiFJ/vQ0RltFnYQaBqCVtYAo6wBeqwmaGXS5J8ZZQ0Z+dulY4y2iVPQMns+Gty8qJoNW+vK94Wm5sUnbUioqLAOAj5WHPet8Hv27MMTFdV6WacyNpWGHSm55rPpyf3Z8yWtFrbo1DGBYLweaFUd0OO0+UapaINS1QGloQ9KXQ8UeUYIq2jJf6OqA4G6Pjp0J6DVcjJ+dHIRX/tq0+OSsPCinPSsdVGVldpbZLIPFHn8JqKrqj5Oy8xdkX0y/eIVv11dLfZzetoMzfloMWq6YMiAQwPzpEgbqwlKxwT0ZAe+kc+UsgYoFS2+0WO1+HfIu8x4PVCahnhpZC5rcZjdU+UX0HHmZFpxauZZ94S6uo8U+QwjoS7h76nZ+bb5cUnhFbu+vdewdAXaJzmAVdcHR5aRj4i2PDqviZH2+v8JE8EscgO7ci0YJxdQZFLk+ejx8kYmMTQ50hfpk9PQR7utPW4v9R6oCAhszI9PDk4/e9YCwHuK/JTCa2uVz0UnBVz52r+91WkhWA0DsCPV+P30L4TebCRCI1UhINGymQZ23QaIQg9BdPQYhHu+A+u1Coz9HDB29qD0TOVRfaM/ZqwW2JGqYDUN8LPzIlzZtrM1PyZxS+TTp58q8lM6du+ebllo+LGmBUsYSsMAHJn1eF1QarryTpXlEeDb6PEQfKYCAXluaA5mznxwfjshSTuFnqor6G1qRt/jx+i9fhPdGdmQxMRB6LMRtKUtBGRShOgbK0HGIlvo9hceXaVhh4Ojnj9XVeSnFNHSonUhOOzw3fmugi4tI7Bj1OUEdYxBGZiB0jL6Zb9pGoC2tAO70B2iPfvRXVSM3vsPMMCwkA3KIBscxKBYjEGJBIP9/ehnKPRevwFxeASYhUtA65r8MllVHbDKmujUNkbjYo9XZSGH9h5qbVVR5Kd0+N499bIDYaF3F7p1dOoYgx2aJW1lB9ZjGZgvPEAZWoDSNQG3biOkBcXovX0H/c+fY4DjMNjTwxOTQ4a+lhb0NjVBBoA8HRAK0d/WDum5IrCL3eXZTlaFRFBZEx26Jmh09XxRGnp4d8hPP41R5KcU3NIyrizs0N5G16VtHTomYNV0eXLMYndwOwMgioziSXJfbUFvQwMGB/oxKBtEb309JLEJEO09ANHe/RCHHIT42HH0XL7Ck5L19qL3zl1I4hMhOhAG4Y4A0LOc5ZI0tB9JwnToTUD90hWtxQcjtwW84EYo8lMKaWsbVXz4qH+9p/czolcskQfb6eA2+kIcnwhxZhZERyIhvXIVA2IhepubIS0vh3DjFlAmlrw2kkZpG4HSN4XI/xv01lxDT/kliCKiINz9LYTf7AG7bCW/CtQ4reElJgTbDUxxa+XaR0URJ3w2dnT8Wrz9u7r+PS8qesONNT4/vTIwAzdqPGgSSZclEO3ZB3FiMnpu1qL/2TP0XrsBceRxMF4rIdDUh+DfRsiT5lNl/i9JAqKHRHLYNT585IXbdqI7IwuigD3yxCN7fChJhMoaeGVkgWsbfe/lxSct/U1jYQ/87UxS+tKrvtvutRlaQDhGvgeJhNCTpkEcG48BikJf8310p52G5EQcOO/VYKyngja0AG1sBdrECrSeKWgzG9BzF4Je4ArKespQopmCdVsGzm3ZL8owRFA0Rh0vja1klbsDGzLz8pwUuQ3jZGHhrIq939W9MJkoE41Wl+vcGHXQk+0hSkhCH4leXR2kF8rRd6cJPRcuoTvxJMT7QyAODoPkeAyE/rvBzF3ELyXrvUq+5ITMUPZT2sb/qqWE4Gh1PDe17i8NC6+JramxVeQ1jJiGBuvSw5FXWs1sBsis+AiOUuOFVpySDsnpTHSfL0E/RUEmk6HvyRNIUlJ5cZakn4b0ciWklZXgvvYH7bkczGI3OTGiqa/1j7Q3yJGSKVLRxhPrqT1FkSeKw+8+MFXkNYyI1lbjoqiYc4/sHKTCoZcFnyiDmTQd0sLzEAXthyQjE4M9UvSR7M07B0lOLp9EouBQiONiISkqBLvNH9Rke9CznXlJoW2m8fVXMXI8QRUtcJqGaHFwEhdFRaccevxcV5HXMMKePtUoOB4T3eS8SMjoTgAzRh2CMepgF3ug71YdJCeiIc0vwMCrNkhS0iAMOcTvTbK87PJVYD29wa5eC3rmXH7PMbOdIdy2A9xXm0Hbz5HvvZGqw/pHGtFb2sgSja5fUoUxcfuDOjqUFXkNIxL4NC8uYWvtmnUdAgtbsCQjdYwh3LoDfQ9a0H0qAz2lFzBA0+guvwRhyEEwM51BW0/lDQI9ZQYovQm8CNM2U0E7OoGZ5QxuwxawC91AT7AGTaqShsEwQW6UGjptHVC9dceL3MRULx/gv3c0QcBfMtIyZlwIDnvy0tEZ3Cdj5JVj09eQXrsBUXgEpPmFfDnr/aEenO820NNngZ42E4yjM+hJ0+UlkYg8WeK5LqDsHMDYOfDZzS5YAqHfTrDzXeW/U9aA8PNxaHVyQeHx6PtJBQVWSr/lZN5EbEWNVnZy2s0WFzdwI1V5s8lMnwUuIBCcz0ZIc/P5YjbQ1QVJbDxfFQS6JvLIEAFW15cvpbYRmJnzwP1zA2/DSD2npzhCFHwQksjjoM0ngfp8HLixmmhe7DGQmXHm0sE7N39tEhQR9ODlyMysnNQGDy8JrW3E23g+A82swW3fiZ7q7zHQ2YVBjuNFWxyfBGaqI59M1OdEpInr0ZHLk7EV2PlfgJnhxFcXIjNEuMWkbFragf5UBQITK9xavqbzVFZO2EGa/kSRz6/gU1f3UcaZnOU1m3wftE+ZAYYI9pDh5Fb78BlLbFX3uUL03LiJnrtNEG7dzu8r2nqaXOfIhPijgFxHeWkhhE2twbh5gnFfBlpvApgRqnjh5ILL/oG16ek59j7A3xX5/CayLl1SKQs7XPRwiafcSb8ejLibSdPArPEB5x8Ablcgui9VQBwaDtbDC6L9YaBnzZMLMlnm15aKvDtKDayrB7hNvqBMJ8qPDSpauOe1arDoRGx6UG7uHziOAu/lxyYG/7BqHdNhYC4/IPHuWY2PArc9AJIzOejOOcuLtbT0Ar9s3QWFvLmgSDbrTvglkmO1eMLcFj8IA4NAk306Rh3tZja4tW7D89yk1O2KFN6KrFM5s6v8dlT/PGuenCC/F7XBzJ7Pu5qe6hoMtLdDRgzpgwfoLiyEJDsX3PZdch18bUr56qEJdo4LxCdiIQwJA2Noxn/3yGkhqnYElKRn5tgpjv9WRFfVKpeGHIpq9Fwh7SInNhIFssTWU8AuWwHJseMY6OzkM5pYKt65uHuBcZwLythSnigjVCEYMY6POomc+HAk72zI/ms3MEet92q2IDxiX9jdu58pjv9WbHn48IPc5FSv6s1+DU9t7UGP15cfoEhENPT5EibNK4Csuxs9/3mZlxSe1Kjxw1aKSA87bxHEB8IgjokH6+ENiiTdeD20TJslu+wXUJWSmekSBPxNcfzfhdiWFq3S8MiIBndvrkPfDOzrwxO5UZjsAG71ep7cAEOjp6QMwlU+4Ba5g3PzBOe9BkI/f95JS8svQrT7W96OMaPU8MrQHHXLVnYUHTm+72hLyzjFcX83goD3s05nuVXuCrz+aMrMPkZdHzSJDhFmKztQlnbg1m+GtOoKfzbpu3MXvXX16GtqRm9DIy9Fon3BYD2Xyz0ikRoNfbTMmCOtCDpQfvrsuTlKwF8Ux/1DiKqqUj0XlxBY85XvyzZCaKSa/DxB3Ak59U12BLczEJK4REiSU9BdfB7SohKIo+PAEpPgMAeUsZXcGHw+Ds9tpqF667YneSmnNp+4f//XZ493QVJZmWl+dMLpW6t8ugWmNuRAL6OHHDdlZMnXW9pmOmg7e/6QxTgvBm0xCQIyETUd0FpG5NwhE1hNxvX1m4T58Ykn4isrtRXHeWcQhU8pKnIsPBF3sXHlugHKwByssro8aXhnoguKOHBC+LVTGbqbIbdd5IzdZWKJ+nUbe/LjEvOTS0snvtUUvAvS8wqWloUdvtbksayvQ990uBoMC/Kbbeg7epwW2g3NUb/inz1FUdHlKQXn5yn2+6fh6PXrH6afyVlaHhxaedvdS/jCbJLcWikQ5K/cyEWTuh6eW9mizmsVUxIecT6loMAlqBl/oKS9A6I7Oj7OyDjrWhYWnl27Zn3n4xlz0aVjxLtv/hJTfnmJLt0JeDjTGTfWbnhZfCQyLe1csfPRZ88+VOzv/wRBL19+lHL+/LTio1EhV7/2v9Xw5fLBV47OEBiYQ2BogbaZ8/GD58q+y367rhVGxuyNLymZ9LsvKP80AO/FFJSr5aSd9iw+ciy92s//x3rPlZK6ZatEV/0CmooiohJPp6W5xV+4Olbx1f9XuOfmvp9ceEklKzHN82z8ydT8+OTkMykZrrEXL472qav7ff7uf8B/AX7+6M0zxhfuAAAAAElFTkSuQmCC'
$Logos['mullvad'] = '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'
$Logos['nvidia'] = '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'
$Logos['opendns'] = 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAXQSURBVFhH7ZhpbFRVFMcvlLYsAT+IqEgQ94B+UwmCUXH7YAIkChGXiHxwiSgg7czQDSi0nZbSWgIFWkCoKRBAhMoSEEtZ1GojmLYsYRkoVSggUGmRrvN+eua+4U1fplBg6pL0Jf+0mbn33N8597039/yV16mKjBTl8SYoj9elPF5nG+RQHm+08nijTE2xyf+5SMbJeHuMYIpRHmOG8hjJvnk5jFFhynCp8yxQ8JmCVAXuNihZwSwFMxRMUxBvU4L5eaI5TsbbYwRTmoK5CuYrDIcq9AN6yDAHSMDp15AsKhKAOFMxCqbaJJ+J5PtAYHs8u2aaRUpXGE5V4AOU0vo+FDj/gsEkCztNyf8J3SDlDkgfAJmPQNajMPcxyBoEmQ9BWn9Iuh0SIsFlzpO/gQnYJckIpFvhbQEo1ZMMZJAECSaHgikKoiRQd8gYCHkjYcME+GY67HTDrnQoSoatsbDufVj6EqTdBzER1lw/aDDFmrdNisIbfSOA/so5OkFsd5gzEFa9Bd9lwZFtUFUGF45DdSWcPwqn9sGBAtiRBHmjwD0AYiIh2ky0NcibApRgEtjVGRJ6QcYgWPUm/JANlT9BXTUYXlpc3iaoOQPHdkBRqq502v0Q110nKfGCQd4woASRbflUvguH2Q/CyjegOBt+LYErF0ygZmj8ExpqoekKYGjo2jPg2QlFblg2ApL7gqOzjudLOhSAcu9MlMldYcEQKEyCk8Vm5ZqhoQbOHQJPERzeAhV74KIHmurAaILLZ/VtsCkKMgeBI0zHk8RDAijZfiJPeA/4/GXYmweXTlnb+fsR+HkZbJwEa8fpB6T8S6g5rb83DDh3GHZnwPwnwdFFx5PEQwI4WcHH8uT2hC9GwcGvoeGytbVSufUfQvpASOwD8wbDtng4XWYlUXsWSpbComHgDNfxQgooGSf0hPwxcKxQPwRyNdXD/q/06yQqHD6QRG6D1W9DxfcWYH0t/LIScp+xAGVn7A/KrQH2gpWvw/Hd1sJyn5WuhkVP6UXfkddIOOS/Csd3WeMa66BsDSx+rp0AJeBVwD0tAWVhP+C4QMCARJrroWztPwE4Fk7YAQMqeC3AcgEc3t6AQba4fA3kDtOvjndlXiSsGB280u1fwdYAn9aA42VeV1gxpgOwA7ADsAMwpIA5w/TPobwHnRGw4rV/C/B/8UtiB5QKXgdQTj3tWsEWpxk5pRgWYKkADtVjBFC2OF+2OADQd5pZDbkCGNEOgP4K5o+Go9uhudGqjHRvy18BVzeYIAv0hrXjoaLYAqy7BPvyIUfOgyZgSA+sElBO1NKdHdgA9TV6YTlRy8F0czTMHwyzH4DFL0BRCpw9aAFeqoIfc2Hh0HY4UctW+HuSJS9CyRKoPql7DbkuVkD5OiicCVuidfN+eCtcPmcm0QRV+3X7Oe9xcIa6J5FAk2RyJMx7ArbFwbFvdd/rbYTGK/BHpW7WK4uhqlQ3TPLkiiSZ/eth/Ucw52Hd1Um8kLSdIgkkkFO7gLu/3maxOaRZqq2yHhipVHOD1a/IfSrVPbRJd3q5z8PMProvlnjiMNjXuilAqaLPrugEcd2015I3Qjfjnh1QU6UrdfUydPN+8YTuAH1wwyGpr/ZorsYLstZNAQZCSjVlEfe9sHwkbE/UTZO8ek7thdOl8FuJ7vykf97s0JWbdae+9/yWRzC4WwIUBbpbsRGQOgBynoVVY3VfvGkybI6CjRNh3Xv6lZQ9RNsdU8P03NY8mesCirMpvpz4czKoNQUalPERkNgTknuD+25I7Qdp/SD1Hki5S3uDM3pAfJeW8+wxAyVGpziyqQH+oM9hzTTtV4GUDK4nv+3rh7ZXwg/jd1hld+wxgkngZiuYE+CwGi5VzUIFWab9mtIG2T1qyTxQfqs40KO2xwgmgROPOttXwZ0a0KlyjGRV4J2mCrwuVSB732ZFtUH2OddSjCowpqkC4Wl2qjimq85KKFmjwnx//ysSHoH7+/oLiJnDFAVksy8AAAAASUVORK5CYII='
$Logos['quad9'] = 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAYzSURBVFhHxVl5TBR3FJ4eVtpAOZZdlpmdmd2VamvTw6oVQQ7FihzLXZe9BBY8eqSpsTba2Jg2JrXGNlqNGsFUJf5ljFytpaCVKm2CcnTBgiiirLhShVbQXtZO841stL+dZRdc5UteMuzO997beedvoKgx4qPgqNk1bNqKg+FJpUeZrIYWzmA/q7YMQHB9hMlqwHfVTNoK3EvyHxQmFivmGutVOUdbOMPQL9oi4aq2SHBorYJdUyD0aPJFwTU+w3e4B/eCs0sRb6Ioyo9U6hNsVMTO/l6VXdOtzhP6tIXCJU2BcE692KN0qReL9/Zpi4RuTZ5wXJVVu0keE0Xqvy/sVMQV2TjDb9cmLRHgIOmEtwIHoaOFMwwWK+YuJe2MCTvD4t85w5tvXdEWuhgcq0BXB2++vVuRsIK0Nypslcdkd3Cmv5FPZyUMOQVPFWHs1VhFwfVITxq6LmusQofafOuL0Hg9adcrrAyaxp/kFtmR5O6cO6/OEwsBzjSy+sEW1nAZ0sTmDnar88XvcA/JczoJ3U2cvnd14Awtad8jKsJTt6MYSMVO5ahU5NQJVc531XT6m6aAiMjn/JT8ND8lnxfwbGQ1nfnWj+zrxy4MV7W7HwkbVbRuF2l/RKySzZjSyOmvOSQchCGEsJU3/n5AmYwcepLk34OnDiiT32vjjH+AI+UkQt3M6gfWhbw6lSS7RSWT8i4SuUsiPBc1+UKn2iLsVSYuJ3nusC9swdtn1RaRS+pDG0Koy2ndSpLnDo+W0SllV7VLJJWhYGqYjAqS5Am1qsyvLmutog5SL3K1PDy5HLZJngu2yeP8T7KLuqQaMYoBskUWqyN5nrA5JDYThSNV3bB1itWfh22S54I9IfOYTt48iJFFKurRFKDJXq8IT+VInicc5tPVNs44BB2uevOFM7zl+lbZfJrkuWBt6KxnOnjTDSkH0eNOqLK71yhmhZE8T1gnn6msZ7MvQgepF7Y6ePPQavm0CJLngs3B0VwnbxmSchDtopHL7a8MSWFInieUMgtV6AzQQeqFLURtU3AMS/JccIhPD7JxBoeUImf+bJXFxZM8T9gii517rw7yh7fwufbSiIVPkzwXTKeoCYdpXZ3U7EUFIkTldEoxyfOEcmXqbnClqhi2qhhdLUVRj5M8SVTQqZ8OSLQZ56/t4M2D6+UzE0meO2wIjU46I6aNa1QgsFXO6NaTPLcoUcQntHLGf9wpRC/8iTP0bJTPWUhySXwWGpts4429mEpSkwQ2WnnjrRLF/ASSOxImHmOy66Sa9V0nC4U2znijiknf9n7IK5ElsqgAiqKegJTI0gLWyKdHf83odpzmTDelRqZTMIt/YHMaPIxMV2wOnZP6M2+67e4pOhcG5FU7Z/7zFKvv+oZOr4M0svqudt78F+bsSIsCNh27tkDYq/B+bP4PFUzq9mvakbdozGvM2Esaq5jsEEwGfCY1y+8VzOB6Nsf2UiAfRNr2CoFUYNARJuNw/32u+lIyvDj8W6xIMJJ2R4UIyl9ey2SU49CDpyTVJsYiiEwNnXmIoqhHSJtjgf9BOukTG2e4icJx18+8FWw1zZzBsSzkZe93QG/wYXBkdC2Tsb+J1Q8g11AEEOdZBNcInbuigFxQ4+xcIOxTLniD1O8zfB4W/fx+ZeKyMmXyfhtnaG5XW87bOIO9lTd0tXHGvpHyFYXxbXga9knPu5+voKWCA6dScqUfRXFHVJnHHRrpvod+2MTm9n0si5pC6ngoOBie9AHCJ3WSQ2hxyPpSOW9sPe9+sUk2J6GdN91EpZPOQcSqvXNU8G4h8CXi/CeH1qty2qTO0PjbobHi3HxlecAL4xPaSlpXjD7pPrT5wl7F/PEJbbFynrlzeCsmnUOvRN+sZtLLhheJhwtLwIuTT7F6u9S2IoZWWyiGdq1sxriEdkItnVGF5JeaKmjYeO2xT7HAN6/ZRovSsNdWwQm0DtI5iNiQ74T24TVkJ7Yr4iJbOcMNzFTSMYT2ikZsyI7VoTMnk9wHDp4KDKpjshpQtaRzEIQV1bwnPGFcQvtYJaPb8eukpeLq5XxpflcKhAHtUqGGzvDZGjUqbJDHJJ7mjH096nz8u6H/HCG9moL+Zjb3tNWHDfk/YQYVPCB+CUoAAAAASUVORK5CYII='
$Logos['raphire'] = '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'
$Logos['snappy'] = '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'
$Logos['techpowerup'] = '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'
$Logos['threadpilot'] = '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'
$Logos['valleyofdoom'] = 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAANwSURBVFhH7ZnfUxJRHMX9U81s8kfmlOVMTdNTb1mN5UP286G3ml56KlFQNDN/wIKmMCCiCP4EdhcEM6fTnGuXlstuCurgAw/nAWbP9372cvd8712adF2PFQqFTDabvVAiE9madF3PHx4eolAoXCiRiWxNf2mR1XUUTAM/cyb26ySOXTBNgglIspUA90wDXyIJPPdH8CYQrYsG/RF8Cq8iZxgoqoCkJ9wllw+dHq0uanX50De9JCarApBTzLvghbe8wbqoy6Ph2Vy4AVizjgV8HYii3a3h5liwLup0a3g6+x/At4EoukY19I4H66LuUQ0DTjNo6DqSu2nEtnaxsl0fcezETlqwVOQgw5H5Q/p6Km8Y9kHNLy+SGoCnVVWAXLSymZcpb6KYO2ruquTm4yBv48uZoqbqserEgCyUzmbxfW0DX+MpTK7+00Q8icD6Jkyj0scH7kdqC+PxZJlnMp7Ct9UUtjNZW1/VgBxoI50RSd/m9uOaRyupddiHRzNHzV2dEbn5aBn2lXnYCK6Paoht7wqfOl5NgJvpDO59XcCNsYBja1IBnVonOwZDmbnXAGwAnhSQD0mPN4irI350uLWSWlxzeDITwu+9XMVZBsU8XmoRNLvmyjxtI0cPy5k9JDJmPLF1DEUTcFnkXl7Hx6W4AFHPFy+0KD4srsAdWy/zsMbwcgJb6czZxIyE5Awd5HMieKVQ3MN0YgMtNueY5iGfuAHs75V5pNQloaoqQCcRmuHLn8y6zij+nJwxwqi+k6gBeC6ApmGIp9ZOagHqNIBqfSky2AJy0e5ksiJSmHuquDtRB6kVkLXU+hTH3s5k7AG5bXo3vyyKM5Sl7k4s4P7kAuI2uVULIGeJEfNgahF3JubLxur1BsXrD45TcWhiuL7SImLHwo4h1T0aQI83YJv8tQJytgjHXY11rA63H/2zIWfAalvTaQCPa50NwHMB5AK9POwTF0pxIJ747Zr7Qc4UW3rurK0eiu3vc2QNvxwAb3uDaHf7yzxXxA7dYQ3yzSZfHvbNhMRdSPXPhTHgC4sTf14BLJomtOSmKGr1UA+nQ5haTYkbt3qYc4ySQS0ials9j2dCeL+4IsapAKSZp3qexHgHUvKzU3PnjkT1SJ8MXTtZa1s9chJKOWh9iU5qJ4lZdpB67Wk80ld6iX7R/4b4A+uNRwiZ2KF8AAAAAElFTkSuQmCC'
$Logos['wagnardsoft'] = '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'
$Logos['stop-it'] = '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'

# ===== 00-noyau.ps1 =====
# ---------------------------------------------------------------------------
# Noyau : où on est, élévation, détection machine, outils d'écriture avec retour arrière.
# ---------------------------------------------------------------------------
$Depot = 'https://bagarre.mtsu.dev'   # un Worker Cloudflare (worker/) qui rend le dépôt GitHub : "/" = bagarre.ps1, le reste tel quel
$Version = '8.0'
$ErrorActionPreference = 'Continue'

# État partagé avec les gestionnaires d'événements de la fenêtre. Une table, jamais $script: :
# selon le lancement (-File, "irm | iex", scriptblock) le préfixe $script: ne désigne pas la même portée,
# alors qu'une lecture sans préfixe et une écriture dans cette table marchent dans les trois cas.
# Simulation : quand $Bagarre.Simulation est vrai, les fonctions d'écriture n'écrivent rien et notent dans $Bagarre.Verif
# si la valeur en place est déjà celle visée. C'est ainsi que la fenêtre détecte ce qui est déjà fait.
$Bagarre = @{ Langue = 'fr'; L = $null; ConsoleN = 0; DnsAdapt = $null; DnsResultats = @(); Simulation = $false; Verif = $null; Cartes = @() }

# Lancé depuis un clone (powershell -File bagarre.ps1) : les images sont à côté.
# Lancé par "irm ... | iex" : $Here est vide, elles sont ouvertes depuis $Depot.
$Here = if ($Depuis) { $Depuis } elseif ($PSCommandPath -and (Test-Path (Join-Path (Split-Path -Parent $PSCommandPath) 'images'))) { Split-Path -Parent $PSCommandPath } else { $null }

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

# Langue de la fenêtre et de la console : celle choisie par un clic sur un drapeau la dernière fois,
# sinon la langue d'affichage de Windows (Get-UICulture, pas Get-Culture qui est le format des dates).
$LangueFichier = Join-Path $Dossier 'langue.txt'
$Bagarre.Langue = if ((Test-Path $LangueFichier) -and ((Get-Content $LangueFichier -Raw).Trim() -in 'fr', 'en')) { (Get-Content $LangueFichier -Raw).Trim() }
          elseif ((Get-UICulture).TwoLetterISOLanguageName -eq 'fr') { 'fr' } else { 'en' }

# Les phrases écrites dans la console avant que la fenêtre existe ou hors de la fenêtre (application, restauration,
# téléchargements). Les lignes techniques (registre, service, tâche, réseau, alim) gardent leurs mots-clés français :
# c'est le journal, on le lit avec le catalogue à côté. Msg 'cle' rend la phrase dans la langue courante.
$Messages = @{
    fr = @{
        rienRestaurer = 'Rien à restaurer : bagarre-avant.json est vide.'; restauration = 'Restauration de {0} réglages...'
        restaure = 'restauré  {0}'; echecRestauration = 'ÉCHEC restauration {0} : {1}'; finRestauration = 'Terminé. Redémarre pour que tout reprenne effet.'
        rienCoche = 'Rien de coché.'; application = 'Application de {0} réglages...'; echecItem = 'ÉCHEC {0} : {1}'
        finApplication = 'Terminé. Les valeurs d avant sont dans {0}, le détail dans {1}. Redémarre le PC.'
        rapportEcrit = 'Rapport écrit : {0} ({1} Ko)'; fenetreFermee = 'fenêtre fermée'
        consoleOk = 'Terminé sans erreur, cette console se ferme.'; consoleErreur = 'Il y a eu une erreur, lis ce qui est au-dessus. Entrée pour fermer.'
    }
    en = @{
        rienRestaurer = 'Nothing to restore: bagarre-avant.json is empty.'; restauration = 'Restoring {0} settings...'
        restaure = 'restored  {0}'; echecRestauration = 'FAILED restore {0}: {1}'; finRestauration = 'Done. Reboot so everything takes effect again.'
        rienCoche = 'Nothing checked.'; application = 'Applying {0} settings...'; echecItem = 'FAILED {0}: {1}'
        finApplication = 'Done. The previous values are in {0}, the detail in {1}. Reboot the PC.'
        rapportEcrit = 'Report written: {0} ({1} KB)'; fenetreFermee = 'window closed'
        consoleOk = 'Finished without error, this console closes.'; consoleErreur = 'Something failed, read what is above. Enter to close.'
    }
}
function Msg($cle) { $Messages[$Bagarre.Langue][$cle] }

# ---------------------------------------------------------------------------
# Détection machine (sert aux valeurs automatiques et aux explications)
# ---------------------------------------------------------------------------
$RamGo = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
# Carte graphique : la carte dédiée compte, pas l'iGPU du processeur. NVIDIA ne fait pas d'iGPU sur PC fixe, chez AMD
# la dédiée s'appelle "Radeon RX" ou "Radeon PRO" (l'iGPU est "Radeon Graphics", "Vega", "780M"), chez Intel c'est "Arc".
# -Amd (mode de test) simule une carte AMD dédiée pour voir la page AMD sur un PC NVIDIA.
$Cartes = @(Get-CimInstance Win32_VideoController | ForEach-Object { $_.Name })
$Dediee = $Cartes | Where-Object { $_ -match 'NVIDIA|GeForce' } | Select-Object -First 1
if (-not $Dediee) { $Dediee = $Cartes | Where-Object { $_ -match 'Radeon (RX|PRO)' } | Select-Object -First 1 }
if (-not $Dediee) { $Dediee = $Cartes | Where-Object { $_ -match 'Intel.*Arc' } | Select-Object -First 1 }
if ($Amd) { $Dediee = 'AMD Radeon RX (simulée par -Amd)' }
$Gpu = if ($Dediee) { $Dediee } else { $Cartes | Select-Object -First 1 }
$EstNvidia = [bool]($Dediee -match 'NVIDIA|GeForce')
$EstAmd = [bool]($Dediee -match 'Radeon')
# Processeur : les groupes "Processeur Intel" et "Processeur AMD" du script n'apparaissent que sur la marque détectée.
$Cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$CpuNom = if ($Cpu.Name) { ($Cpu.Name -replace '\s+', ' ').Trim() } else { 'CPU inconnu' }
$EstIntelCpu = [bool]($Cpu.Manufacturer -match 'Intel')
$EstAmdCpu = [bool]($Cpu.Manufacturer -match 'AMD')
$EstPortable = (Get-CimInstance Win32_SystemEnclosure).ChassisTypes | Where-Object { $_ -in 8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32 }
$DisqueSysteme = Get-PhysicalDisk | Where-Object { $_.DeviceId -eq ((Get-Partition -DriveLetter $env:SystemDrive[0]).DiskNumber) } | Select-Object -First 1
$EstHdd = $DisqueSysteme -and $DisqueSysteme.MediaType -eq 'HDD'
$Machine = "$CpuNom, $RamGo Go RAM, $Gpu, disque système $(if ($EstHdd) { 'HDD' } else { 'SSD' })$(if ($EstPortable) { ', portable' })"
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
    Rafraichir
}

# Laisse la fenêtre se redessiner pendant une action longue (tout tourne sur le thread de la fenêtre). Sans ça, passé 5 s
# Windows la déclare "ne répond pas" et affiche une copie figée par-dessus. À appeler dans toute boucle qui dure.
function Rafraichir {
    if ($Fenetre -and $Fenetre.IsLoaded) { $Fenetre.Dispatcher.Invoke([Action] {}, [Windows.Threading.DispatcherPriority]::Background) }
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
# Fichiers du dépôt (images) et lancement de commandes dans leur propre console
# ---------------------------------------------------------------------------
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

# Lance une commande PowerShell dans une console à part (visible, admin comme nous).
# Sert à tout ce qui est interactif ou bavard : winget, Win11Debloat, WinUtil, DISM.
# Par défaut la console reste ouverte (commandes dont on lit le résultat : powercfg, DISM analyse, rapport Defender).
# -Fermer (installations) : elle se ferme toute seule si tout s'est bien passé, et reste ouverte sur une erreur
# (exception PowerShell, ou code de sortie non nul d'un exe ; la commande pose $Echec = $true pour le reste).
# La commande passe par un petit .ps1 dans le dossier bagarre, pas par -EncodedCommand (motif suspect pour Defender).
$Bagarre.ConsoleN = 0
function Console-Lancer($titre, $commande, [switch]$Fermer) {
    $Bagarre.ConsoleN++
    $fin = if ($Fermer) {
        "if (`$Echec) { Write-Host ''; Write-Host '  $(Msg 'consoleErreur')' -ForegroundColor Yellow; [void](Read-Host) }`r`nelse { Write-Host ''; Write-Host '  $(Msg 'consoleOk')' -ForegroundColor Green; Start-Sleep 2 }"
    } else {
        "if (`$Echec) { Write-Host ''; Write-Host '  $(Msg 'consoleErreur')' -ForegroundColor Yellow }"
    }
    $texte = @"
`$Host.UI.RawUI.WindowTitle = 'bagarre : $titre'
Write-Host ''
Write-Host '  $titre' -ForegroundColor Cyan
Write-Host ''
`$Echec = `$false
try {
$commande
} catch { Write-Host `$_ -ForegroundColor Red; `$Echec = `$true }
if (`$LASTEXITCODE) { `$Echec = `$true }
$fin
"@
    $fichier = Join-Path $Dossier ("console-{0}.ps1" -f $Bagarre.ConsoleN)
    [IO.File]::WriteAllText($fichier, $texte, (New-Object Text.UTF8Encoding $true))
    $sortie = if ($Fermer) { '' } else { '-NoExit ' }
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass $sortie-File `"$fichier`"" | Out-Null
    Log "console   $titre"
}

# Une console par installation, fermée si winget a réussi. Le code -1978335189 (0x8A15002B) veut dire
# "déjà installé, pas de mise à jour disponible" : pas une erreur pour nous.
function Winget-Installer($titre, [string[]]$ids, $source) {
    $src = if ($source) { " --source $source" } else { '' }
    $cmd = ($ids | ForEach-Object { "winget install --id '$_' -e$src --accept-package-agreements --accept-source-agreements; if (`$LASTEXITCODE -and `$LASTEXITCODE -ne -1978335189) { `$Echec = `$true }; `$global:LASTEXITCODE = 0" }) -join "`r`n"
    Console-Lancer $titre $cmd -Fermer
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
Ajouter $G 'jeu-mpo' 'Couper le Multiplane Overlay (MPO, OverlayTestMode = 5)' `
    'Le MPO laisse la carte graphique dessiner certaines fenêtres directement, sans passer par le compositeur de Windows (DWM). C est lui derrière les écrans noirs, les scintillements et les saccades en fenêtré que NVIDIA documente (article 5157, 2022) et que les cartes AMD connaissent aussi. Coupé, DWM compose tout : zéro effet en plein écran, plus de surprise en fenêtré ou en multi-écran. NVCleanstall pose la même clé avec sa case "Disable MPO".' $true 'Une vidéo en fenêtre coûte un peu plus de GPU (plus d overlay matériel). Sur 24H2 et plus, Windows ignore parfois la clé : dans ce cas rien ne change.' {
    Reg-Ecrire 'HKLM:\SOFTWARE\Microsoft\Windows\Dwm' 'OverlayTestMode' 5
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

# ----- Groupes par marque : seulement sur la machine concernée ----------------------
if ($EstIntelCpu) {
    $G = 'Processeur Intel'
    Ajouter $G 'adv-boost' 'Boost du processeur en Aggressive (PERFBOOSTMODE)' `
        'Le mode boost du plan d alimentation décide à quelle vitesse le processeur monte en fréquence quand la charge arrive. Aggressive le fait monter tout de suite au lieu d attendre. Clé Intel : sur AMD le boost est géré par le firmware.' $false 'Sur portable : chauffe et batterie pour rien. Sur fixe, un peu plus de consommation au repos.' {
        Powercfg-Regler 'SUB_PROCESSOR' 'PERFBOOSTMODE' 2 'mode boost du processeur'
    }
}
if ($EstNvidia) {
    $G = 'Carte graphique NVIDIA'
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

# ===== 15-catalogue-en.ps1 =====
# ---------------------------------------------------------------------------
# English titles and explanations of the catalogue, by item id (the French ones live in 10-catalogue.ps1)
# ---------------------------------------------------------------------------
$TraductionsEn = @{
    'svc-telemetrie' = @{ Titre = 'Microsoft telemetry (DiagTrack, dmwappushservice)'; Pourquoi = 'Sends your usage to Microsoft continuously. No role for you.'; Attention = '' }
    'svc-geoloc' = @{ Titre = 'Location services (lfsvc)'; Pourquoi = 'GPS position for Store apps. A desktop PC does not move.'; Attention = 'Weather and map apps no longer locate you.' }
    'svc-phone' = @{ Titre = 'Telephony (PhoneSvc)'; Pourquoi = 'Used by Phone Link to make calls from the PC.'; Attention = 'Phone Link loses call support.' }
    'svc-maps' = @{ Titre = 'Offline maps (MapsBroker)'; Pourquoi = 'Downloads maps for the Maps app. Nobody uses it.'; Attention = '' }
    'svc-demo' = @{ Titre = 'Retail demo mode (RetailDemo)'; Pourquoi = 'The showcase mode for PCs on a store shelf.'; Attention = '' }
    'svc-wer' = @{ Titre = 'Windows Error Reporting (WerSvc)'; Pourquoi = 'Sends a report to Microsoft when a program crashes.'; Attention = 'No more automatic report when an app crashes (you can still read Event Viewer).' }
    'svc-fax' = @{ Titre = 'Fax'; Pourquoi = 'It is 2026.'; Attention = '' }
    'svc-compat' = @{ Titre = 'Program Compatibility Assistant (PcaSvc)'; Pourquoi = 'Watches every launch of an old program to suggest a compatibility mode.'; Attention = 'Windows no longer offers to fix an old program on its own.' }
    'svc-xbox' = @{ Titre = 'Xbox services (XblAuthManager, XblGameSave, XboxNetApiSvc)'; Pourquoi = 'Xbox Live sign-in, Xbox cloud saves, Xbox networking.'; Attention = 'Game Pass for PC, the Xbox app and Microsoft Store games stop connecting. Leave unchecked if you play an Xbox or Game Pass title.' }
    'svc-edge' = @{ Titre = 'Edge background updates (edgeupdate, edgeupdatem)'; Pourquoi = 'Two services that check Edge every hour. Edge updates itself on launch anyway.'; Attention = '' }
    'svc-wmp' = @{ Titre = 'Windows Media Player network sharing (WMPNetworkSvc)'; Pourquoi = 'Streams your WMP library on the local network.'; Attention = '' }
    'svc-insider' = @{ Titre = 'Windows Insider Program (wisvc)'; Pourquoi = 'Only used to receive beta versions of Windows.'; Attention = '' }
    'svc-diag' = @{ Titre = 'Automatic diagnostics (DPS, WdiServiceHost, WdiSystemHost)'; Pourquoi = 'The automatic troubleshooting utilities. They run permanently for very rare use.'; Attention = 'The Troubleshoot button in Settings stops working while this is off.' }
    'svc-cdp' = @{ Titre = 'Connected Devices Platform (CDPSvc)'; Pourquoi = 'Nearby Sharing, Phone Link, continuity between devices.'; Attention = 'Nearby Sharing and Phone Link stop working.' }
    'svc-imprimante' = @{ Titre = 'Print spooler (Spooler)'; Pourquoi = 'Manages printers. Without a printer, it runs for nothing.'; Attention = 'You can no longer print, not even to PDF. Check this only if you never have a printer.' }
    'svc-recherche' = @{ Titre = 'Search indexing (WSearch)'; Pourquoi = 'Builds an index of your files so Start menu search is instant. On an SSD, indexing costs very little.'; Attention = 'File search in Start and File Explorer becomes slow. Outlook too.' }
    'svc-sysmain' = @{ Titre = 'SysMain (formerly Superfetch)'; Pourquoi = ('Preloads into RAM the programs you launch often. On an SSD it does not get in the way, on a hard drive it can cause slowdowns. ' + $(if ($EstHdd) { 'Your system disk is an HDD: check it.' } else { 'Your system disk is an SSD: leave it.' })); Attention = 'Program launches are no longer preloaded.' }
    'svc-bits' = @{ Titre = 'Background Intelligent Transfer Service (BITS)'; Pourquoi = 'Downloads Windows and Store updates quietly in the background.'; Attention = 'Windows Update, the Microsoft Store and Defender definitions stop downloading. Honestly, do not check this one.' }
    'svc-bluetooth' = @{ Titre = 'Bluetooth (bthserv, BTAGService)'; Pourquoi = 'Everything Bluetooth.'; Attention = 'No more Bluetooth devices: headset, controller, mouse. Check this only if you have none at all.' }
    'svc-delivery' = @{ Titre = 'Delivery Optimization: stop sending updates to strangers'; Pourquoi = 'By default your PC re-sends the Windows updates it downloaded to other PCs on the internet (peer to peer). That uses upload bandwidth while you play. We keep the download, we cut the upload.'; Attention = '' }
    'svc-hyperv' = @{ Titre = 'Hyper-V guest services (vmic*)'; Pourquoi = 'Only useful if Windows runs INSIDE a Hyper-V virtual machine. On a real PC they never start, cutting them changes nothing.'; Attention = '' }
    'priv-telemetrie' = @{ Titre = 'Telemetry at the minimum (AllowTelemetry, CEIP, error reports, PowerShell)'; Pourquoi = 'Sets the level of data sent to Microsoft to the lowest. Honestly: on Home and Pro, AllowTelemetry=0 behaves like 1 (the "required" level stays), only Enterprise and Education editions cut everything. We also cut the Customer Experience Improvement Program (CEIP), crash report sending, feedback requests and PowerShell telemetry.'; Attention = 'Crash reports no longer go to Microsoft (they stay readable in Event Viewer).' }
    'priv-pub' = @{ Titre = 'Advertising ID, suggestions, Start menu "Recommended" section, Chat button'; Pourquoi = 'Cuts the advertising ID, suggestions in Start and its "Recommended" section, tips on the lock screen, ads in File Explorer, silent installation of sponsored apps, the rotating illustrations in the search box, the Chat (Teams) button on the taskbar and online tips in Settings.'; Attention = 'The Start menu "Recommended" section becomes empty (recent files stay in File Explorer).' }
    'priv-saisie' = @{ Titre = 'Typing and voice personalization'; Pourquoi = 'Windows learns your typing, handwriting and voice to send them to the cloud. Useless outside Cortana.'; Attention = '' }
    'priv-fond' = @{ Titre = 'Store apps running in the background'; Pourquoi = 'Stops Store apps from running once closed.'; Attention = 'Notifications from these apps (Mail, Weather) stop arriving while they are closed.' }
    'priv-copilot' = @{ Titre = 'Turn off Copilot, Recall, Click to Do, Widgets and the Notepad / Paint AI features'; Pourquoi = 'Copilot and Widgets are processes that stay in memory. Recall, when active, takes a screenshot every few seconds and indexes it: constant CPU and disk use. Click to Do analyzes the screen on demand. The AllowRecallEnablement and DisableClickToDo policies are the ones documented by Microsoft (WindowsAI CSP policy, 2025). We also set the AI stack service (WSAIFabricSvc) to manual and turn off the AI buttons in Notepad and Paint.'; Attention = 'No more Copilot, no more Recall, no more Click to Do (Win+click), no more weather / news panel, no more "Rewrite" in Notepad or Cocreator in Paint.' }
    'priv-taches' = @{ Titre = 'Telemetry scheduled tasks (Compatibility Appraiser, CEIP, Feedback, DiskDiagnostic)'; Pourquoi = 'Background tasks that scan your installed programs and send the result to Microsoft, sometimes in the middle of a game (Compatibility Appraiser is known for its disk spikes).'; Attention = '' }
    'priv-assistance' = @{ Titre = 'Turn off Remote Assistance'; Pourquoi = 'Lets someone take control of your PC through Windows. Nobody uses it, and it is one less door open.'; Attention = 'The Windows "Quick Assist" button stops working (Discord, AnyDesk, Parsec are not affected).' }
    'priv-sync' = @{ Titre = 'Settings sync with your Microsoft account'; Pourquoi = 'Stops sending theme, passwords and settings to the Microsoft cloud.'; Attention = 'Your settings no longer follow you to another PC signed in with the same account.' }
    'priv-autorun' = @{ Titre = 'Turn off automatic execution for USB drives and disks (AutoRun / AutoPlay)'; Pourquoi = 'A plugged-in drive no longer launches anything on its own. This has been Microsoft''s baseline security recommendation since 2011, still open by default for the "what do you want to do?" window.'; Attention = 'No more automatic window when you plug in a drive or a phone: you open it from File Explorer.' }
    'priv-relance' = @{ Titre = 'Stop reopening apps automatically after an update (ARSO)'; Pourquoi = 'After an update restart, Windows signs back in on its own and relaunches whatever was open. A PC that boots with 15 windows and yesterday''s launcher.'; Attention = 'After an update you type your PIN again and reopen your apps yourself.' }
    'priv-metadata' = @{ Titre = 'Stop downloading device info sheets and icons from Microsoft'; Pourquoi = 'Every device you plug in triggers a download of its icon and info sheet from Microsoft. Purely cosmetic, in "Devices and Printers".'; Attention = 'Devices show a generic icon.' }
    'priv-presse-papiers' = @{ Titre = 'Turn off clipboard history (Win+V) and its cloud sync'; Pourquoi = 'Windows keeps in memory everything you copy, passwords included, and can send it to your Microsoft account.'; Attention = 'No more Win+V. If you use it, leave this unchecked: only the cloud sync is worth cutting, and that is in Settings > System > Clipboard.' }
    'jeu-dvr' = @{ Titre = 'Turn off Game DVR (Game Bar background recording)'; Pourquoi = 'Game Bar constantly records the last 30 seconds of gameplay "just in case". That is an encoder running while you play.'; Attention = 'No more instant clip with Win+Alt+G. Game Bar itself stays (Win+G).' }
    'jeu-presence' = @{ Titre = 'Turn off GameBarPresenceWriter (the process that remains after turning off Game Bar)'; Pourquoi = 'Even with Game Bar off, a small "Game Bar Presence Writer" process launches with every game to tell the Xbox network what you are playing. We disable its COM class (ActivationType = 0): it no longer launches. We never rename the executable, an update would restore it and break Game Bar.'; Attention = 'Your Xbox friends no longer see "playing ...". Game Bar (Win+G) still works.' }
    'jeu-svchost' = @{ Titre = "Group system services (SvcHostSplitThreshold, $RamGo GB of RAM detected)"; Pourquoi = 'Since Windows 10, every service gets its own process once you have more than 3.5 GB of RAM. Raising the threshold to your real RAM groups them back together like before: fewer processes in Task Manager. Verdict after review: placebo, nobody has measured a significant FPS or RAM gain (a few dozen MB). Unchecked by default, check it if you like a shorter Task Manager.'; Attention = 'A service that crashes takes down the others in the same process with it, like on Windows 7.' }
    'jeu-timer' = @{ Titre = 'Allow fine timer resolution for games (GlobalTimerResolutionRequests)'; Pourquoi = 'Since Windows 11, an app that requests a 0.5 ms timer only gets it for itself and only in the foreground. This key restores the Windows 10 behavior: the request applies to the whole system. A game that requests a fine timer keeps it even when another window comes in front.'; Attention = 'Idle power draw goes very slightly higher when a program requests a fine timer.' }
    'jeu-souris' = @{ Titre = 'Turn off mouse acceleration (Enhance pointer precision)'; Pourquoi = 'With acceleration, the distance the cursor travels depends on how fast you move your hand: the same hand movement never gives the same on-screen movement. Your muscle memory cannot learn anything. Every gamer turns it off, it is the first thing to do.'; Attention = 'The cursor needs a bit more hand movement on the desktop. Raise your mouse DPI if needed.' }
    'jeu-hiber' = @{ Titre = 'Turn off hibernation and fast startup'; Pourquoi = 'Frees hiberfil.sys (several GB) and forces a real restart on every boot instead of reloading a frozen image. A real boot avoids drivers ending up in a weird state after an update.'; Attention = 'No more hibernation (regular sleep stays).' }
    'jeu-parking' = @{ Titre = 'Disable core parking'; Pourquoi = 'Windows can put idle cores to sleep, and takes a moment to wake them when a game needs them. On a Ryzen with the AMD chipset driver or a recent Intel CPU, Windows handles this well on its own. Mostly useful on older CPUs or laptops.'; Attention = 'Idle power draw a bit higher.' }
    'jeu-usb' = @{ Titre = 'Turn off USB selective suspend'; Pourquoi = 'Windows turns off idle USB ports to save 0.1 W. A mouse or keyboard that falls asleep can take a few milliseconds to respond. On a desktop PC, there is no point saving that.'; Attention = 'On a laptop, a bit less battery life.' }
    'jeu-pcie' = @{ Titre = 'Turn off PCI Express power saving (ASPM)'; Pourquoi = 'The PCIe link of the graphics card and SSD can drop to low power at idle, with a wake delay. On a desktop PC, we leave the link always open.'; Attention = 'On a laptop, a bit less battery life.' }
    'jeu-reveil' = @{ Titre = 'Block wake timers from taking the PC out of sleep'; Pourquoi = 'Windows Update and some tasks can wake the PC in the middle of the night to do their work. We turn off wake timers in the active power plan.'; Attention = 'The PC no longer wakes on its own for an update: it happens when you turn it on.' }
    'jeu-usb3' = @{ Titre = 'Turn off USB 3 link power management (Link Power Management)'; Pourquoi = 'Like selective suspend but for the USB 3 layer: the link drops to low power between transfers. An external drive or a USB controller can stall for a fraction of a second on wake. On a desktop we keep the link at full power.'; Attention = 'On a laptop, a bit less battery life.' }
    'jeu-hdd' = @{ Titre = 'Never stop the hard drive (detected: HDD system disk)'; Pourquoi = 'Windows stops the hard drive after 20 minutes without access, and spinning it back up causes a 2 to 5 second freeze. On an HDD we keep the platter spinning.'; Attention = 'The disk spins permanently: a bit more noise and wear.' }
    'jeu-pilotes' = @{ Titre = 'Stop Windows Update from overwriting your drivers'; Pourquoi = 'Windows Update sometimes installs an older or generic graphics driver over the one you set up (NVCleanstall, AMD). This key keeps you in control.'; Attention = 'Windows no longer updates any driver on its own, you manage them yourself (Snappy Driver Installer, vendor tools).' }
    'jeu-nouveautes' = @{ Titre = 'Stop receiving Windows features early (Continuous Innovation)'; Pourquoi = 'Windows 11 offers "get the latest updates as soon as they are available": these are new features pushed before their official release, the ones most likely to break a driver or an anti-cheat. We stay on stable versions. Security fixes still arrive the same.'; Attention = 'New features arrive a few weeks or months later.' }
    'jeu-f8' = @{ Titre = 'Restore the F8 boot menu (Safe Mode)'; Pourquoi = 'Windows 11 hides the advanced boot menu. Without it, entering Safe Mode requires making the boot fail three times in a row. With this option, F8 at startup is enough.'; Attention = 'Startup takes a fraction of a second longer (the menu waits for F8).' }
    'net-alim' = @{ Titre = 'Stop Windows from turning off the network card to save power'; Pourquoi = 'Windows can turn off the card at idle, and it takes a second to come back: that is the "network dropped for 2 seconds" in the middle of a match, especially after sleep.'; Attention = 'On a laptop, a bit less battery life.' }
    'net-eee' = @{ Titre = 'Turn off Energy Efficient Ethernet / Green Ethernet'; Pourquoi = 'Same logic: the network chip sleeps between packets to save a few milliwatts, and wakes up with a delay. While gaming you want the card always awake.'; Attention = 'Nothing visible.' }
    'net-moderation' = @{ Titre = 'Interrupt Moderation set to Medium (not Disabled)'; Pourquoi = 'The card groups its interrupts so it does not wake the CPU on every packet. Medium keeps the CPU available for the game while still delivering packets fast. Turning it off entirely does the opposite of what the tutorials promise: more interrupts, more CPU time stolen from the game (measured with xperf by djdallmann on game UDP traffic).'; Attention = 'If your card does not have this option (often the case on Realtek), nothing happens.' }
    'net-decouverte' = @{ Titre = 'Uncheck the network discovery protocols (LLDP, link layer topology)'; Pourquoi = 'Three protocols used to draw a map of the local network. They run on every packet for nothing. TCP/IPv4 and IPv6 stay on.'; Attention = 'The Network and Sharing Center "network map" no longer sees other devices. Nobody uses it.' }
    'net-partage' = @{ Titre = 'Uncheck Microsoft file and printer sharing'; Pourquoi = 'The SMB protocol, both server and client side. Only useful if you share folders between PCs at home or with a NAS.'; Attention = 'No more access to other PCs'' shared folders or to a NAS, and others no longer see yours. Check this only if you have none of that.' }
    'net-qos' = @{ Titre = 'Uncheck the QoS Packet Scheduler'; Pourquoi = 'QoS prioritizes certain packets when the line is saturated. On a normal connection it does nothing. If you get lag in games while another device is downloading, this is exactly what you should turn back on.'; Attention = 'No more prioritization when the line saturates.' }
    'conf-bing' = @{ Titre = 'No more Bing web results in the Start menu'; Pourquoi = 'Every keystroke in Start goes to Bing before searching your files. We search locally only: faster and nothing gets sent out.'; Attention = 'No more web suggestions in Start.' }
    'conf-explorateur' = @{ Titre = 'File Explorer: visible file extensions, open to "This PC"'; Pourquoi = 'Seeing ".exe" and ".txt" helps you avoid launching a fake file, and "This PC" is more useful than the home view with recent files.'; Attention = '' }
    'conf-menu-classique' = @{ Titre = 'Full right-click menu directly (no "Show more options")'; Pourquoi = 'The Windows 11 right-click menu hides half its entries behind "Show more options". This key restores the full Windows 10 menu in a single click. File Explorer restarts to apply it.'; Attention = 'The menu is longer and without modern icons. The Windows 11 entries (Copy as path, Share) stay accessible with Shift+right-click.' }
    'conf-fin-tache' = @{ Titre = '"End task" button in the taskbar right-click menu'; Pourquoi = 'Right-clicking a taskbar icon offers "End task": a frozen program dies without opening Task Manager. A Windows 11 option (Settings > System > For developers), just hidden.'; Attention = '' }
    'conf-ducking' = @{ Titre = 'Sound: "Do nothing" when Discord or a call opens'; Pourquoi = 'By default Windows lowers every other sound by 80% as soon as a communication app (Discord, Teams) grabs the microphone. The game goes silent in voice chat. This is the Communications tab of the Sound window, set to "Do nothing".'; Attention = '' }
    'conf-edge' = @{ Titre = 'Edge: no more startup preload or background process'; Pourquoi = 'Edge half-launches at Windows startup (Startup Boost) and stays in memory after you close its window (Background Mode), even if you use another browser. Two policies documented by Microsoft.'; Attention = 'Edge takes one more second to open the first time.' }
    'conf-eclairage' = @{ Titre = 'Turn off Dynamic Lighting'; Pourquoi = 'Windows 11 drives the RGB LEDs of compatible devices itself, and its service runs even without LEDs. If you have iCUE, OpenRGB or Armoury Crate, they fight with it.'; Attention = 'Windows no longer manages your LEDs: your vendor software (or nothing) takes over.' }
    'conf-accueil-parametres' = @{ Titre = 'Hide the Settings "Home" page (Microsoft 365, Game Pass ads)'; Pourquoi = 'The first page of Settings is a showcase: Microsoft 365 subscription, Game Pass, account. We open straight to System instead.'; Attention = 'The "Recent devices" card and the account shortcut on that page disappear with it.' }
    'conf-reserve' = @{ Titre = 'Free up Windows Update reserved storage (about 7 GB)'; Pourquoi = 'Windows sets 7 GB aside for its updates. With a disk that has room, updates work just as well without that reserve.'; Attention = 'A big update can fail if the disk is nearly full (Windows will tell you).' }
    'conf-menus' = @{ Titre = 'Instant menus (MenuShowDelay 0, MouseHoverTime 10)'; Pourquoi = 'Windows waits 400 ms before opening a submenu. We set it to 0.'; Attention = '' }
    'conf-demarrage' = @{ Titre = 'Launch startup programs without delay (StartupDelayInMSec 0)'; Pourquoi = 'Windows delays startup programs by 10 seconds. We remove the delay.'; Attention = 'If you have many startup programs, the desktop can feel less responsive for the first few seconds.' }
    'conf-fin' = @{ Titre = 'Close stuck programs without asking (AutoEndTasks)'; Pourquoi = 'At shutdown, Windows kills programs that stop responding instead of showing the "this program is preventing shutdown" window.'; Attention = 'An unsaved document in a frozen program is lost at shutdown.' }
    'conf-transparence' = @{ Titre = 'Turn off transparency'; Pourquoi = 'The blur effects behind the Start menu and taskbar. Costs a bit of GPU constantly.'; Attention = 'A flatter interface.' }
    'conf-animations' = @{ Titre = 'Turn off window animations'; Pourquoi = 'Windows appear instantly instead of sliding in. Windows feels faster because it no longer waits for the animation to finish.'; Attention = 'A blunter interface. Personal taste.' }
    'conf-accessibilite' = @{ Titre = 'Turn off accessibility shortcuts (Sticky Keys, Filter Keys)'; Pourquoi = 'Pressing Shift 5 times during a game opens the Sticky Keys window. Never again.'; Attention = '' }
    'conf-acces-rapide' = @{ Titre = 'File Explorer: remove "Quick access" from the left pane (HubMode)'; Pourquoi = 'File Explorer''s left pane starts with "Quick access" and its recent folders. This key removes it, the pane starts at "This PC". Source: tenforums.com, tutorial 4844 (Shawn Brink, 2018), still valid on Windows 11.'; Attention = 'No more "Quick access" shortcuts or recent folders in the pane.' }
    'conf-corbeille' = @{ Titre = 'File Explorer: Recycle Bin in "This PC"'; Pourquoi = 'Adds the Recycle Bin next to the drives in "This PC" and in the left pane. Source: howtogeek.com, article 282820 (Walter Glenn).'; Attention = 'Nothing, the key removes cleanly on rollback.' }
    'conf-vlc-pistes' = @{ Titre = 'VLC: right-click "VLC with mixed audio tracks" on .mp4 files'; Pourquoi = 'Adds a right-click entry on .mp4 files that launches VLC with all audio tracks mixed together (--sout-all). Useful for gameplay recordings with voice and game audio on two separate tracks. Requires VLC installed at C:\Program Files\VideoLAN.'; Attention = 'One more entry in the .mp4 right-click menu.' }
    'adv-priosep' = @{ Titre = 'Win32PrioritySeparation = 0x26 (short, variable quantum, x3 boost for the foreground)'; Pourquoi = 'Sets how the scheduler splits CPU time between the foreground program and the rest. 0x26 gives short, variable time slices with a x3 boost for the game. A real effect on the split, no reproducible FPS gain has been published: keep it only if you measure an improvement (CapFrameX, 3 runs).'; Attention = 'Background tasks (downloads, encoding) progress more slowly while you play.' }
    'adv-throttling' = @{ Titre = 'Turn off Power Throttling (PowerThrottlingOff)'; Pourquoi = 'Windows throttles programs it considers "in the background" (EcoQoS) to save power. On a desktop PC we do not want to throttle anything: Discord, your launcher, the overlay run at full speed even behind the game.'; Attention = 'On a laptop, less battery life. On a desktop, nothing.' }
    'adv-nagle' = @{ Titre = 'Turn off Nagle''s algorithm (TcpAckFrequency, TCPNoDelay) on the active card'; Pourquoi = 'Nagle groups small TCP packets before sending them, and delays acknowledgments. A few ms saved on a game using TCP (MMOs, some Unity games). Zero effect on a game using UDP, which is nearly every FPS.'; Attention = 'A few more small packets on the line. Nothing visible.' }
    'adv-dyntick' = @{ Titre = 'Turn off dynamic tick (bcdedit disabledynamictick)'; Pourquoi = 'The kernel stops its clock when nothing happens and restarts it on demand. With a 0.5 ms timer this can drift. Check this only if you see micro-stutter that RivaTuner confirms, and uncheck it if nothing changes.'; Attention = 'Idle power draw a bit higher.' }
    'jeu-mpo' = @{ Titre = 'Turn off Multiplane Overlay (MPO, OverlayTestMode = 5)'; Pourquoi = 'MPO lets the graphics card draw some windows directly, bypassing the Windows compositor (DWM). It is the cause of the black screens, flickering and windowed stutter that NVIDIA documents (article 5157, 2022) and that AMD cards know too. Off, DWM composes everything: zero effect in fullscreen, no more surprises in windowed or multi-monitor. NVCleanstall sets the same key with its "Disable MPO" box.'; Attention = 'A video in a window costs a bit more GPU (no more hardware overlay). On 24H2 and later, Windows sometimes ignores the key: then nothing changes.' }
    'adv-boost' = @{ Titre = 'CPU boost mode set to Aggressive (PERFBOOSTMODE)'; Pourquoi = 'The power plan boost mode decides how fast the CPU ramps its frequency when load arrives. Aggressive ramps it up right away instead of waiting. Intel key: on AMD the firmware handles boost.'; Attention = 'On a laptop: heat and battery for nothing. On a desktop, slightly more idle power.' }
    'adv-rawmouse' = @{ Titre = 'RawMouseThrottleDuration = 8 (mouse report batching)'; Pourquoi = 'Windows groups mouse Raw Input reports into time windows. With a mouse at 1000 Hz or more, a shorter window delivers movement to the game sooner. Documented range is 3 to 20. On recent Windows 11 builds the default is already 8: in that case the key changes nothing (check on your machine with ?, the previous value is written to bagarre.log). Verify with MouseTester: zero missed reports.'; Attention = 'No known downside. If the cursor feels off, R restores the previous value.' }
    'adv-fth' = @{ Titre = 'Turn off the Fault Tolerant Heap (FTH)'; Pourquoi = 'When a program crashes several times, Windows relaunches it with a "tolerant", slower memory allocator, without telling you. A game that crashed three times then runs throttled. With this off, it still crashes the same way but runs at full speed the rest of the time. Documented by Microsoft (FTH, Win32 apps).'; Attention = 'An old unstable program that FTH was keeping alive can start crashing again.' }
    'adv-llmnr' = @{ Titre = 'Turn off LLMNR (multicast name resolution)'; Pourquoi = 'When a name is not found by DNS, Windows shouts it out over multicast on the local network (LLMNR). This is a known entry point for credential interception (Responder) and pointless network noise. A standard enterprise security recommendation.'; Attention = 'Typing \\PC-NAME to reach another PC at home may stop working (use its IP or enable mDNS on the NAS side).' }
    'nv-telemetrie' = @{ Titre = 'Turn off NVIDIA telemetry'; Pourquoi = 'The driver sends statistics to NVIDIA. Two keys, no effect on gaming.'; Attention = '' }
    'nv-pstate' = @{ Titre = 'Lock the card at P0 (DisableDynamicPstate)'; Pourquoi = 'At idle the card drops its clock speed, and takes a few frames to ramp back up when a scene loads all at once: that is the micro-freeze after a menu or a loading screen. This key keeps it at max clock as long as Windows runs. Verifiable with nvidia-smi (Perf P0). The "Prefer maximum performance" setting in the control panel does almost the same thing without a restart, this key is one notch further.'; Attention = 'Card runs hotter and draws more power at idle, fans that no longer stop on some cards.' }
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

# Les résolveurs testés, dans l'ordre d'affichage. Cle sert au logo et à la note traduite, Serveurs[0] est celui mesuré.
function Dns-Candidats($adapt) {
    @(
        @{ Cle = 'actuel';     Nom = 'Actuel (box / FAI)';   Serveurs = @(Dns-Actuels $adapt) }
        @{ Cle = 'quad9';      Nom = 'Quad9';                Serveurs = @('9.9.9.9', '149.112.112.112') }
        @{ Cle = 'cloudflare'; Nom = 'Cloudflare';           Serveurs = @('1.1.1.1', '1.0.0.1') }
        @{ Cle = 'google';     Nom = 'Google';               Serveurs = @('8.8.8.8', '8.8.4.4') }
        @{ Cle = 'adguard';    Nom = 'AdGuard DNS';          Serveurs = @('94.140.14.14', '94.140.15.15') }
        @{ Cle = 'opendns';    Nom = 'OpenDNS';              Serveurs = @('208.67.222.222', '208.67.220.220') }
        @{ Cle = 'mullvad';    Nom = 'Mullvad';              Serveurs = @('194.242.2.2') }
        @{ Cle = 'dns0';       Nom = 'dns0.eu';              Serveurs = @('193.110.81.0', '185.253.5.0') }
        @{ Cle = 'controld';   Nom = 'Control D';            Serveurs = @('76.76.2.0', '76.76.10.0') }
    )
}

# Résout 6 noms courants sur un serveur, 3 tours, garde la médiane en ms (nombre, jamais une chaîne : la virgule
# décimale française cassait la conversion). Un serveur injoignable au premier tour n'a pas droit aux deux autres.
function Dns-Mesurer-Un($serveur) {
    $noms = 'youtube.com', 'steampowered.com', 'discord.com', 'twitch.tv', 'epicgames.com', 'wikipedia.org'
    $temps = @()
    foreach ($tour in 1..3) {
        foreach ($d in $noms) {
            $t = Measure-Command { try { Resolve-DnsName -Name $d -Server $serveur -Type A -DnsOnly -NoHostsFile -ErrorAction Stop | Out-Null } catch {} }
            $temps += [double]$t.TotalMilliseconds
            Rafraichir
        }
        $tri = @($temps | Sort-Object)
        if ($tour -eq 1 -and $tri[[int]($tri.Count / 2)] -gt 800) { break }
    }
    $tri = @($temps | Sort-Object)
    [math]::Round([double]$tri[[int]($tri.Count / 2)], 1)
}

# Tous les candidats d'un coup (le journal, la fenêtre mesure un par un pour afficher au fur et à mesure)
function Dns-Mesurer($adapt) {
    $resultats = @()
    foreach ($c in (Dns-Candidats $adapt)) {
        if (-not $c.Serveurs[0]) { continue }
        $mediane = Dns-Mesurer-Un $c.Serveurs[0]
        $resultats += [pscustomobject]@{ Cle = $c.Cle; Nom = $c.Nom; Serveurs = $c.Serveurs; Mediane = $mediane; Actuel = ($c.Cle -eq 'actuel') }
        Log ("dns       {0,-20} {1,7} ms" -f $c.Nom, $mediane)
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
                    if ($v.serveurs -and $v.serveurs.Count -gt 0) { Set-DnsClientServerAddress -InterfaceIndex $v.ifIndex -ServerAddresses $v.serveurs }
                    else { Set-DnsClientServerAddress -InterfaceIndex $v.ifIndex -ResetServerAddresses }
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

# ===== 40-collecte.ps1 =====
# ---------------------------------------------------------------------------
# Audit IA : photographie du PC dans un rapport texte anonymisé (ex collecte.ps1). Ne modifie rien.
# ---------------------------------------------------------------------------
function Collecter-Rapport($Sortie) {
$ErrorActionPreference = 'SilentlyContinue'
$Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$sb = New-Object System.Text.StringBuilder
function Titre($t) { [void]$sb.AppendLine(''); [void]$sb.AppendLine("=== $t ==="); Write-Host "  $t"; Rafraichir }
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
Log ((Msg 'rapportEcrit') -f $Sortie, [math]::Round((Get-Item $Sortie).Length / 1KB))
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
# Textes de l'interface, français et anglais. Les tutos sont dans $Textes (un fichier par page, balisé :
# "## " ouvre une carte, "@Id, Id2" pose des boutons, "! " une mise en garde, "> " une commande, "- " une puce),
# les items dans le catalogue (français) et $TraductionsEn (anglais).
# ---------------------------------------------------------------------------
$PagesNoms = 'Accueil', 'Installation', 'Facile', 'Optis', 'Nvidia', 'Dur', 'Maintenance', 'Dns', 'Audit'
$UI = @{
    fr = @{
        nav      = 'Accueil', 'Installation', 'Facile', 'Le script à cocher', 'NVIDIA', 'Dur', 'Maintenance', 'DNS', 'Audit IA'
        resume   = '', 'Windows propre, mises à jour, pilotes', 'débloat en deux clics, librairies, son', 'services, vie privée, jeu, réseau, confort', 'pilote nu, Panneau de configuration OG', 'une chose à la fois, tu mesures', 'nettoyer et vérifier, des mois après', 'le résolveur le plus rapide depuis chez toi', 'une IA vérifie ton PC'
        titres   = @{
            Accueil = 'Tu viens de réinstaller Windows 11 ?'; Installation = 'Windows propre, mises à jour, pilotes'
            Facile = 'Débloat en deux clics, librairies, son'; Optis = 'Le script à cocher'
            Nvidia = 'Le pilote nu, puis le Panneau de configuration OG'; Dur = 'Une chose à la fois, tu mesures'
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
        dnsSelection = 'Clique une ligne de résultat.'; dnsBox = 'box'; dnsRapide = 'le plus rapide'; dnsTest = 'test en cours'
        dnsNotes = @{ actuel = 'ce que tu as aujourd hui, ta box ou ton FAI'; quad9 = 'bloque les sites malveillants, pas de journal'; cloudflare = 'souvent le plus rapide, aucun filtre'; google = 'rapide, garde des journaux'; adguard = 'bloque les pubs et les traqueurs'; opendns = 'Cisco, filtre familial en option'; mullvad = 'pas de journal, serveurs en Europe'; dns0 = 'européen, bloque les sites malveillants'; controld = 'bloque les sites malveillants' }
        preset = 'Preset'; presetRecommande = 'Recommandé'; presetMinimal = 'Minimal : rien à perdre'; presetAucun = 'Tout décocher'; presetWindows = 'Windows par défaut : tout remettre'; presetPerso = 'Personnalisé'
        presetTips = @{ recommande = 'Les cases sûres, cochées à l ouverture.'; minimal = 'Seulement les cases dont la contrepartie est vide : rien à perdre.'; aucun = 'Aucune case cochée.'; windows = 'Remet chaque réglage déjà appliqué à sa valeur d avant, DNS compris.' }
        ou = 'ou'
        collecte = 'Collecte en cours, environ 30 secondes...'; promptCopie = 'Prompt copié dans le presse-papiers. Colle-le dans ton IA avec rapport-pc.txt.'
        commandeCopiee = 'Commande copiée. Colle-la dans un Terminal pour rouvrir bagarre.'
        pasRapport = "Pas encore de rapport : bouton 1 d'abord."; pasJournal = 'Pas encore de journal.'
        dejaApplique = '{0} réglages déjà appliqués sur ce PC (bagarre-avant.json). Tout remettre les restaure.'
        ouverte = 'Fenêtre ouverte. Si tu ne la vois pas, regarde la barre des tâches : elle peut être derrière ce terminal.'
        filtrer = 'Chercher une ligne'; coches = 'cochées'
        detection = 'Détection de ce qui est déjà en place sur ce PC...'
        detectionFin = '{0} réglages déjà en place, décochés et marqués "déjà fait". Le reste est à faire.'
        vieuxTitre = 'Ton installation Windows a {0}.'
        vieuxTexte = "C'est pas que je suis pas sûr de mon script, mais on sait jamais. Il faut toujours se protéger."
        vieuxRestauration = 'Créer un point de restauration'; vieuxSauvegarde = 'Sauvegarder mes fichiers'; vieuxContinuer = 'Continuer quand même'
        an = 'an', 'ans'; mois = 'mois', 'mois'; jour = 'jour', 'jours'; et = 'et'
    }
    en = @{
        nav      = 'Home', 'Install', 'Easy', 'The checkbox script', 'NVIDIA', 'Hard', 'Maintenance', 'DNS', 'AI audit'
        resume   = '', 'clean Windows, updates, drivers', 'debloat in two clicks, libraries, sound', 'services, privacy, gaming, network, comfort', 'bare driver, OG Control Panel', 'one thing at a time, you measure', 'clean and check, months later', 'the fastest resolver from your place', 'an AI checks your PC'
        titres   = @{
            Accueil = 'Just reinstalled Windows 11?'; Installation = 'Clean Windows, updates, drivers'
            Facile = 'Debloat in two clicks, libraries, sound'; Optis = 'The checkbox script'
            Nvidia = 'The bare driver, then the OG Control Panel'; Dur = 'One thing at a time, you measure'
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
        dnsSelection = 'Click a result line.'; dnsBox = 'router'; dnsRapide = 'fastest'; dnsTest = 'testing'
        dnsNotes = @{ actuel = 'what you have today, your router or your ISP'; quad9 = 'blocks malicious sites, no logs'; cloudflare = 'often the fastest, no filtering'; google = 'fast, keeps logs'; adguard = 'blocks ads and trackers'; opendns = 'Cisco, optional family filter'; mullvad = 'no logs, servers in Europe'; dns0 = 'European, blocks malicious sites'; controld = 'blocks malicious sites' }
        preset = 'Preset'; presetRecommande = 'Recommended'; presetMinimal = 'Minimal: nothing to lose'; presetAucun = 'Untick everything'; presetWindows = 'Windows default: restore everything'; presetPerso = 'Custom'
        presetTips = @{ recommande = 'The safe boxes, ticked when the window opens.'; minimal = 'Only the boxes whose tradeoff is empty: nothing to lose.'; aucun = 'No box ticked.'; windows = 'Puts every setting already applied back to its previous value, DNS included.' }
        ou = 'or'
        collecte = 'Collecting, about 30 seconds...'; promptCopie = 'Prompt copied to the clipboard. Paste it into your AI along with rapport-pc.txt.'
        commandeCopiee = 'Command copied. Paste it into a Terminal to reopen bagarre.'
        pasRapport = 'No report yet: button 1 first.'; pasJournal = 'No log yet.'
        dejaApplique = '{0} settings already applied on this PC (bagarre-avant.json). Restore puts them back.'
        ouverte = 'Window open. If you do not see it, check the taskbar: it may be behind this terminal.'
        filtrer = 'Find a line'; coches = 'checked'
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
    BtnDetecter = @{ Zone = 'Barre'; T = @{ fr = 'Re-détecter ce PC'; en = 'Re-detect this PC' }; Tip = @{ fr = 'Relit le PC : les réglages déjà en place sont décochés et marqués "déjà fait".'; en = 'Reads the PC again: settings already in place get unchecked and marked "already done".' }; Action = { Detecter-Tout } }
    BtnRestaurer = @{ Zone = 'Barre'; T = @{ fr = 'Tout remettre comme avant'; en = 'Restore everything' }; Tip = @{ fr = 'Remet chaque réglage à sa valeur d avant, DNS compris.'; en = 'Puts every setting back to its previous value, DNS included.' }; Action = { Restaurer-Demander } }
    BtnReseau = @{ Zone = 'Volet'; T = @{ fr = 'Lire : la carte réseau à la main'; en = 'Read: the network card by hand' }; Tip = @{ fr = 'Le groupe Carte réseau fait tout seul. Ce tuto sert si tu veux vérifier ou le faire à la main.'; en = 'The Network card group does it all. This guide is for checking or doing it by hand.' }; Action = { Opti-Montrer $Bagarre.L.reseauTitre $Textes[$Bagarre.Langue]['reseau'] $null } }
    BtnImgProtocoles = @{ Zone = 'Volet'; T = @{ fr = 'Voir la capture : protocoles'; en = 'See the screenshot: protocols' }; Tip = @{ fr = 'La liste des protocoles de la carte, ce qu on décoche.'; en = 'The card protocol list, what gets unticked.' }; Action = { Image-Ouvrir 'reseau-protocoles.png' } }
    BtnImgAvance = @{ Zone = 'Volet'; T = @{ fr = 'Voir la capture : onglet Avancé'; en = 'See the screenshot: Advanced tab' }; Tip = @{ fr = 'L onglet Avancé du pilote réseau.'; en = 'The Advanced tab of the network driver.' }; Action = { Image-Ouvrir 'reseau-avance.png' } }
    BtnJournal = @{ Zone = 'Volet'; T = @{ fr = 'Ouvrir le journal (bagarre.log)'; en = 'Open the log (bagarre.log)' }; Tip = @{ fr = 'Le détail de tout ce qui a été modifié, avec les valeurs d avant.'; en = 'The detail of everything changed, with the previous values.' }; Action = { Journal-Ouvrir } }

    BtnNvclean = @{ Logo = 'techpowerup'; T = @{ fr = 'Installer NVCleanstall'; en = 'Install NVCleanstall' }; Tip = @{ fr = 'Installe via winget. Le pilote NVIDIA nu, sans NVIDIA App.'; en = 'Installs through winget. The bare NVIDIA driver, without the NVIDIA App.' }; Action = { Winget-Installer 'NVCleanstall' 'TechPowerUp.NVCleanstall' } }
    BtnPanneau = @{ Logo = 'nvidia'; T = @{ fr = 'Installer le Panneau de configuration NVIDIA'; en = 'Install the NVIDIA Control Panel' }; Tip = @{ fr = 'Le Panneau OG, depuis le Store. À refaire après chaque installation propre du pilote.'; en = 'The OG Control Panel, from the Store. Redo it after every clean driver install.' }; Action = { Winget-Installer 'NVIDIA Control Panel' '9NF8H0H7WMLT' 'msstore' } }
    BtnAfterburner = @{ Logo = 'msi'; T = @{ fr = 'Installer MSI Afterburner + RivaTuner'; en = 'Install MSI Afterburner + RivaTuner' }; Tip = @{ fr = 'Installe via winget. Pas pour overclocker : pour VOIR le temps d image et poser un cap de FPS.'; en = 'Installs through winget. Not for overclocking: to SEE frame times and set an FPS cap.' }; Action = { Winget-Installer 'MSI Afterburner + RivaTuner' 'Guru3D.Afterburner', 'Guru3D.RTSS' } }
    BtnImgNvclean = @{ T = @{ fr = 'Voir la capture : quoi cocher'; en = 'See the screenshot: what to tick' }; Tip = @{ fr = 'Les cases à cocher dans NVCleanstall, plus la ligne MPO.'; en = 'The boxes to tick in NVCleanstall, plus the MPO line.' }; Action = { Image-Ouvrir 'nvcleanstall.png' } }

    BtnThreadPilot = @{ Logo = 'threadpilot'; T = @{ fr = 'Installer ThreadPilot'; en = 'Install ThreadPilot' }; Tip = @{ fr = 'Installe via winget. Open source, gratuit. Windows 11 seulement.'; en = 'Installs through winget. Open source, free. Windows 11 only.' }; Action = { Winget-Installer 'ThreadPilot' 'PrimeBuild.ThreadPilot' } }
    BtnLasso = @{ Logo = 'bitsum'; T = @{ fr = 'Installer Process Lasso'; en = 'Install Process Lasso' }; Tip = @{ fr = 'Installe via winget. Gratuit avec un rappel d achat, version Pro payante.'; en = 'Installs through winget. Free with a purchase reminder, paid Pro edition.' }; Action = { Winget-Installer 'Process Lasso' 'BitSum.ProcessLasso' } }
    BtnIslc = @{ Logo = 'wagnardsoft'; T = @{ fr = 'Installer ISLC'; en = 'Install ISLC' }; Tip = @{ fr = 'Installe via winget. 16 Go de RAM et des jeux récents seulement.'; en = 'Installs through winget. 16 GB of RAM and recent games only.' }; Action = { Winget-Installer 'ISLC' 'Wagnardsoft.ISLC' } }
    BtnAutoGpu = @{ Logo = 'valleyofdoom'; T = @{ fr = 'Ouvrir le dépôt AutoGpuAffinity'; en = 'Open the AutoGpuAffinity repo' }; Tip = @{ fr = 'Ouvre le dépôt GitHub. Long (1 h), sur un PC déjà stable.'; en = 'Opens the GitHub repo. Long (1 h), on an already stable PC.' }; Action = { Ouvrir 'https://github.com/valleyofdoom/AutoGpuAffinity' } }
    BtnAmd = @{ T = @{ fr = 'Ouvrir la page pilotes AMD'; en = 'Open the AMD drivers page' }; Tip = @{ fr = 'Le site AMD, pilote seul.'; en = 'AMD site, driver only.' }; Action = { Ouvrir 'https://www.amd.com/en/support/download/drivers.html' } }

    BtnAutoruns = @{ Logo = 'microsoft'; T = @{ fr = 'Installer Autoruns'; en = 'Install Autoruns' }; Tip = @{ fr = 'Installe via winget. Tout ce qui se lance au démarrage. Décoche, ne supprime pas.'; en = 'Installs through winget. Everything that starts with Windows. Untick, do not delete.' }; Action = { Winget-Installer 'Autoruns' 'Microsoft.Sysinternals.Autoruns' } }
    BtnCleanmgr = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir le Nettoyage de disque'; en = 'Open Disk Cleanup' }; Tip = @{ fr = 'cleanmgr, puis Nettoyer les fichiers système : anciennes mises à jour, corbeille.'; en = 'cleanmgr, then Clean up system files: old updates, recycle bin.' }; Action = { Start-Process cleanmgr | Out-Null; Log 'console   cleanmgr' } }
    BtnDismNettoyer = @{ Logo = 'microsoft'; T = @{ fr = 'Nettoyer les vieilles mises à jour (DISM)'; en = 'Clean old updates (DISM)' }; Tip = @{ fr = 'Dism /StartComponentCleanup dans une console. Jamais /ResetBase : tu perdrais la désinstallation des mises à jour.'; en = 'Dism /StartComponentCleanup in a console. Never /ResetBase: you would lose update uninstall.' }; Action = { Console-Lancer 'DISM StartComponentCleanup' 'Dism /Online /Cleanup-Image /StartComponentCleanup' } }
    BtnStockage = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir l Assistant de stockage'; en = 'Open Storage Sense' }; Tip = @{ fr = 'Paramètres > Système > Stockage > Assistant de stockage.'; en = 'Settings > System > Storage > Storage Sense.' }; Action = { Ouvrir 'ms-settings:storagesense' } }
    BtnCrystal = @{ Logo = 'crystaldiskinfo'; T = @{ fr = 'Installer CrystalDiskInfo'; en = 'Install CrystalDiskInfo' }; Tip = @{ fr = 'Installe via winget. Santé et température des disques.'; en = 'Installs through winget. Disk health and temperature.' }; Action = { Winget-Installer 'CrystalDiskInfo' 'CrystalDewWorld.CrystalDiskInfo' } }
    BtnReveil = @{ Logo = 'microsoft'; T = @{ fr = 'Voir ce qui réveille le PC'; en = 'See what wakes the PC' }; Tip = @{ fr = 'powercfg /lastwake, /waketimers, /requests dans une console.'; en = 'powercfg /lastwake, /waketimers, /requests in a console.' }; Action = { Console-Lancer 'powercfg' 'powercfg /lastwake; Write-Host ""; powercfg /waketimers; Write-Host ""; powercfg /requests' } }
    BtnEvenements = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir l Observateur d événements'; en = 'Open Event Viewer' }; Tip = @{ fr = 'Journaux Windows > Système, source WHEA-Logger.'; en = 'Windows Logs > System, source WHEA-Logger.' }; Action = { Ouvrir 'eventvwr.msc' } }
    BtnWlan = @{ Logo = 'microsoft'; T = @{ fr = 'Générer le rapport Wi-Fi'; en = 'Generate the Wi-Fi report' }; Tip = @{ fr = 'netsh wlan show wlanreport, puis ouvre le rapport HTML.'; en = 'netsh wlan show wlanreport, then opens the HTML report.' }; Action = { Console-Lancer 'wlanreport' 'netsh wlan show wlanreport; Start-Process "$env:ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html"' -Fermer } }
    BtnDefenderEnregistrer = @{ Logo = 'microsoft'; T = @{ fr = 'Enregistrer Defender pendant que tu joues'; en = 'Record Defender while you play' }; Tip = @{ fr = 'New-MpPerformanceRecording : joue dix minutes, puis Entrée dans la console. Le rapport des fichiers et dossiers les plus scannés s affiche à la suite.'; en = 'New-MpPerformanceRecording: play ten minutes, then press Enter in the console. The report of the most scanned files and folders follows.' }; Action = { Console-Lancer 'Defender' 'New-MpPerformanceRecording -RecordTo C:\defender.etl; Get-MpPerformanceReport -Path C:\defender.etl -TopFiles 10 -TopPaths 10' } }
    BtnDefenderExclusions = @{ Logo = 'microsoft'; T = @{ fr = 'Ouvrir les exclusions Defender'; en = 'Open Defender exclusions' }; Tip = @{ fr = 'Sécurité Windows > Protection contre les virus > Paramètres > Exclusions.'; en = 'Windows Security > Virus protection > Settings > Exclusions.' }; Action = { Ouvrir 'windowsdefender://threatsettings' } }

    BtnDnsTester = @{ Principal = $true; T = @{ fr = 'Tester les DNS'; en = 'Test the DNS servers' }; Tip = @{ fr = 'Neuf résolveurs, une minute au plus. Ne change rien.'; en = 'Nine resolvers, one minute at most. Changes nothing.' }; Action = { Dns-Tester } }
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
      <Setter Property="ToolTipService.InitialShowDelay" Value="250"/>
      <Setter Property="ToolTipService.ShowDuration" Value="30000"/>
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
    <!-- bulle d'aide : carte sombre flottante, ombre, liseré accent, sans le cadre système -->
    <Style TargetType="ToolTip">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="#EAE5F3"/>
      <Setter Property="FontSize" Value="12.5"/>
      <Setter Property="HasDropShadow" Value="False"/>
      <Setter Property="Placement" Value="Bottom"/>
      <Setter Property="VerticalOffset" Value="2"/>
      <Setter Property="MaxWidth" Value="420"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ToolTip">
            <Grid Margin="12">
              <Border Background="#F4201B2C" BorderBrush="#463E5C" BorderThickness="1" CornerRadius="10">
                <Border.Effect><DropShadowEffect BlurRadius="22" ShadowDepth="5" Opacity="0.55" Color="#000000"/></Border.Effect>
                <Grid>
                  <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                  </Grid.ColumnDefinitions>
                  <Border Width="3" CornerRadius="2" Background="{StaticResource Accent}" Margin="9,10,0,10"/>
                  <ContentPresenter Grid.Column="1" Margin="11,9,14,10"/>
                </Grid>
              </Border>
            </Grid>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
      <Style.Resources>
        <Style TargetType="TextBlock"><Setter Property="TextWrapping" Value="Wrap"/><Setter Property="LineHeight" Value="18"/></Style>
      </Style.Resources>
    </Style>
    <!-- liste déroulante (les presets du script à cocher) -->
    <Style TargetType="ComboBox">
      <Setter Property="Foreground" Value="{StaticResource Texte}"/>
      <Setter Property="Margin" Value="0,0,8,8"/>
      <Setter Property="MinWidth" Value="250"/>
      <Setter Property="MinHeight" Value="34"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
      <Setter Property="ToolTipService.InitialShowDelay" Value="250"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ComboBox">
            <Grid>
              <ToggleButton Name="Bascule" IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}" Focusable="False" ClickMode="Press" Cursor="Hand">
                <ToggleButton.Template>
                  <ControlTemplate TargetType="ToggleButton">
                    <Border Name="Fond" Background="{StaticResource Surface2}" BorderBrush="{StaticResource Bordure}" BorderThickness="1" CornerRadius="8">
                      <TextBlock Text="&#xE70D;" FontFamily="Segoe MDL2 Assets" FontSize="10" Foreground="{StaticResource Sourd}" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,12,0"/>
                    </Border>
                    <ControlTemplate.Triggers>
                      <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Fond" Property="BorderBrush" Value="{StaticResource Accent}"/></Trigger>
                      <Trigger Property="IsChecked" Value="True"><Setter TargetName="Fond" Property="BorderBrush" Value="{StaticResource Accent}"/></Trigger>
                    </ControlTemplate.Triggers>
                  </ControlTemplate>
                </ToggleButton.Template>
              </ToggleButton>
              <ContentPresenter Content="{TemplateBinding SelectionBoxItem}" ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}" Margin="12,0,30,0" VerticalAlignment="Center" IsHitTestVisible="False"/>
              <Popup Name="PART_Popup" IsOpen="{TemplateBinding IsDropDownOpen}" Placement="Bottom" AllowsTransparency="True" PopupAnimation="Fade" StaysOpen="False">
                <Border Background="{StaticResource Surface}" BorderBrush="#463E5C" BorderThickness="1" CornerRadius="10" Padding="6" Margin="0,4,0,0" MinWidth="{Binding ActualWidth, RelativeSource={RelativeSource TemplatedParent}}">
                  <Border.Effect><DropShadowEffect BlurRadius="18" ShadowDepth="4" Opacity="0.5" Color="#000000"/></Border.Effect>
                  <StackPanel IsItemsHost="True"/>
                </Border>
              </Popup>
            </Grid>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="ComboBoxItem">
      <Setter Property="Foreground" Value="{StaticResource Texte}"/>
      <Setter Property="Padding" Value="10,7"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
      <Setter Property="ToolTipService.InitialShowDelay" Value="250"/>
      <Setter Property="ToolTipService.Placement" Value="Right"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ComboBoxItem">
            <Border Name="Fond" Background="Transparent" CornerRadius="6" Padding="{TemplateBinding Padding}">
              <ContentPresenter/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsHighlighted" Value="True"><Setter TargetName="Fond" Property="Background" Value="{StaticResource Surface2}"/></Trigger>
              <Trigger Property="IsSelected" Value="True"><Setter TargetName="Fond" Property="Background" Value="{StaticResource AccentFond}"/><Setter Property="Foreground" Value="{StaticResource AccentClair}"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
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
              <WrapPanel Name="BarreOptis" DockPanel.Dock="Left">
                <TextBlock Name="PresetsLabel" Foreground="{StaticResource Sourd}" VerticalAlignment="Center" Margin="4,0,8,8"/>
                <ComboBox Name="Presets"/>
              </WrapPanel>
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
function Bloc-Texte($texte, $brosse, $taille, $ligne) {   # pas $pinceau : masquerait $Pinceau
    $t = New-Object Windows.Controls.TextBlock
    $t.Text = $texte; $t.TextWrapping = 'Wrap'; $t.Foreground = $brosse; $t.FontSize = $taille; $t.LineHeight = $ligne; $t.Margin = '0,0,0,6'
    $t
}
# Texte avec, en option, une pastille "i" au bout : "texte visible i@ détail au survol". Le détail ne prend pas de place.
function Bloc-Info($texte, $brosse, $taille, $ligne) {
    $parts = $texte -split ' i@ ', 2
    $t = Bloc-Texte $parts[0].TrimEnd() $brosse $taille $ligne
    if ($parts.Count -lt 2 -or -not $parts[1].Trim()) { return $t }
    $icone = New-Object Windows.Controls.Border
    $icone.Width = 16; $icone.Height = 16; $icone.CornerRadius = '8'; $icone.Margin = '6,0,0,-3'; $icone.Cursor = 'Help'
    $icone.Background = $Pinceau.AccentFond; $icone.BorderBrush = $Pinceau.Accent; $icone.BorderThickness = '1'
    $lettre = New-Object Windows.Controls.TextBlock
    $lettre.Text = 'i'; $lettre.FontFamily = 'Georgia'; $lettre.FontWeight = 'Bold'; $lettre.FontSize = 10; $lettre.Foreground = $Pinceau.AccentClair
    $lettre.HorizontalAlignment = 'Center'; $lettre.VerticalAlignment = 'Center'; $lettre.Margin = '0,-1,0,0'; $lettre.LineHeight = [double]::NaN   # LineHeight hérité du bloc parent, sinon le i monte
    $icone.Child = $lettre
    $icone.ToolTip = $parts[1].Trim()
    [Windows.Controls.ToolTipService]::SetInitialShowDelay($icone, 100)
    [Windows.Controls.ToolTipService]::SetShowDuration($icone, 60000)
    $enLigne = New-Object Windows.Documents.InlineUIContainer $icone
    $enLigne.BaselineAlignment = 'Center'
    [void]$t.Inlines.Add($enLigne)
    $t
}
# La pastille "ou" entre deux groupes de boutons : "@BtnA | BtnB" = l'un ou l'autre
function Pastille-Ou {
    $b = New-Object Windows.Controls.Border
    $b.Background = $Pinceau.AccentFond; $b.CornerRadius = '12'; $b.Padding = '10,4'; $b.Margin = '2,0,10,8'; $b.VerticalAlignment = 'Center'
    $t = New-Object Windows.Controls.TextBlock
    $t.Text = $Bagarre.L.ou; $t.FontWeight = 'Bold'; $t.FontSize = 11; $t.Foreground = $Pinceau.AccentClair
    $b.Child = $t
    $b
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
        $brosse = New-Object Windows.Media.ImageBrush $img
        $brosse.Stretch = 'UniformToFill'
        $logo.Background = $brosse
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
            $groupesBtn = @($Matches[1] -split '\|')
            for ($k = 0; $k -lt $groupesBtn.Count; $k++) {
                if ($k -gt 0) { [void]$wp.Children.Add((Pastille-Ou)) }
                foreach ($id in ($groupesBtn[$k] -split ',')) {
                    $id = $id.Trim()
                    if (-not $id) { continue }
                    $c = switch ($id) { 'DnsListe' { $Ctl.DnsPanneau } default { Bouton-Obtenir $id } }
                    if ($c) { Detacher $c; [void]$wp.Children.Add($c) }
                }
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
            $t = Bloc-Info $Matches[1] $Pinceau.Texte 13 19; $t.Margin = '0,0,0,5'
            [Windows.Controls.Grid]::SetColumn($t, 1)
            [void]$g.Children.Add($puce); [void]$g.Children.Add($t)
            [void]$pile.Children.Add($g)
        } else {
            $t = if ($intro) { Bloc-Info $ligne $Pinceau.Sourd 14 22 } else { Bloc-Info $ligne $Pinceau.Texte 13 19 }
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
$Groupes = @()   # un objet par groupe : Nom, Entete, Titre, Compte, Ids
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
    $cb.Add_Checked({ param($s, $e) $s.Tag.Coche = $true; Ligne-Etat $s.Tag.Id; Compter-Coches; Preset-Perso })
    $cb.Add_Unchecked({ param($s, $e) $s.Tag.Coche = $false; Ligne-Etat $s.Tag.Id; Compter-Coches; Preset-Perso })
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
        foreach ($c in $tb, $compte) { [Windows.Controls.DockPanel]::SetDock($c, 'Left'); [void]$entete.Children.Add($c) }
        [void]$Ctl.ListeOptis.Children.Add($entete)
        $groupe = @{ Nom = $it.Groupe; Entete = $entete; Titre = $tb; Compte = $compte; Ids = @() }
        $Groupes += $groupe
    }
    [void]$Ctl.ListeOptis.Children.Add((Ligne-Creer $it))
    $groupe.Ids += $it.Id
    $Defauts[$it.Id] = [bool]$it.Coche
}

# Barre du script à cocher et volet : les boutons de zone Barre et Volet, créés une fois. Le premier de la barre est la liste des presets.
foreach ($id in 'BtnAppliquer', 'BtnDetecter', 'BtnRestaurer') { [void]$Ctl.BarreOptis.Children.Add((Bouton-Obtenir $id)) }
$Ctl.BarreOptis.Children.Remove($Ctl.PresetsLabel); $Ctl.BarreOptis.Children.Remove($Ctl.Presets)
$Ctl.BarreOptis.Children.Insert(1, $Ctl.PresetsLabel); $Ctl.BarreOptis.Children.Insert(2, $Ctl.Presets)
foreach ($id in 'BtnReseau', 'BtnImgProtocoles', 'BtnImgAvance', 'BtnJournal') { $b = Bouton-Obtenir $id; $b.Margin = '0,8,8,0'; $b.Padding = '10,5'; $b.FontSize = 12; [void]$Ctl.VoletOptis.Children.Add($b) }

# Presets : une liste déroulante à la place de quarante boutons. Recommandé = les cases sûres, Minimal = celles sans
# contrepartie, Tout décocher, Windows par défaut = restaure ce qui a été appliqué. Toucher une case passe en Personnalisé.
$Bagarre.PresetEnCours = $false
$PresetItems = @{}
foreach ($cle in 'recommande', 'minimal', 'aucun', 'windows', 'perso') {
    $cbi = New-Object Windows.Controls.ComboBoxItem
    $cbi.Tag = $cle
    if ($cle -eq 'perso') { $cbi.Visibility = 'Collapsed' }
    [void]$Ctl.Presets.Items.Add($cbi)
    $PresetItems[$cle] = $cbi
}
function Preset-Choisir($cle) {
    $Bagarre.PresetEnCours = $true
    try { $Ctl.Presets.SelectedItem = $PresetItems[$cle] } finally { $Bagarre.PresetEnCours = $false }
}
function Preset-Perso { if (-not $Bagarre.PresetEnCours) { Preset-Choisir 'perso' } }
function Preset-Appliquer($cle) {
    $Bagarre.PresetEnCours = $true
    try {
        switch ($cle) {
            'recommande' { foreach ($id in $Lignes.Keys) { $Lignes[$id].Cb.IsChecked = $Defauts[$id] } }
            'minimal' { foreach ($id in $Lignes.Keys) { $Lignes[$id].Cb.IsChecked = $Defauts[$id] -and [string]::IsNullOrWhiteSpace($Lignes[$id].Item.Attention) } }
            'aucun' { foreach ($id in $Lignes.Keys) { $Lignes[$id].Cb.IsChecked = $false } }
            'windows' { Restaurer-Demander; foreach ($id in $Lignes.Keys) { $Lignes[$id].Cb.IsChecked = $false } }
        }
    } finally { $Bagarre.PresetEnCours = $false }
}
$Ctl.Presets.Add_SelectionChanged({
    param($s, $e)
    if ($Bagarre.PresetEnCours -or -not $s.SelectedItem) { return }
    $cle = [string]$s.SelectedItem.Tag
    if ($cle -eq 'perso') { return }
    Preset-Appliquer $cle
})
Preset-Choisir 'recommande'

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
    $Bagarre.PresetEnCours = $true   # décocher ce qui est déjà fait n'est pas un choix de l'utilisateur
    try {
        foreach ($it in $Items) {
            $r = Detecter-Item $it
            $Etat[$it.Id] = $r
            if ($r -eq $true) { $Lignes[$it.Id].Cb.IsChecked = $false; $faits++ }
            Ligne-Etat $it.Id
        }
    } finally { $Bagarre.PresetEnCours = $false }
    Log ($Bagarre.L.detectionFin -f $faits)
    Compter-Coches
}

# Noms de groupe en anglais (les groupes du catalogue sont en français)
$GroupesEn = @{
    'Services Windows' = 'Windows services'; 'Vie privée et pubs' = 'Privacy and ads'; 'Jeu et réactivité' = 'Gaming and responsiveness'
    'Carte réseau (appliqué sur chaque carte physique active)' = 'Network card (applied to every active physical card)'
    'Confort (aucun gain de FPS, juste plus vif)' = 'Comfort (no FPS gain, just snappier)'
    'Avancé (décoché par défaut, lis l explication avant)' = 'Advanced (unchecked by default, read the explanation first)'
    'Processeur Intel' = 'Intel processor'; 'Carte graphique NVIDIA' = 'NVIDIA graphics card'
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
# Une ligne de résultat : rang, logo, nom + note, barre proportionnelle, ms. Mediane est un nombre (jamais parsé
# depuis une chaîne : "12,3" en français cassait tout). $null = mesure en cours, la ligne est grisée.
function Dns-Ligne($i, $r, $max, $rang, $plusRapide) {
    $row = New-Object Windows.Controls.Border
    $row.Tag = $i; $row.Background = $Pinceau.Surface2; $row.BorderThickness = '1'; $row.CornerRadius = '8'; $row.Padding = '10,8'; $row.Margin = '0,0,0,6'; $row.Cursor = 'Hand'
    $row.BorderBrush = if ($plusRapide) { $Pinceau.Accent } else { $Pinceau.Bordure }
    $g = New-Object Windows.Controls.Grid
    foreach ($w in '26', '34', '230', '*', '70') { $cd = New-Object Windows.Controls.ColumnDefinition; $cd.Width = $w; [void]$g.ColumnDefinitions.Add($cd) }
    $num = New-Object Windows.Controls.TextBlock
    $num.Text = if ($rang -gt 0) { "$rang" } else { '' }; $num.FontSize = 11; $num.FontWeight = 'SemiBold'; $num.VerticalAlignment = 'Center'
    $num.Foreground = if ($plusRapide) { $Pinceau.AccentClair } else { $Pinceau.Sourd }
    $logo = New-Object Windows.Controls.Border
    $logo.Width = 24; $logo.Height = 24; $logo.CornerRadius = '6'; $logo.HorizontalAlignment = 'Left'; $logo.VerticalAlignment = 'Center'
    [Windows.Controls.Grid]::SetColumn($logo, 1)
    $img = if ($r.Cle -ne 'actuel') { Logo-Image $r.Cle } else { $null }
    if ($img) { $ib = New-Object Windows.Media.ImageBrush $img; $ib.Stretch = 'UniformToFill'; $logo.Background = $ib }
    else {
        $logo.Background = $Pinceau.AccentFond
        $lt = New-Object Windows.Controls.TextBlock; $lt.Text = $Bagarre.L.dnsBox; $lt.FontSize = 8; $lt.Foreground = $Pinceau.AccentClair; $lt.HorizontalAlignment = 'Center'; $lt.VerticalAlignment = 'Center'
        $logo.Child = $lt
    }
    $bloc = New-Object Windows.Controls.StackPanel
    $bloc.VerticalAlignment = 'Center'; $bloc.Margin = '6,0,10,0'
    [Windows.Controls.Grid]::SetColumn($bloc, 2)
    $nom = New-Object Windows.Controls.TextBlock
    $nom.Text = $r.Nom; $nom.FontWeight = 'SemiBold'
    if ($plusRapide) { $nom.Text += '  ' + $Bagarre.L.dnsRapide; $nom.Foreground = $Pinceau.AccentClair }
    $note = New-Object Windows.Controls.TextBlock
    $note.Text = $Bagarre.L.dnsNotes[$r.Cle]; $note.FontSize = 11; $note.Foreground = $Pinceau.Sourd; $note.TextWrapping = 'Wrap'
    [void]$bloc.Children.Add($nom); [void]$bloc.Children.Add($note)
    $ok = $null -ne $r.Mediane
    $med = if ($ok) { [double]$r.Mediane } else { 0.0 }
    $barre = New-Object Windows.Controls.Border
    $barre.Height = 8; $barre.CornerRadius = '4'; $barre.HorizontalAlignment = 'Left'; $barre.VerticalAlignment = 'Center'
    $barre.Width = if ($ok -and $max -gt 0) { 12 + 220 * $med / $max } else { 12 }
    $barre.Background = if (-not $ok) { $Pinceau.Bordure } elseif ($med -le $max * 0.35) { $Pinceau.Accent } else { '#4A4260' }
    [Windows.Controls.Grid]::SetColumn($barre, 3)
    $ms = New-Object Windows.Controls.TextBlock
    $ms.TextAlignment = 'Right'; $ms.VerticalAlignment = 'Center'; $ms.FontWeight = 'SemiBold'
    if ($ok) { $ms.Text = '{0} ms' -f [math]::Round($med) } else { $ms.Text = $Bagarre.L.dnsTest; $ms.FontSize = 11; $ms.Foreground = $Pinceau.Sourd; $ms.FontWeight = 'Normal' }
    [Windows.Controls.Grid]::SetColumn($ms, 4)
    foreach ($c in $num, $logo, $bloc, $barre, $ms) { [void]$g.Children.Add($c) }
    $row.Child = $g
    if (-not $ok) { $row.Opacity = 0.55; $row.Cursor = 'Arrow' } else { $row.Add_MouseLeftButtonDown({ param($s, $e) Dns-Choisir ([int]$s.Tag) }) }
    $row
}
# Redessine la liste : rang par médiane croissante, le plus rapide encadré. Les lignes sans mesure restent à leur place.
function Dns-Redessiner {
    $Ctl.DnsListe.Children.Clear()
    $mesures = @($Bagarre.DnsResultats | Where-Object { $null -ne $_.Mediane })
    $max = 0.0
    foreach ($r in $mesures) { if ([double]$r.Mediane -gt $max) { $max = [double]$r.Mediane } }
    $tries = @($mesures | Sort-Object { [double]$_.Mediane })
    $rangs = @{}
    for ($k = 0; $k -lt $tries.Count; $k++) { $rangs[$tries[$k].Cle] = $k + 1 }
    $meilleur = if ($tries.Count -gt 0 -and $tries.Count -eq $Bagarre.DnsResultats.Count) { $tries[0].Cle } else { $null }
    for ($i = 0; $i -lt $Bagarre.DnsResultats.Count; $i++) {
        $r = $Bagarre.DnsResultats[$i]
        [void]$Ctl.DnsListe.Children.Add((Dns-Ligne $i $r $max $rangs[$r.Cle] ($r.Cle -eq $meilleur)))
    }
    Rafraichir
}
function Dns-Tester {
    $adapt = Dns-Carte
    if (-not $adapt) { Log $Bagarre.L.aucuneCarte; return }
    $Bagarre.DnsAdapt = $adapt
    $Ctl.DnsCarte.Text = $Bagarre.L.dnsCarte -f $adapt.Name, $adapt.InterfaceDescription, ((Dns-Actuels $adapt) -join ', ')
    Dns-Choisir -1
    $Ctl.BtnDnsTester.IsEnabled = $false
    Log $Bagarre.L.dnsEnCours
    $Bagarre.DnsResultats = @()
    foreach ($c in (Dns-Candidats $adapt)) {
        if (-not $c.Serveurs[0]) { continue }
        $Bagarre.DnsResultats += [pscustomobject]@{ Cle = $c.Cle; Nom = $c.Nom; Serveurs = $c.Serveurs; Mediane = $null; Actuel = ($c.Cle -eq 'actuel') }
    }
    Dns-Redessiner
    foreach ($r in $Bagarre.DnsResultats) {
        $r.Mediane = Dns-Mesurer-Un $r.Serveurs[0]
        Log ("dns       {0,-20} {1,7} ms" -f $r.Nom, $r.Mediane)
        Dns-Redessiner
    }
    $Ctl.BtnDnsTester.IsEnabled = $true
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
    }
    foreach ($cle in $PresetItems.Keys) {
        $PresetItems[$cle].Content = $L["preset$($cle.Substring(0,1).ToUpper())$($cle.Substring(1))"]
        $PresetItems[$cle].ToolTip = $L.presetTips[$cle]
    }
    $Ctl.PresetsLabel.Text = $L.preset
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
