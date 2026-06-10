# usb-sysinfo — QualFab Station Assessment Tool

Hardware assessment scripts for the QualFab PC decommission project. Boots any machine from a Ventoy USB running Linux Mint, scans all hardware, and saves a report to the USB. Fully offline — no internet required.

## What it collects

| Category | Details | Tools |
|---|---|---|
| System ID | Manufacturer, model, service tag, BIOS date | `dmidecode` |
| CPU | Model, cores/threads, clock, architecture, AVX2 support | `lscpu`, `/proc/cpuinfo` |
| Memory | Per-DIMM: size, speed, type, manufacturer, part number, slot. Max capacity + total slots | `dmidecode`, `free` |
| Storage | Model, serial, capacity, SSD vs HDD, SMART health | `lsblk`, `hdparm`, `smartctl` |
| GPU | Model, VRAM region, Nvidia detection (for LLM screening) | `lspci` |
| Motherboard | Manufacturer, model, serial | `dmidecode` |
| Expansion slots | Slot types (x16/x8/x4/x1), usage status | `dmidecode` |
| Optical drives | Model, read/write/Blu-ray capabilities | `/proc/sys/dev/cdrom/info` |
| Network | NIC models, MAC addresses | `lspci`, `ip` |
| Chassis | Type, manufacturer | `dmidecode` |
| Full device list | All PCI devices + hardware tree | `lspci`, `lshw` |

Only the **PSU** cannot be detected by software — check the label physically.

## USB layout

```
Ventoy/
├── linuxmint-22.3-cinnamon-64bit.iso   (boots via Ventoy menu)
├── qualfab-assess/
│   ├── run-assessment.sh                (launcher — double-click this)
│   ├── station-assess.sh                (hardware scanner)
│   ├── INSTRUCTIONS.txt                 (step-by-step for use at work)
│   └── output/                          (reports saved here)
```

## Usage

1. Plug USB into machine, power on, hit boot menu key (F12 Dell, F9 HP, F12 Lenovo)
2. Select USB, pick Linux Mint from Ventoy menu
3. Open file manager, navigate to USB, open `qualfab-assess/`
4. Double-click `run-assessment.sh` — popup asks for hostname
5. Type station name (e.g. `STATION90`), hit enter, wait ~10 seconds
6. Shut down, move to next machine

Reports save to `qualfab-assess/output/` as `STATIONXX_hardware.txt`.

## LLM build screening

Each assessment automatically checks:
- CPU AVX2 support (required for Ollama/LLM inference)
- Nvidia GPU present (yes/no)
- GPU memory region size

## Scripts

| File | Purpose |
|---|---|
| `run-assessment.sh` | Launcher — prompts for the station hostname in a terminal (relaunches via `xterm` if double-clicked outside one). |
| `station-assess.sh` | Core scanner. Pulls all hardware info and writes to a single text file. |
| `usb-sysinfo.sh` | Original generic version (kept for reference). |
