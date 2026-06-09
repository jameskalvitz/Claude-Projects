#!/usr/bin/env bash
# Collects PC hardware info and saves output to the USB's output folder.
# Designed for Linux Mint live sessions booted from a Ventoy USB.
# Run as root (or with sudo) for full hardware access.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
HOSTNAME_LABEL="$(hostname 2>/dev/null || echo unknown)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTFILE="$OUTPUT_DIR/sysinfo_${HOSTNAME_LABEL}_${TIMESTAMP}.txt"

mkdir -p "$OUTPUT_DIR"

# --- helpers ----------------------------------------------------------------

run_section() {
    local title="$1"; shift
    printf '\n%s\n%s\n' "$title" "$(printf '=%.0s' {1..60})" >> "$OUTFILE"
    "$@" >> "$OUTFILE" 2>&1 || true
}

cmd_or_skip() {
    command -v "$1" &>/dev/null
}

# --- header -----------------------------------------------------------------

{
    echo "usb-sysinfo report"
    echo "Generated : $(date)"
    echo "Hostname  : $HOSTNAME_LABEL"
    echo "User      : $(whoami)"
    echo "Kernel    : $(uname -r)"
} > "$OUTFILE"

# --- CPU --------------------------------------------------------------------

run_section "CPU" lscpu

run_section "CPU flags (raw)" bash -c 'grep "^flags" /proc/cpuinfo | head -1'

# --- Memory -----------------------------------------------------------------

run_section "Memory overview" free -h

run_section "Memory detail (/proc/meminfo)" cat /proc/meminfo

if cmd_or_skip dmidecode; then
    run_section "DMI: Memory DIMMs" dmidecode -t memory
fi

# --- Storage ----------------------------------------------------------------

run_section "Block devices" lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL,SERIAL

run_section "Disk usage (mounted)" df -h --exclude-type=tmpfs --exclude-type=devtmpfs

if cmd_or_skip lshw; then
    run_section "lshw: Storage" lshw -class disk -class storage
fi

if cmd_or_skip smartctl; then
    # iterate over physical disks
    while IFS= read -r dev; do
        run_section "SMART: $dev" smartctl -a "$dev"
    done < <(lsblk -dno NAME | grep -E '^(sd|nvme|hd)' | sed 's|^|/dev/|')
fi

# --- Motherboard / System ---------------------------------------------------

if cmd_or_skip dmidecode; then
    run_section "DMI: System"      dmidecode -t system
    run_section "DMI: Baseboard"   dmidecode -t baseboard
    run_section "DMI: BIOS"        dmidecode -t bios
    run_section "DMI: Chassis"     dmidecode -t chassis
    run_section "DMI: Processor"   dmidecode -t processor
fi

# --- GPU --------------------------------------------------------------------

run_section "PCI devices" lspci

if cmd_or_skip lshw; then
    run_section "lshw: Display" lshw -class display
fi

if cmd_or_skip nvidia-smi; then
    run_section "NVIDIA GPU" nvidia-smi
fi

# --- Network ----------------------------------------------------------------

run_section "Network interfaces" ip -brief address

if cmd_or_skip lshw; then
    run_section "lshw: Network" lshw -class network
fi

# --- USB --------------------------------------------------------------------

run_section "USB devices (lsusb)" lsusb

if cmd_or_skip lshw; then
    run_section "lshw: USB" lshw -class bus
fi

# --- Firmware / Boot --------------------------------------------------------

if [ -d /sys/firmware/efi ]; then
    run_section "EFI variables" efibootmgr -v || true
else
    printf '\n%s\n%s\nSystem booted in BIOS/Legacy mode (no EFI).\n' \
        "Boot mode" "============================================================" >> "$OUTFILE"
fi

# --- Sensors ----------------------------------------------------------------

if cmd_or_skip sensors; then
    run_section "Sensors (lm-sensors)" sensors
fi

# --- Full lshw dump ---------------------------------------------------------

if cmd_or_skip lshw; then
    run_section "lshw full dump (HTML)" bash -c "lshw -html > \"$OUTPUT_DIR/lshw_${HOSTNAME_LABEL}_${TIMESTAMP}.html\" 2>&1 && echo 'Saved to lshw_${HOSTNAME_LABEL}_${TIMESTAMP}.html'"
fi

# --- Footer -----------------------------------------------------------------

echo "" >> "$OUTFILE"
echo "--- end of report ---" >> "$OUTFILE"

echo "Done. Report saved to:"
echo "  $OUTFILE"
