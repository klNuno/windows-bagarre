#Requires -Version 5.1
param([switch]$Liste, [string]$Capture, [switch]$Essai, [string]$Depuis)  # -Liste : le catalogue en texte, sans rien appliquer. -Capture dossier : chaque onglet en PNG, sans fenetre. -Essai : ouvre la fenetre invisible 1,5 s et note son etat. -Depuis : dossier du clone (pose par la relance admin).
# bagarre.ps1 : GENERE par build.ps1 a partir de src/ et textes/. Ne pas editer ce fichier, edite les sources.
# UTF-8 SANS BOM : "irm" garde le BOM dans le texte et PowerShell le prend pour une commande. Pour le lancer en local :
#   & ([scriptblock]::Create([IO.File]::ReadAllText("bagarre.ps1", [Text.Encoding]::UTF8))) -Liste

$Textes = @{}
$Textes['en'] = @{}
$Textes['en']['accueil'] = @'
This pack removes what runs for nothing and tunes what matters for gaming.
No backup beforehand: if it breaks, you reinstall, that is the whole point of a fresh Windows.

Follow the steps in order. Easy is enough for a desktop PC. The checkbox script
is the real level for gaming. Hard, you understand every line before checking it.

Pack rule: every tweak says what it changes and what you lose.
You do not understand a line, you do not check it.

The "(winget)" buttons open a console that installs the current version of the tool.
Win11Debloat and WinUtil launch as is, in their own console.

Everything the checkbox script changes is logged in C:\ProgramData\bagarre
(bagarre-avant.json for the before values, bagarre.log for the detail).
"Restore everything" restores exactly those values.

To reopen bagarre later, the same command in a Terminal:
  irm https://raw.githubusercontent.com/klNuno/windows-bagarre/main/bagarre.ps1 | iex
'@
$Textes['en']['audit'] = @'
The pack is generic. Your PC is not: your network card, your GPU, your programs,
your games. The audit takes a snapshot of your PC and gives it to an AI with a prompt that knows
what the pack did, what it refuses to do, and how to judge a tweak.

1) "Collect the report" button. 30 seconds. It writes rapport-pc.txt and AUDIT.txt (the prompt)
   into a bagarre-audit folder on your Desktop, and opens it. It changes nothing. The report
   contains no account name, no password, no license key. Open it anyway before
   sending it, it is your PC.

2) "Copy the prompt" button (or open AUDIT.txt and copy all of it).

3) Pick your AI:
   - Claude Code, Codex, Gemini CLI or any terminal agent: open it in the
     bagarre-audit folder and paste the prompt. It will read rapport-pc.txt on its own and can go check things.
   - ChatGPT, Claude.ai, a web chat: paste the prompt, then attach rapport-pc.txt
     (or paste its content after).

4) Read the answer like the rest of the pack: every proposal must say what it changes,
   what you lose, and where it comes from. A proposal with no source or no tradeoff,
   you do not apply it. One thing at a time, you measure with RivaTuner, you keep it or you revert.

The AI does not touch your PC. It reads and proposes. You are the one who applies it.
'@
$Textes['en']['audit-prompt'] = @'
You are a Windows 11 expert focused on gaming and latency, careful, who prefers one measurable tweak to ten forum tweaks.
You are auditing a PC whose state is in the file rapport-pc.txt (next to this prompt, or attached to the message).
Answer in the language of the person asking, informal, direct, no filler.

CONTEXT
This PC went through the "windows bagarre edition" pack:
- Fresh Windows 11, Windows Update current, chipset/network drivers from the manufacturer.
- Win11Debloat (default mode) and WinUtil (Standard tweaks).
- NVIDIA driver installed bare via NVCleanstall: no NVIDIA App, MSI High, HDCP off, Ansel off, MPO kept
  (off only in case of black screen or flicker), signature rebuilt (EAC compatible method).
  Classic NVIDIA Control Panel from the Store, Low Latency Mode On (Ultra if no FPS cap),
  max performance, unlimited shader cache, G-Sync + V-Sync On in the Panel + RTSS cap under the screen's refresh rate.
