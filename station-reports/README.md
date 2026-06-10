# Station Reports — PC Decommission / Parts Triage

Hardware reports collected from old office machines via the [usb-sysinfo](../usb-sysinfo/) QualFab USB, used to decide what gets:

- **Frankenstein build** — best parts pulled together into one machine for local LLM inference / home server
- **Retro gaming stations** — decent leftover parts built into machines for employees
- **Scrap** — anything not worth keeping

## Workflow

1. Run `usb-sysinfo/run-assessment.sh` on each station, producing `STATIONXX_hardware.txt`.
2. Drop that file into [`reports/`](reports/) (just copy it from the USB's `output/` folder).
3. Add a row for the station in [`TRIAGE.md`](TRIAGE.md) summarizing its key parts and your decision.

## Folder layout

```
station-reports/
├── README.md
├── TRIAGE.md          ← summary table + build assignments
└── reports/
    ├── STATION90_hardware.txt
    ├── STATION91_hardware.txt
    └── ...
```
