# Project Notes

Running log of decisions, gotchas, and follow-ups for the QualFab decommission project. Add new entries at the top.

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