- Checkbox script bagarre.ps1: useless services (telemetry, fax, demo, Edge update...), telemetry, CEIP and error
  reports at minimum, Copilot/Recall/Click to Do/Widgets/Notepad and Paint AI cut, Game DVR and PresenceWriter off,
  GlobalTimerResolutionRequests=1, 0.507 ms timer via a scheduled task SetTimerResolution, mouse acceleration off,
  hibernation and fast startup off, USB suspend, USB3 LPM, PCIe ASPM and wake timers off,
  drivers excluded from Windows Update, Continuous Innovation declined, F8 menu, AutoRun off, ARSO off, network card
  (power management, EEE, LLDP/topology unchecked, Interrupt Moderation Medium), comfort (classic right-click menu,
  End task in the taskbar, Edge without Startup Boost, File Explorer).
  Options unchecked by default: SvcHostSplitThreshold (placebo), Win32PrioritySeparation 0x26, PowerThrottlingOff,
  Nagle, disabledynamictick, RawMouseThrottleDuration, FTH off, LLMNR off, clipboard, Dynamic Lighting,
  NVIDIA P0, core parking.

WHAT THE PACK REFUSES, DO NOT PROPOSE IT
- Disabling HVCI / memory integrity, Secure Boot, Defender, the firewall, Windows Update, UAC.
- Registry cleaners, paid "optimizers", scripts that make 200 changes at once.
- BIOS settings (out of scope for the pack).
- "Ultimate performance" plan, prefetch/superfetch tweaks, "unlocking the 20% reserved bandwidth", placebo tweaks
  (LargeSystemCache, IRQ8Priority, mouse/keyboard data queues, TcpWindowSize, disabling the page file).
- Disabling a service you are not sure about: NvContainer, Windows Audio, Themes, Cryptographic Services,
  Windows Time, Storage Service, Device Install, Windows Management Instrumentation stay on.

YOUR MISSION, IN THIS ORDER
1. Pack check: for each point in the CONTEXT, say whether it is DONE, NOT DONE or UNCERTAIN based on the report,
   with the report line that proves it. List what is missing, with the script checkbox or the tutorial step to redo.

2. What is off: old drivers (compare the GPU and network driver date to today), MSI missing on the GPU or the
   network card, useless auto-start programs, third-party services set to automatic (launchers, updaters,
   RGB), Store bloat still present, a duplicate antivirus, repeated system errors (WHEA, disk, driver),
   an almost full disk, HAGS or windowed optimizations inconsistent with the GPU, slow or ISP DNS.

3. Tweaks specific to THIS config, that the generic pack cannot know:
   - the exact CPU model (E-cores / P-cores, X3D, laptop), GPU, network card (Realtek, Intel, Killer,
     Marvell) and exactly what to set for each ;
   - the installed programs (Discord, launchers, RGB, overlays) and which ones cost you in-game ;
   - the screen (Hz, G-Sync) and the consistency of V-Sync / FPS cap / low latency ;
   - the RAM (sticks, rated speed vs likely XMP, but with no BIOS step: just flag it).

4. For EVERY proposal, this format, otherwise it is worthless:
   - What: the exact setting (registry key, command, menu), ready to apply.
   - Why: the mechanism in two sentences, not "it optimizes things".
   - What you lose: the tradeoff, even a small one. "Nothing" is rarely true.
   - Source: manufacturer doc, Microsoft doc, maintained repo, with the name and the year. No videos, no "people say".
   - Expected gain: measurable or not, and how to measure it (RivaTuner frame time, MeasureSleep, ping, LatencyMon).
   - Reversible: how to roll it back.
   Sort them: DO (clear gain, no risk) / TEST (one at a time, measure) / NO (placebo or harmful, say why).

5. Finish with the 5 most useful actions for this exact PC, in order, one line each.

RULES
- You do not change anything yourself, even if you have terminal access. You propose, the user applies.
  If you are an agent with access to the PC, you can read (registry, Get-*, powercfg /query) to clarify a point,
  never write.
- If the report does not allow a conclusion, say UNCERTAIN and say which command to run to decide.
- No made-up FPS estimate. "A few ms of latency" only if you can say where it comes from.
- Keep it short. A tweak that needs a paragraph to justify itself is probably not a tweak.
'@
$Textes['en']['dns'] = @'
Quad9 blocks known malicious domains and does not keep your IP address in its logs.
Cloudflare is usually the fastest. Google keeps logs. Your ISP's DNS is often the
slowest, except at Free where it is very good.

A gap under 5 ms is not noticeable. If your box is within 5 ms of the best one, keep it.

To encrypt the chosen DNS (DoH: your box and your ISP no longer see the names you request):
Settings > Network & internet > your adapter > DNS server assignment > Edit > Encrypted DNS:
Encrypted preferred. Optional, zero effect on ping.

"Restore everything" (tab 3) also restores the previous DNS.
'@
$Textes['en']['dur'] = @'
HARD (20 min): read everything before touching anything

