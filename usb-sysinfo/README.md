# usb-sysinfo

Collects PC hardware info when booted from a Ventoy USB running Linux Mint and saves the output back to the USB's own `output/` folder — no internet required.

## What it collects

| Category | Tools used |
|---|---|
| CPU | `lscpu`, `/proc/cpuinfo` |
| Memory | `free`, `/proc/meminfo`, `dmidecode` |
| Storage | `lsblk`, `df`, `lshw`, `smartctl` |
| Motherboard / BIOS | `dmidecode` (system, baseboard, bios, chassis, processor) |
| GPU | `lspci`, `lshw`, `nvidia-smi` |
| Network | `ip`, `lshw` |
| USB | `lsusb`, `lshw` |
| Boot mode | EFI vars via `efibootmgr` or BIOS note |
| Sensors | `lm-sensors` |
| Full hardware dump | `lshw -html` |

Tools are detected at runtime — sections are skipped gracefully if a tool isn't present on the live image.

## Setup (one-time, on the USB)

```
usb-sysinfo/
├── usb-sysinfo.sh   ← the script
└── output/          ← reports land here (created automatically)
```

No installation needed. The script writes everything relative to its own directory, so it works wherever the USB is mounted.

## Usage

Boot the target PC from the Ventoy USB into a Linux Mint live session, open a terminal, then:

```bash
# Navigate to the script on the USB (path will vary)
cd /media/mint/VENTOY/usb-sysinfo   # adjust mount point as needed

# Run as root for full hardware access (dmidecode, smartctl, etc.)
sudo bash usb-sysinfo.sh
```

Output files are saved to `output/` next to the script:

- `sysinfo_<hostname>_<timestamp>.txt` — main text report
- `lshw_<hostname>_<timestamp>.html`   — full lshw HTML dump

## Finding the USB mount point

```bash
lsblk -o NAME,LABEL,MOUNTPOINT | grep -i ventoy
# or
findmnt -t vfat
```

## Notes

- Fully offline — no packages are downloaded or installed.
- Safe to run on a live session; nothing is written to the target machine's disks.
- `smartctl` and `dmidecode` require root; the script proceeds without them if run unprivileged, but output will be incomplete.
- If `lm-sensors` hasn't been run on this live session before, sensor readings may be absent. Run `sudo sensors-detect --auto` first if needed.
