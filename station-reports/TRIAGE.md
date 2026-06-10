# Triage

Quick-glance summary of each station's hardware and what it's earmarked for. Full detail lives in [`reports/`](reports/).

**Build targets:**
- `LLM/Server` — candidate parts for the Frankenstein LLM/home server build
- `Retro Gaming` — candidate parts for employee retro gaming stations
- `Scrap` — not worth keeping

| Station | CPU | RAM | Storage | GPU | AVX2 | Notes | Target |
|---|---|---|---|---|---|---|---|
| STATIONUNKNOWN | AMD Phenom II X4 955 @ 3.2GHz | 8GB (2x4GB, both slots populated, 2 free) | Samsung 850 EVO 120GB SSD | Unknown — lspci failed (pci.ids I/O error), needs manual check | No | Gigabyte GA-78LMT-S2P (AM3, 2012), no AVX2 → not LLM-suitable. PSU not yet checked. | Retro Gaming (likely) |