Here you change one thing at a time, you play for 30 minutes, you watch the frame time graph
in RivaTuner, you keep it or you revert. A tweak you cannot measure does not exist.
The clean measurement protocol is in the Maintenance tab ("Measure before / after").

1) 0.507 ms timer
   The checkbox script created the "bagarre timer" task (SetTimerResolution.exe, open source GPL,
   valleyofdoom/TimerResolution repo). Check with MeasureSleep (button, Maintenance tab): about 0.5 ms expected.
   If MeasureSleep shows 1 ms or 15.6 ms: the GlobalTimerResolutionRequests key is not set
   (the jeu-timer checkbox in the script) or the task did not start (Task Scheduler, "bagarre timer").
   Process Lasso is no longer in the pack: 30 s wait on startup in the free version, timer paid
   after a month. ThreadPilot (AGPL) exists for per-process affinity, with no ProBalance or timer,
   curiosity only.

6) Mouse
   Acceleration turned off by the script. Then: 1000 Hz in the mouse software,
   native DPI (400 / 800 / 1600), sensitivity set in the game, not in Windows (6/11 = 1:1).
   RawMouseThrottleDuration (adv-rawmouse checkbox): only test it at 4000 Hz and above, and it is often
   already at 8 by default on recent Windows 11 (the previous value is in bagarre.log, button on tab 3).

7) Win32PrioritySeparation (adv-priosep checkbox)
   0x26 = short, variable quantum, x3 boost in the foreground. Can help a CPU-bound game with Discord
   and a browser running behind it. Can also make the audio crackle. Measure it.

8) Memory
   16 GB of RAM and recent games: ISLC (Intelligent Standby List Cleaner, Wagnardsoft) empties the
   standby list when free RAM drops under 1 GB, it avoids swap stutter. 32 GB and above:
   useless. Windows memory compression stays on either way (turning it off makes it swap
   sooner).

9) Cores for gaming (AutoGpuAffinity, optional)
   A script that tests which core to put the GPU interrupt on and gives you the best one. Long (1 h), do it
   on a PC that is already stable. valleyofdoom/AutoGpuAffinity repo.
   MSI Util v3: to CHECK that the graphics card is really in MSI mode (NVCleanstall did it), not
   to write. Its inpoutx64.sys driver has been blocked by Windows since KB5121003 (2026): if the tool
   will not launch anymore, that is why, and you do not need it.

10) Storage
   DirectStorage (Forspoken, Ratchet & Clank, Starfield): the game on the NVMe, not on a SATA drive, and
   never NTFS compression on a game folder (CompactGUI: only for old 2D games).
   The shader cache (%LOCALAPPDATA%\NVIDIA\DXCache) does not get "cleaned": emptying it makes
   every shader recompile on your next play session.

11) CPU boost (checkbox in powercfg, Intel desktop only, optional)
   powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2 (Aggressive) then
   powercfg /setactive SCHEME_CURRENT. The processor ramps up clock speed faster. On AMD the boost
   is handled by the firmware, the key does nothing. On a laptop, no: it just heats up for nothing.

12) If you are on AMD (one page is enough)
   Driver from the AMD site, "driver only" install (not the full Adrenalin) or Radeon Software
   Slimmer (open source). Anti-Lag 2 on per game if available. AFMF (frame generation) off in
   competitive play. On a Ryzen X3D, leave core parking on: it is what keeps the game on the CCD with
   the cache. The rest of the pack applies the same way.

13) Feature updates
   Settings > Windows Update > Advanced options: pause for up to 5 weeks when a major
   version (25H2, 26H1) comes out, until drivers and anti-cheats catch up. No more than that: the
   security fixes depend on it. The "Xbox Mode" / Xbox full screen experience does nothing on a
   desktop PC, it is for handheld consoles.

The videos from the previous pack (Khorvie Tech channel), found through the Wayback Machine:
- "BOOST PC PERFORMANCE | Win32 Priority Separation Benchmarks" (May 2024, 3 min): now private.
  Benchmark on a single machine, a single scene. Kept as an unchecked Advanced checkbox, nothing more.
- "Debunk'd Mouse and Keyboard Data Queue Sizes" (July 2024): deleted. Concluded that the
  mouse / keyboard data queue tweak changes nothing. Not in the pack.
- "The ONLY Windows PC OPTIMIZATION Guide 2024" (April 2024, 40 min, 1.6M views): now private.
  The pack's timecodes fell in "network tweaks" (21:35). What was useful is in
  the script's Network card group, with the explanation. The rest (unparking CPU via a third-party tool,
  "win tweaker") is covered by the script or deliberately left out.

