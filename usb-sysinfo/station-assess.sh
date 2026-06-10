#!/bin/bash
# QualFab PC Decommission — Hardware Assessment Script
# Pulls all hardware info and saves to a text file.
# Called by the launcher — not meant to be run directly.

HOSTNAME="$1"
OUTDIR="$2"

if [ -z "$HOSTNAME" ] || [ -z "$OUTDIR" ]; then
    echo "Usage: sudo bash station-assess.sh HOSTNAME OUTPUT_DIR" >&2
    exit 1
fi

mkdir -p "$OUTDIR" 2>/dev/null
OUTFILE="${OUTDIR}/${HOSTNAME}_hardware.txt"

{
echo "============================================="
echo " HARDWARE ASSESSMENT — ${HOSTNAME}"
echo " Date: $(date '+%Y-%m-%d %H:%M')"
echo "============================================="
echo ""

echo "--- TOOLS AVAILABLE ---"
for tool in dmidecode lscpu lspci lsblk hdparm smartctl lshw; do
    if command -v "$tool" &>/dev/null; then
        echo "  $tool: YES"
    else
        echo "  $tool: NOT FOUND (some info will be missing)"
    fi
done
echo ""

echo "--- SYSTEM IDENTITY ---"
echo "Hostname tag: ${HOSTNAME}"
dmidecode -t system 2>/dev/null | grep -E 'Manufacturer|Product Name|Serial Number|SKU'
dmidecode -t bios 2>/dev/null | grep -E 'Vendor|Version|Release Date'
echo ""

echo "--- CPU ---"
lscpu 2>/dev/null | grep -E 'Model name|Socket|Core\(s\)|Thread\(s\)|CPU max|CPU min|Architecture'
echo ""
echo "AVX2 Support: $(grep -o 'avx2' /proc/cpuinfo | head -1 || echo 'NO')"
if [ -z "$(grep -o 'avx2' /proc/cpuinfo | head -1)" ]; then
    echo "AVX2 Support: NO"
fi
echo ""

echo "--- MEMORY ---"
echo "Total Installed: $(free -h | awk '/Mem:/{print $2}')"
echo ""
echo "Max Capacity:"
dmidecode -t memory 2>/dev/null | grep -E 'Maximum Capacity|Number Of Devices'
echo ""
echo "DIMM Slots:"
dmidecode -t memory 2>/dev/null | awk '/Memory Device/,/^$/' | grep -E 'Locator:|Size:|Type:|Speed:|Manufacturer:|Part Number:' | grep -v 'Error Correction\|Unknown\|Not Specified'
echo ""

echo "--- STORAGE ---"
echo "Block Devices (excluding live USB):"
USB_BOOT=$(findmnt -n -o SOURCE / 2>/dev/null | sed 's/[0-9]*$//' | sed 's|/dev/||')
lsblk -d -o NAME,SIZE,MODEL,ROTA,TRAN 2>/dev/null | grep -v "loop\|sr\|${USB_BOOT:-NOUSBMATCH}"
echo ""
echo "Drive Details:"
for disk in /dev/sd? /dev/nvme?n?; do
    [ -e "$disk" ] || continue
    # Skip the USB boot drive
    if [ -n "$USB_BOOT" ] && echo "$disk" | grep -q "$USB_BOOT"; then
        continue
    fi
    echo "  === $disk ==="
    hdparm -I "$disk" 2>/dev/null | grep -E 'Model Number|Serial Number|device size|Transport' | sed 's/^[[:space:]]*/    /'
    smartctl -i "$disk" 2>/dev/null | grep -E 'Model|Serial|Capacity|Rotation|Form Factor' | sed 's/^/    /'
    smartctl -H "$disk" 2>/dev/null | grep -E 'result|Status' | sed 's/^/    /'
    echo ""
done

echo "--- GPU ---"
echo "Detected GPUs:"
lspci | grep -iE 'vga|3d|display'
echo ""
for gpu_addr in $(lspci | grep -iE 'vga|3d|display' | awk '{print $1}'); do
    echo "  === GPU at ${gpu_addr} ==="
    lspci -v -s "$gpu_addr" 2>/dev/null | grep -iE 'Subsystem|Memory|prefetchable|Kernel driver' | sed 's/^/    /'
    echo ""
done
echo "Nvidia GPU Present: $(lspci | grep -qi nvidia && echo 'YES' || echo 'NO')"
VRAM_LINE=$(lspci -v 2>/dev/null | grep -A5 -iE 'vga|3d|display' | grep -i 'prefetchable' | head -1)
if [ -n "$VRAM_LINE" ]; then
    echo "GPU Memory Region: $VRAM_LINE"
fi
echo ""

echo "--- MOTHERBOARD ---"
dmidecode -t baseboard 2>/dev/null | grep -E 'Manufacturer|Product Name|Serial Number|Version'
echo ""

echo "--- EXPANSION SLOTS ---"
dmidecode -t slot 2>/dev/null | awk '/System Slot/,/^$/' | grep -E 'Designation|Type|Current Usage|Length'
echo ""

echo "--- OPTICAL DRIVES ---"
if ls /dev/sr* &>/dev/null; then
    lsblk -d -o NAME,SIZE,MODEL | grep -i 'sr'
    echo "Capabilities:"
    cat /proc/sys/dev/cdrom/info 2>/dev/null | grep -E 'drive name|Can read|Can write|Can read Blu'
else
    echo "None detected"
fi
echo ""

echo "--- NETWORK ADAPTERS ---"
lspci | grep -iE 'ethernet|network|wifi|wireless'
echo ""
echo "MAC Addresses:"
ip link show 2>/dev/null | grep -E 'link/ether' | awk '{print "  " $2}'
echo ""

echo "--- CHASSIS / CASE ---"
dmidecode -t chassis 2>/dev/null | grep -E 'Manufacturer|Type|Height'
echo ""

echo "--- POWER SUPPLY ---"
echo "*** CANNOT DETECT VIA SOFTWARE ***"
echo "Physically check the PSU label and note:"
echo "  - Brand/Model:"
echo "  - Wattage:"
echo "  - 80 PLUS rating:"
echo "  - Modular? (Yes/No):"
echo ""

echo "--- FULL PCI DEVICE LIST ---"
lspci
echo ""

echo "--- HARDWARE TREE ---"
lshw -short 2>/dev/null
echo ""

echo "============================================="
echo " END ASSESSMENT — ${HOSTNAME}"
echo "============================================="

} > "$OUTFILE" 2>&1

echo "$OUTFILE"
