# Claude-Projects — Project Context

This file gives any Claude Code session (web or local) the background needed to pick up where things left off. Read this first.

## The big picture

James is decommissioning a fleet of old office PCs (the "QualFab" project). For each machine:

1. Boot it from a Ventoy USB running Linux Mint (fully offline).
2. Run `usb-sysinfo/run-assessment.sh` to scan its hardware.
3. Log the results in `station-reports/`.

Goal: pull good parts together into one **"Frankenstein" machine for local LLM inference / home server**, build a couple **retro gaming PCs** for employees out of decent leftover parts, and **scrap** anything not worth keeping.

## Repo layout

- `usb-sysinfo/` — the assessment scripts that live on the Ventoy USB (`run-assessment.sh`, `station-assess.sh`, `INSTRUCTIONS.txt`)
- `station-reports/` — collected hardware reports (`reports/*.txt`) and `TRIAGE.md`, the running summary table + build assignments
- `docs/notes.md` — running log of decisions, gotchas, and follow-ups (this is the "memory" file — keep it updated)

## Key things to know

- The Ventoy USB's data partition doesn't always auto-mount at a predictable path — check with `lsblk` / `mount` if `cd` to the assess folder fails.
- `smartctl` isn't available on the live image, so SMART/drive-age data is missing from reports.
- `lspci` sometimes fails with `pci.ids I/O error` on some machines — GPU/PCI device names may be missing in those reports; needs a manual visual check.
- AVX2 support is the key filter for LLM-suitability (CPU inference needs it).

## Current status

See `station-reports/TRIAGE.md` for the full table. As of the last update:
- **STATIONUNKNOWN** — AMD Phenom II X4 955, no AVX2 → leaning Retro Gaming
- **STATION78** — Intel i5-4690K w/ AVX2, ASUS Z87-A, room to expand RAM/GPU → top LLM/server candidate (BIOS is outdated, AMI 2005 from 06/03/2014 — check ASUS site for updates before any CPU swap)

See `docs/notes.md` for more detail and open follow-ups.