What we do not do, and why:
- HVCI / memory integrity off: anti-cheats require it, the October 2026 updates
  turn it back on anyway, and the gain is 1 to 3%.
- Registry cleaner: nothing to gain, everything to break.
- "Ultimate performance" plan: identical to High performance on a desktop since 1903.
- Disabling the Windows Update service, Defender, the firewall: no.
- Prefetch / superfetch tweaks: the SSD does not care, SysMain helps on HDD.
- "Unlocking" bandwidth (the reserved 20%): a myth, the key never did that.
- HPET / useplatformclock, TdrLevel, DisablePreemption, MouseDataQueueSize, NetworkThrottlingIndex,
  SystemResponsiveness=0, IPv6 off, C-states off, Interrupt Moderation "Disabled": tested by
  others, nothing measurable, or harmful. Renaming GameBarPresenceWriter.exe: the script turns it off
  properly (ActivationType key), never by renaming it.
- Lossless Scaling, ExplorerPatcher, ViveTool, ParkControl, HIDUSBF: either paid, or broken by
  every update, or already covered by the script.
'@
$Textes['en']['facile'] = @'
EASY (15 min): two commands and two installers

The two buttons at the top open each tool in its own console, as administrator.
They download the current version, nothing to update here. The commands are listed for reference.

1) Win11Debloat (button): remove what Windows installed without asking
   & ([scriptblock]::Create((irm "https://debloat.raphi.re/")))
   Default mode. Removes sponsored apps, Copilot, Start menu ads,
   telemetry, and asks before each group. Updated several times a month, knows 24H2 and 25H2.
   OneDrive: it offers to uninstall it. Say yes if you do not use it, but check FIRST that
   Documents / Pictures are not "in OneDrive" (right-click > Properties > Location): otherwise
   they get removed with it.

2) Chris Titus's WinUtil (button): install all your programs at once
   irm https://christitus.com/win | iex
   Install tab: check Steam, Discord, browser, 7-Zip, VLC, it installs everything via winget.
   Tweaks tab: "Standard" preset only. Not the Advanced tab, the checkbox script
   on tab 3 does the same thing while explaining every line.
   Never the "windev" version (development branch).
   To do the same install on another PC: "winget export -o mes-applis.json" here,
   "winget import mes-applis.json" over there.

3) DirectX and Visual C++: the libraries games ask for
   Without them a game crashes with "VCRUNTIME140.dll not found".
   - DirectX: button above (winget Microsoft.DirectX). For old games.
   - Visual C++: button above. What it runs, if you prefer typing it in an admin Terminal:

   '2005','2008','2010','2012','2013' | ForEach-Object {
     winget install --id "Microsoft.VCRedist.$_.x86" -e --accept-package-agreements --accept-source-agreements
     winget install --id "Microsoft.VCRedist.$_.x64" -e --accept-package-agreements --accept-source-agreements
   }
   winget install --id 'Microsoft.VCRedist.2015+.x86' -e --accept-package-agreements --accept-source-agreements
   winget install --id 'Microsoft.VCRedist.2015+.x64' -e --accept-package-agreements --accept-source-agreements

   Comes from Microsoft, updates with "winget upgrade --all".

4) Small keyboard and search tricks
   - Copilot key on a recent keyboard: Settings > Personalization > Text input >
     "Customize the Copilot key" (since KB5124010) to turn it into a search or an app launch.
     Otherwise PowerToys > Keyboard Manager.
   - If you installed Gemini or Copilot as an app: their overlay sticks to Alt+Space. Turn it off
     in their settings, or you will get it mid-game.
   - If you turned off indexing (the svc-recherche checkbox in the script): Everything (voidtools, free)
     finds any file in a second with no Windows index.

5) Audio (5 min, it prevents crackling)
   - Right-click the speaker icon > Sounds > Communications tab: "Do nothing" (otherwise Windows
     drops your volume by 80% when Discord rings).
   - Playback device > Properties > Enhancements: "Disable all enhancements".
     Advanced tab: 24 bit, 48000 Hz (the format games and Discord use, zero resampling).
   - Nahimic / Sonic Studio / Realtek Audio Console: uninstall, the bare driver is enough (see Maintenance).
'@
$Textes['en']['installation'] = @'
1) when you install Windows 11
- local account bypass: "start ms-cxh:localonly"
   - Right after the first desktop, in an admin Terminal:  fsutil 8dot3name set 1
     This turns off short name generation "PROGRA~1" on new drives (fewer writes
     per file created). Do it before installing anything, you cannot catch up on it later.

