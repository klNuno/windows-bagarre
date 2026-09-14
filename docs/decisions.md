# Decisions

This page lists what the pack refuses to do and why. The maintainer made each call once, so the window does not argue about them. A tweak enters the pack with a written and dated source (vendor documentation, Microsoft documentation, a maintained repository). A video is not a source.

## Security stays on

- HVCI (memory integrity) stays on. It costs 1 to 3 % in games, and the main anti-cheats (EAC, Vanguard, FACEIT) either require it or will soon. Losing a launcher to gain three frames is a bad trade.
- Secure Boot, Defender, the firewall, Windows Update and UAC stay on. The pack reduces what Defender scans while you play, with a recording followed by an exclusion on the game folder. It never turns Defender off. Drivers are excluded from Windows Update, the updates themselves keep coming.
- No exclusion on a whole drive or on Downloads, because that is where viruses arrive.

## Tools the pack does not recommend

- Registry cleaners. A registry with orphan keys is not slower, and a registry with a key deleted by mistake does not boot.
- Paid "optimizers" and scripts that make 200 changes in one click. You cannot know what changed, so you cannot undo it. Every line of the checkbox script says what it changes and what you lose, and saves the previous value first.
- A timer resolution tool running in the background. Since Windows 10 2004, a game asks for the 0.5 ms timer itself. The pack sets `GlobalTimerResolutionRequests = 1` so that request is honored system-wide, and stops there. A tool that forces it permanently burns power for nothing.
- DDU on a fresh install. The pack installs the driver on a clean Windows. DDU is for a brand switch or a broken driver, which is a repair, not a setup step.
- CompactGUI, BleachBit, DriverStore Explorer and TRIM by hand. Storage Sense, Disk Cleanup and DISM cover the same ground with less risk, and Windows already runs TRIM monthly.

## Windows settings the pack does not touch

- No "Ultimate performance" plan. It has been identical to High performance since 1903, and High performance only removes core parking and idle states that Windows 11 already manages well.
- No prefetch or superfetch tweak. SysMain on an SSD costs nothing measurable and speeds up the first launch of a game after a reboot.
- No "unlock the 20 % reserved bandwidth". The QoS packet scheduler reserves nothing unless an application asks for it. The 20 % story comes from a misreading of a Windows XP article from 2001.
- No LargeSystemCache, IRQ8Priority, mouse or keyboard data queue size, TcpWindowSize, HPET off, TdrLevel, IPv6 off, C-states off, page file off or Interrupt Moderation Disabled. Each one is either a placebo (no reproducible measurement published) or harmful (stutter, crashes when memory runs out, a network card that interrupts on every packet).
- No core parking change by default. It stays a box, unticked, because on a Ryzen X3D core parking is what keeps a game on the cache CCD.
- The F8 boot menu stays on. It costs one key press at boot and saves a reinstall when Windows will not start.
- No BIOS step and no backup step. A fresh Windows is the backup, so if it breaks you reinstall. BIOS settings differ per board and cannot be reverted from the window.

## Graphics driver

- The NVIDIA Control Panel (the OG one) rather than the NVIDIA App. The App carries an overlay, telemetry, an auto-optimizer and a login. The Control Panel carries the three settings the pack needs.
- HDCP off in NVCleanstall. HDCP only matters for protected 4K video in a browser, and its handshake causes short cuts on alt-tab. The window says what you lose (Netflix and Disney+ in 4K in the browser), and the box is one click to untick.
- Rebuild digital signature, with the Easy Anti-Cheat compatible method. The driver file stays intact, only the installer is re-signed. The maintainer validated it on the usual anti-cheats, and the window says to reinstall without it if a game refuses to start.
- MPO off. Multiplane Overlay is behind the black screens, flicker and windowed stutter NVIDIA has documented since 2022 (article 5157), and AMD cards see the same. Once off, the compositor draws everything, with no effect in full screen and a little more GPU work for a video in a window. The checkbox script sets the key, not NVCleanstall, so "Restore everything" can put it back.
- No global "max performance", texture filtering, V-Sync, G-Sync or Smooth Motion setting. Max performance keeps the card at full clocks on the desktop for nothing. Texture filtering on "performance" blurs distant textures for no measurable gain. V-Sync and G-Sync depend on the screen. Smooth Motion is off by default. All of them are per-game calls, so the window leaves them at default.

## Process priority tools

- ThreadPilot and Process Lasso are shown side by side, without ranking. Both set a priority and cores per program. ThreadPilot is open source, free and Windows 11 only. Process Lasso is free with a purchase reminder, has ProBalance, and turns off some advanced features after 14 days without the paid edition. The window describes both and lets the user pick. If there is no stutter, neither is needed.

## Measuring

- No CapFrameX step. MSI Afterburner and RivaTuner already show frame time in the overlay, which is enough to see whether a tweak does anything. A three-run benchmark protocol belongs to someone who wants to publish numbers, not to a setup pack.
