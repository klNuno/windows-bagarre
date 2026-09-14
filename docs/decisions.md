# Decisions

What the pack refuses, and why. Each entry is a call the maintainer made once; the window does not argue about it, this page does. A tweak enters the pack with a written, dated source (vendor doc, Microsoft doc, maintained repo), never on the strength of a video.

## Security left alone

- HVCI / memory integrity stays on. The measured cost is 1 to 3 % in games, and the big anti-cheats (EAC, Vanguard, FACEIT) either require it or will. Turning it off to gain three frames and lose a launcher is a bad trade.
- Secure Boot, Defender, the firewall, Windows Update and UAC stay. The pack cuts what Defender scans while you play (a recording, then an exclusion on the game folder), it never cuts Defender. Same for updates: drivers are excluded from Windows Update, the updates themselves keep coming.
- No exclusion on the whole drive or on Downloads. That is where the nasty stuff arrives.

## Tools we do not recommend

- Registry cleaners. Nothing to gain, everything to break. A registry with orphan keys is not slower; a registry with a key deleted by mistake does not boot.
- Paid "optimizers" and 200-changes-in-one-click scripts. You cannot know what changed, so you cannot undo it. Every line of the checkbox script says what it changes and what you lose, and saves the previous value first.
- A timer resolution tool running in the background. Since Windows 10 2004, a game asks for the 0.5 ms timer itself. The pack sets `GlobalTimerResolutionRequests = 1` so that request is honored system-wide, and stops there. A tool that forces it permanently burns power for nothing.
- DDU on a fresh install. The pack installs the bare driver on a clean Windows. DDU is for a brand switch or a broken driver, which is a repair, not a setup step.
- CompactGUI, BleachBit, DriverStore Explorer, TRIM by hand. Storage Sense, Disk Cleanup and DISM cover the same ground with less risk, and TRIM already runs monthly.

## Windows settings we do not touch

- No "Ultimate performance" plan. Identical to High performance since 1903, and High performance itself only removes core parking and idle states that Windows 11 already manages well.
- No prefetch / superfetch tweak. SysMain on an SSD costs nothing measurable and speeds up the first launch of a game after a reboot.
- No "unlock the 20 % reserved bandwidth". The QoS packet scheduler reserves nothing unless an application asks. The 20 % story comes from a 2001 Windows XP misreading.
- No LargeSystemCache, IRQ8Priority, mouse or keyboard data queue size, TcpWindowSize, HPET off, TdrLevel, IPv6 off, C-states off, page file off, Interrupt Moderation Disabled. Either placebo (no reproducible measurement published) or harmful (stutter, crashes on out-of-memory, a network card that interrupts on every packet).
- No core parking change by default. It stays a box, unticked, because on a Ryzen X3D core parking is what keeps a game on the cache CCD.
- F8 boot menu stays on. It costs one key press at boot and saves a reinstall when Windows will not start.
- No BIOS step, no backup step. A fresh Windows is the backup: if it breaks, you reinstall. BIOS settings differ per board and cannot be reverted from the window.

## Graphics driver

- NVIDIA Control Panel (the OG one) rather than the NVIDIA App. The App carries an overlay, telemetry, an auto-optimizer and a login. The Control Panel carries the three settings the pack needs.
- HDCP off in NVCleanstall. HDCP only matters for protected 4K video in a browser, and its handshake causes micro-cuts on alt-tab. The window says what you lose (Netflix and Disney+ in 4K in the browser), and the box is one click to untick.
- Rebuild digital signature, Easy Anti-Cheat compatible method. The driver file stays intact, only the installer is re-signed. Validated by the maintainer on the usual anti-cheats; the window says to reinstall without it if a game refuses to start.
- MPO off. Multiplane Overlay is behind the black screens, flicker and windowed stutter NVIDIA has documented since 2022 (article 5157), and AMD cards see the same. Off, the compositor draws everything: zero effect in full screen, a little more GPU for a video in a window. NVCleanstall and the checkbox script set the same key.
- No global "max performance", texture filtering, V-Sync, G-Sync or Smooth Motion setting. Max performance keeps the card at full clocks on the desktop for nothing; texture filtering on "performance" blurs distant textures for no measurable gain; V-Sync and G-Sync depend on the screen; Smooth Motion is off by default. All of them are per-game calls, so the window leaves them at default.

## Process priority tools

- ThreadPilot and Process Lasso, side by side, no ranking. Both set a priority and cores per program. ThreadPilot is open source, free, Windows 11 only. Process Lasso is free with a purchase reminder, has ProBalance, and turns off some advanced features after 14 days without the paid edition. The window describes both and lets the user pick; if there is no stutter, neither is needed.

## Measuring

- No CapFrameX step. MSI Afterburner and RivaTuner already show frame time in the overlay, which is enough to see whether a tweak does anything. A three-run benchmark protocol is a good idea, but it belongs to the person who wants to publish numbers, not to a setup pack.