2) Windows Update before continuing

3) Drivers, in order:
   a. Chipset and network card: your motherboard's manufacturer site (or laptop's), your exact model.
   b. NVIDIA graphics card: NOT now, that is tab 4. NVIDIA.
      AMD: AMD site.
   c. Windows Update again: since 24H2 it finishes the rest (audio, USB, Bluetooth).
   d. Snappy Driver Installer Origin (button above): last resort, only check what is missing.
'@
$Textes['en']['maintenance'] = @'
MAINTENANCE: once the PC has some mileage on it

- Autoruns (button): everything that launches at startup. Options > Hide Microsoft
  entries, then uncheck what you do not recognize (launchers, updaters). Uncheck, do not delete.
- Geek Uninstaller (button): uninstalls cleanly and removes the leftovers. Better than Settings > Apps.
- MeasureSleep (button): checks the timer. About 0.5 ms expected after the script.
  1 ms or 15.6 ms: see the Hard tutorial, point 1.

Manufacturer suites to remove (they are there without you asking): Nahimic, Killer Intelligence
Center, Armoury Crate, MSI Center, Dragon Center, Sonic Studio. Each one installs a service and an
audio or network overlay. For fans: FanControl (open source). For LEDs: OpenRGB, or the
brand's software alone (iCUE, Synapse) without its "modules".

Disk cleanup, in order:
1. Windows + R > cleanmgr > Clean up system files: old updates, recycle bin.
2. Settings > System > Storage > Storage Sense: on, every month, recycle bin 30 days,
   Downloads never (it deletes what you have not sorted through yet).
3. Admin Terminal, WinSxS:
   Dism /Online /Cleanup-Image /AnalyzeComponentStore     (tells you if there is anything to clean)
   Dism /Online /Cleanup-Image /StartComponentCleanup     (never /ResetBase: no more uninstalling updates)
4. BleachBit (open source, winget install BleachBit.BleachBit) if you want more: browser caches, logs.
   Never check "Free disk space" or "Memory": slow and useless on SSD.
5. DriverStore Explorer (RAPR): removes old stacked NVIDIA drivers (several GB).
6. SSD: Optimize-Volume -DriveLetter C -ReTrim in an admin terminal (TRIM, once a month
   Storage Sense already does it). CrystalDiskInfo for health and temperature.

Drivers: Windows Update no longer touches them (the jeu-pilotes checkbox). You update them yourself:
NVIDIA via NVCleanstall, the rest from the manufacturer's site, only if something works badly.
DDU (Display Driver Uninstaller) only when you switch graphics card brands, not for
every driver update: NVCleanstall's "clean installation" is enough.

Defender hogging resources: Windows has an official tool to see which file costs (admin PowerShell).
  New-MpPerformanceRecording -RecordTo C:\defender.etl    (play for 10 min, then Ctrl+C)
  Get-MpPerformanceReport -Path C:\defender.etl -TopFiles 10 -TopExtensions 10
Whatever folder comes out goes into Exclusions (the game or launcher folder). Never the whole disk.

The PC wakes up on its own / will not sleep (admin terminal):
  powercfg /lastwake         (what woke it up)
  powercfg /waketimers       (what has the right to wake it up, empty after the jeu-reveil checkbox)
  powercfg /requests         (what keeps it from sleeping: often a browser with a video playing)
  powercfg /sleepstudy       (laptop: HTML report of what drained the battery during sleep)
Wi-Fi that drops: netsh wlan show wlanreport, then open the HTML report it points to.
Crashes or blue screens: Event Viewer > System, filter source "WHEA-Logger":
a WHEA error means hardware (RAM, overclock, PSU), not Windows.

Measure before / after (the only way to know if a tweak does anything):
  Tool: CapFrameX (free) or PresentMon (Intel, open source). RivaTuner to watch it live.
  1. Same game, same scene (a built-in benchmark or a replay), same resolution.
  2. One warmup pass (discarded), then 3 passes of 60 s BEFORE, 3 passes AFTER, alternating if you
  can (before, after, before, after, and so on) to smooth out temperature.
  3. Look at the median FPS, the 1% low and the p99 frame time. Not the average.
  4. A gap under 3% with the 1% low moving both ways means no effect. Revert it.
  PresentMon also tells you the "PresentMode": "Hardware: Independent Flip" means the game is presented with no
  copy (optimized windowed or full screen), "Composed: Flip" means it goes through the compositor (one extra
  frame of latency). That is how you check that MPO and windowed optimizations are working.

