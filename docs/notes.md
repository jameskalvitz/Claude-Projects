# Project Notes

Running log of decisions, gotchas, and follow-ups for the QualFab decommission project. Add new entries at the top.

## Infrastructure updates

- **2026-06-12** — Phone backup pipeline started. Installed Syncthing on jkhomeserver (v1.18.0, systemd service `syncthing@jkhomeserver`, enabled on boot). Paired with Galaxy S22 Ultra (Syncthing on Android 16). Both devices have auto-accept folders ON. Backup destination: `/mnt/rdisk/backups/jimmys-phone/`. Phone set to WiFi-only sync. Still needs: Termius SSH profiles on phone, folder config, first full sync, verify, then wipe phone.
  - Server Device ID: `KU52ZKF-YG62GMD-WFDGF2B-BI4ECXU-CUIMZND-HA5V2LB-6BJ5HTR-I7G7WAW`
  - Phone Device ID: `AWVG2DF-7FQ4KPJ-HPEI4XB-O42ZM2D-5OJD3YP-E24U76R-YCXBTRN-G6RXMQ4`
  - Server SSH: `jkhomeserver@100.105.103.112`
- **2026-06-12** — Set up remote access to Surface (linux-mint-sb2) from work Windows PC via Tailscale. SSH (openssh-server) and xrdp both enabled and start on boot. Connect via Tailscale IP 100.104.139.84. Use `ssh jimmy@100.104.139.84` or `mstsc` (Remote Desktop) from Windows.
- **2026-06-12** — Set up msmtp + mailx on Surface with Gmail (gaborarecords@gmail.com) for sending emails/alerts. Config at `~/.msmtprc`. jkhomeserver still needs same setup.
- **2026-06-12** — Synced local Claude-Projects clone (`~/Claude-Projects/`) with GitHub — was 8 commits behind. Now current.

## Cross-Reference Phase — Rules

These rules govern how parts get matched across all stations once assessment is complete. **Do not begin any builds until ALL machines are assessed.**

- Match the best GPU to the best case with the best PSU.
- Keep matched RAM pairs together — never split a kit.
- DDR3 RAM stays with DDR3-compatible builds only.
- FirePro V7900 + EVGA 430W are a natural pair — enough wattage for that card.
- GTX 750 only needs ~300W — can pair with lower-wattage PSUs found later.
- LLM build gets first pick of any Nvidia GTX 1080+ found in remaining machines.
- If no LLM-capable GPU (Nvidia GTX 1080+) is found in salvage, the LLM build is not possible from salvage alone.

## Open follow-ups

- [ ] PSU brand/wattage/80 PLUS rating — not yet recorded for STATIONUNKNOWN or STATION78 (needs physical label check)
- [ ] STATIONUNKNOWN — GPU undetermined (`lspci` failed with `pci.ids I/O error`), needs visual check inside the case
- [ ] STATION78 — BIOS is AMI version 2005 (06/03/2014), original/factory. Check ASUS Z87-A support page for newer BIOS before any CPU upgrade.

## Decisions

- **2026-06-10** — STATION78 (i5-4690K, AVX2, ASUS Z87-A) is the current top candidate for the LLM/server "Frankenstein" build. Has 3 free DIMM slots (max 32GB) and 2 free PCIe x16 slots for a future GPU.
- **2026-06-10** — STATIONUNKNOWN (Phenom II X4 955, no AVX2) leans toward Retro Gaming rather than the LLM build.
- **2026-06-10** — STATION53 (FX-8300, no AVX2, has AMD FirePro V4900 dGPU) leans toward Retro Gaming. Its 8 cores are decent for older games, and the FirePro V4900 (256MB VRAM) could be pulled as a donor GPU for another build if needed (it's weak/old, mainly useful for basic display output).

## Gotchas / lessons learned

- The Ventoy USB's data partition mount point isn't predictable — use `lsblk` to find which `/dev/sdX1` is the USB, then check `mount` for where it landed (e.g. `/media/mint/<volume-id>`). `/cdrom` is just the loop-mounted ISO (read-only), not the USB's file storage.
- `smartctl` is not present on the live Mint image — drive age/health (SMART data) isn't captured.
- If a machine throws "Verification failed: 0x1A Security Violation" on boot, it's a Secure Boot block — go into BIOS (Boot → Secure Boot → OS Type → "Other OS") to disable it.
- `run-assessment.sh` sanitizes the typed station name to `A-Z0-9_-` — if you see "Hostname contained no valid characters," it usually means a transient I/O error reading binaries off the USB (re-copy the ISO / re-seat the USB), not a typing issue.
