# Triage

Quick-glance summary of each station's hardware and what it's earmarked for. Full detail lives in [`reports/`](reports/).

**Build targets:**
- `LLM/Server` — candidate parts for the Frankenstein LLM/home server build
- `Retro Gaming` — candidate parts for employee retro gaming stations
- `Scrap` — not worth keeping

## Status

- **Stations assessed:** 2 (STATIONUNKNOWN, STATION78)
- **Open items:** PSU brand/wattage/rating not yet recorded for either station; GPU undetermined for STATIONUNKNOWN (lspci/pci.ids error — needs visual check).

## Stations

| Station | CPU | RAM | Storage | GPU | AVX2 | Notes | Target |
|---|---|---|---|---|---|---|---|
| STATIONUNKNOWN | AMD Phenom II X4 955 @ 3.2GHz | 8GB (2x4GB, both slots populated, 2 free) | Samsung 850 EVO 120GB SSD | Unknown — lspci failed (pci.ids I/O error), needs manual check | No | Gigabyte GA-78LMT-S2P (AM3, 2012), no AVX2 → not LLM-suitable. PSU not yet checked. | Retro Gaming (likely) |
| STATION78 | Intel Core i5-4690K @ 3.5GHz (4c/4t) | 8GB DDR3-1600 (1x8GB, 3 of 4 slots free, max 32GB) | Samsung 850 PRO 128GB SSD | Intel HD 4600 (iGPU, no dGPU) | Yes | ASUS Z87-A (LGA1150, 2014), gigabit Ethernet, 5x PCIe slots (2x x16) free for a future GPU. PSU not yet checked. | **LLM/Server (top candidate)** |