Dev Drive (if you compile code or have heavy projects): Settings > System > Storage > Advanced
storage settings > Create Dev Drive. A ReFS partition with Defender in performance mode. Not for games.

RegCleaner and PureRa, which were in the old pack, are gone. 2026 verdict: obsolete,
no gain on a modern Windows, a risk of breaking a key. The old .reg files
(Recycle Bin in This PC, Quick access, VLC) are now unchecked checkboxes in the Comfort group, tab 3.
'@
$Textes['en']['nvidia'] = @'
NVIDIA (15 min): the bare driver, then the old Control Panel

Good to know in 2026: since driver 610.47 (May 2026) the classic Control Panel
is no longer bundled with the driver. It installs from the Store (step 2), and disappears with every
clean installation: you reinstall it afterward.

1) NVCleanstall (button: winget installs the latest version)
   - "Manual", latest Game Ready driver for your card.
   - Components: Display Driver, and PhysX if you play games that use it. Nothing else.
     No NVIDIA App, no GeForce Experience, no USB-C, no Stereo 3D.
     NVIDIA HD Audio: keep it only if your sound goes out through the screen's HDMI / DisplayPort cable.
   - "Installation Tweaks" page, check as in the screenshot (button "Screenshot: NVCleanstall")
     EXCEPT the MPO line (see below). What it does:
     . Perform a Clean Installation: starts fresh.
     . Disable Ansel: capture overlay, useless.
     . Disable Driver Telemetry.
     . Enable Message Signaled Interrupts, High priority: the card talks to the CPU over MSI
       instead of the old shared interrupt line. Less latency between frame ready and frame displayed.
     . Disable HDCP: the cable's anti-copy encryption. Required by Netflix 4K and Blu-ray, nothing else.
       Active, it causes micro-cuts when the link renegotiates (alt-tab, waking from sleep).
       You lose: Netflix / Disney+ in 4K in the browser (1080p still works).
     . Rebuild digital signature + "Use method compatible with Easy-Anti-Cheat" + "Automatically accept":
       NVCleanstall changed the driver (HDCP, MSI), the NVIDIA signature no longer matches, Windows would refuse it.
       It re-signs it. The EAC method keeps the driver file intact, only the installer changes,
       so the anti-cheat sees an official NVIDIA driver. Validated by the pack's maintainer on the
       common anti-cheats. If a game refuses to launch afterward: reinstall the driver without those two boxes.
     . Disable Multiplane Overlay (MPO): UNCHECKED by default now. MPO is what lets the
       windowed game be presented with no copy ("optimizations for windowed games" depend on it).
       Check it only if you get black screens or flickering with multiple monitors, it is the
       official NVIDIA fix (OverlayTestMode=5 key). A major Windows update can overwrite it,
       if the bug comes back, run NVCleanstall again.
   - Install. The screen flickers and red messages flash by, that is normal, do not touch anything.
   Next time, NVCleanstall offers "previous settings", no need to check everything again.

2) NVIDIA Control Panel (the old one), button above. What it runs:
   winget install --id 9NF8H0H7WMLT --source msstore
   It needs the NVIDIA Display Container service (NvContainer): never disable it.

   Settings (button "Screenshot: NVIDIA Control Panel"), Manage 3D settings > Global settings:
   - Low Latency Mode: On. The driver keeps a single frame of lead. "Ultra" forces zero
     frames of lead and costs stutter when the CPU is at its limit: it is the setting from before
     Reflex. If a game offers Reflex, Reflex takes over, which is normal.
   - Power management mode: Prefer maximum performance. On recent drivers
     (616.xx) the setting does not always apply: check at idle with "nvidia-smi -q -d CLOCK"
     in a terminal, if the clocks drop back down at idle it is being ignored, and that is fine.
   - Shader cache size: Unlimited. The default (4 GB) fills up, an evicted shader recompiles
     mid-game: a frame time spike.
   - Texture filtering, quality: High performance.
   - Threaded optimization: On.
   - Vertical sync and G-Sync, two cases:
     . G-Sync / compatible screen: G-Sync enabled in "Set up G-SYNC", V-Sync "On" HERE
       in the Panel, V-Sync OFF in every game, and an FPS cap 3 to 4 under the screen's refresh rate
       (RivaTuner, Hard tutorial, or Reflex which does it on its own). This is the combination documented by
       Blur Busters: zero tearing, minimal latency. The "application-controlled" setting from the old tutorial
       let the game put its own classic V-Sync back on top of G-Sync.
     . Without G-Sync: V-Sync Off, RivaTuner cap alone, Reflex if the game has it.
     Game in windowed mode or on a hybrid laptop (Optimus): the Panel's V-Sync does not always
     apply, set it in the game instead.
   - OpenGL rendering GPU: your card, not "auto".
   - Smooth Motion (driver-side frame generation): never globally. Per game, single player only,
     never in competitive play (adds a frame of latency).
   Configure Surround, PhysX: PhysX on your NVIDIA card.
   Adjust desktop size and position: second monitor set to "No scaling".
   Change resolution: output dynamic range "Full", RGB format 4:4:4. The driver sometimes
   picks "Limited" on a TV or an HDMI monitor: blacks turn gray.

   Windows Settings > System > Display > Graphics:
   - "Optimizations for windowed games" on. Windows presents windowed frames like
     full screen ones, latency drops. Turn it back off if a game flickers.
   - Hardware-accelerated GPU scheduling (HAGS): keep it on. DLSS Frame Generation and
     Smooth Motion require it. Turning it off gains nothing on a recent card.
   - Auto HDR: off in competitive play, it adds processing per frame. On for single player games if the screen
     is genuinely HDR (600 nits and above).

