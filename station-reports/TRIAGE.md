# Triage

Quick-glance summary of each station's hardware and what it's earmarked for. Full detail lives in [`reports/`](reports/).

**Build targets:**
- `LLM/Server` — candidate parts for the Frankenstein LLM/home server build
- `Retro Gaming` — candidate parts for employee retro gaming stations
- `Scrap` — not worth keeping

## Status

- **Stations assessed:** 1 (STATIONUNKNOWN)
- **In progress:** STATION78 — Acer/ASUS UEFI machine, blocked by Secure Boot ("Verification failed: 0x1A Security Violation"). Working on disabling Secure Boot (Boot → Secure Boot → OS Type → Other OS) to get it to boot the USB.
- **Open items:** PSU brand/wattage/rating not yet recorded for STATIONUNKNOWN; GPU undetermined for STATIONUNKNOWN (lspci/pci.ids error — needs visual check).

## Stations

| Station | CPU | RAM | Storage | GPU | AVX2 | Notes | Target |
|---|---|---|---|---|---|---|---|
| STATIONUNKNOWN | AMD Phenom II X4 955 @ 3.2GHz | 8GB (2x4GB, both slots populated, 2 free) | Samsung 850 EVO 120GB SSD | Unknown — lspci failed (pci.ids I/O error), needs manual check | No | Gigabyte GA-78LMT-S2P (AM3, 2012), no AVX2 → not LLM-suitable. PSU not yet checked. | Retro Gaming (likely) |
| STATION78 | TBD | TBD | TBD | TBD | TBD | Pending — Secure Boot blocking USB boot, in progress | TBD |