3) MSI Afterburner and RivaTuner (button)
   Not for overclocking. For the fan curve and the RivaTuner overlay (FPS, frame time,
   temperatures). This is your tool to SEE that a tweak changes something instead of just believing it.
   Only one overlay at a time: RivaTuner OR Steam OR Discord OR the Game Bar. Two overlays
   stacked means one more hook per frame.

If you installed the NVIDIA App anyway (or a game forced it on you):
   Settings > Features: overlay OFF, Instant Replay OFF, Freestyle OFF. Games: "auto-optimize"
   OFF (it rewrites your settings). The rest of the tutorial applies the same way, the classic Panel
   and the App write to the same profile.
'@
$Textes['en']['reseau'] = @'
NETWORK CARD (5 min)

The checkbox script does all of this on its own, "Network card" group.
This tutorial is for doing it by hand or checking it. Screenshots: the two "Screenshot" buttons above.

Control Panel > Network and Sharing Center > Change adapter settings
> right-click your card > Properties.

1) Power management (Configure button > Power Management tab)
   Uncheck "Allow the computer to turn off this device to save power".
   Why: Windows turns the card off when idle, and it takes a second to come back.
   That is the "network dropped for 2 seconds" after sleep.

2) Advanced tab (screenshot "Advanced tab")
   - Energy Efficient Ethernet / Green Ethernet / Power Saving Mode: Disabled.
     The chip falls asleep between packets and wakes up with a delay.
   - Interrupt Moderation Rate: Medium, NOT Disabled. Disabled means more interrupts,
     more CPU time stolen from the game. Often missing on Realtek, too bad.
   - The rest: leave it at default. Jumbo Frame, Receive Buffers maxed out, etc.
     bring nothing in games, it is UDP in small packets.

3) Protocol list (screenshot "protocols"), what to uncheck
   - Microsoft LLDP Protocol Driver
   - Link-Layer Topology Discovery Responder
   - Link-Layer Topology Discovery Mapper I/O Driver
   These three map out the local network. Useless.
   KEEP: TCP/IPv4, TCP/IPv6 (games and Xbox Live use them), Client for Microsoft Networks
   and File and Printer Sharing if you have a NAS or shared folders, QoS Packet Scheduler
   if another device at home is downloading while you play.
'@
$Textes['fr'] = @{}
$Textes['fr']['accueil'] = @'
Ce pack enlève ce qui tourne pour rien et règle ce qui compte pour jouer.
Pas de sauvegarde avant : si ça casse, tu réinstalles, c'est le principe d'un Windows tout frais.

Suis les étapes dans l'ordre. Facile suffit pour un PC de bureau. Le script à cocher
est le vrai niveau pour jouer. Dur, tu comprends chaque ligne avant de cocher.

Règle du pack : chaque opti dit ce qu'elle change et ce que tu perds.
Tu ne comprends pas une ligne, tu ne la coches pas.

Les boutons "(winget)" ouvrent une console qui installe la version du jour de l'outil.
Win11Debloat et WinUtil se lancent tels quels, dans leur propre console.

Tout ce que le script à cocher modifie est noté dans C:\ProgramData\bagarre
(bagarre-avant.json pour les valeurs d'avant, bagarre.log pour le détail).
"Tout remettre comme avant" restaure exactement ces valeurs.

Pour rouvrir bagarre plus tard, la même commande dans un Terminal :
  irm https://raw.githubusercontent.com/klNuno/windows-bagarre/main/bagarre.ps1 | iex
'@
$Textes['fr']['audit'] = @'
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
$Textes['fr']['audit-prompt'] = @'
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
$Textes['fr']['dns'] = @'
Quad9 bloque les domaines malveillants connus et ne garde pas ton adresse IP dans ses journaux.
Cloudflare est en général le plus rapide. Google garde des journaux. Le DNS du FAI est souvent le plus
lent, sauf chez Free où il est très bon.

Un écart sous 5 ms ne se sent pas. Si ta box est à moins de 5 ms de la meilleure, garde-la.

Pour chiffrer le DNS choisi (DoH : ta box et ton FAI ne voient plus les noms demandés) :
Paramètres > Réseau et Internet > ta carte > Attribution du serveur DNS > Modifier > DNS chiffré :
Chiffré de préférence. Facultatif, zéro effet sur le ping.

"Tout remettre comme avant" (onglet 3) remet aussi le DNS d'avant.
'@
$Textes['fr']['dur'] = @'
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
$Textes['fr']['facile'] = @'
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
$Textes['fr']['installation'] = @'
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
$Textes['fr']['maintenance'] = @'
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
$Textes['fr']['nvidia'] = @'
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
$Textes['fr']['reseau'] = @'
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

# État partagé avec les gestionnaires d'événements de la fenêtre. Une table, jamais $script: :
# selon le lancement (-File, "irm | iex", scriptblock) le préfixe $script: ne désigne pas la même portée,
# alors qu'une lecture sans préfixe et une écriture dans cette table marchent dans les trois cas.
$S = @{ Langue = 'fr'; L = $null; ConsoleN = 0; DnsAdapt = $null; DnsResultats = @() }

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
$S.Langue = if ((Test-Path $LangueFichier) -and ((Get-Content $LangueFichier -Raw).Trim() -in 'fr', 'en')) { (Get-Content $LangueFichier -Raw).Trim() }
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
    if ($Journal) { $Journal.AppendText("$texte`r`n"); $Journal.ScrollToEnd(); Rafraichir }
}

# Laisse la fenêtre se redessiner pendant une action longue (tout tourne sur le thread de la fenêtre).
function Rafraichir {
    if ($Fenetre) { $Fenetre.Dispatcher.Invoke([Action] {}, [Windows.Threading.DispatcherPriority]::Background) }
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
$S.ConsoleN = 0
function Console-Lancer($titre, $commande) {
    $S.ConsoleN++
    $texte = "`$Host.UI.RawUI.WindowTitle = 'bagarre : $titre'`r`nWrite-Host ''`r`nWrite-Host '  $titre' -ForegroundColor Cyan`r`nWrite-Host ''`r`n$commande`r`n"
    $fichier = Join-Path $Dossier ("console-{0}.ps1" -f $S.ConsoleN)
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
    'jeu-timer' = @{ Titre = 'Allow fine timer resolution for games (GlobalTimerResolutionRequests)'; Pourquoi = 'Since Windows 11, an app that requests a 0.5 ms timer only gets it for itself and only in the foreground. This key restores the Windows 10 behavior: the request applies to the whole system. This is what Process Lasso or a timer resolution tool relies on.'; Attention = 'Idle power draw goes very slightly higher when a program requests a fine timer.' }
    'jeu-timer-demarrage' = @{ Titre = 'Timer at 0.507 ms on startup (SetTimerResolution as a scheduled task)'; Pourquoi = 'The companion to the key above: a 40-line program (SetTimerResolution, open source, GPL) requests a 0.507 ms timer as soon as you sign in and stays in memory. This is exactly what Process Lasso does, without the 30-second wait of the free version. 0.507 rather than 0.500: measured on more than 30 machines, the wake lands right on the tick. Check with MeasureSleep (Maintenance tab).'; Attention = 'Idle power draw a bit higher. On a laptop, leave this unchecked.' }
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
    'adv-dyntick' = @{ Titre = 'Turn off dynamic tick (bcdedit disabledynamictick)'; Pourquoi = 'The kernel stops its clock when nothing happens and restarts it on demand. With a 0.5 ms timer this can drift. Check this only if MeasureSleep shows an unstable resolution after setting the timer.'; Attention = 'Idle power draw a bit higher.' }
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
