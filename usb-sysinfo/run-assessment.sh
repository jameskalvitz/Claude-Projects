#!/bin/bash
# QualFab PC Decommission — Easy Launcher
# Double-click this from the file manager or run: sudo bash run-assessment.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
mkdir -p "$OUTPUT_DIR"

if [ "$EUID" -ne 0 ]; then
    pkexec bash "$0" "$@"
    exit $?
fi

install_if_missing() {
    for pkg in "$@"; do
        if ! dpkg -l "$pkg" &>/dev/null; then
            apt-get install -y "$pkg" 2>/dev/null
        fi
    done
}

install_if_missing smartmontools hdparm lshw

if command -v zenity &>/dev/null; then
    HOSTNAME=$(zenity --entry \
        --title="QualFab Station Assessment" \
        --text="Enter station hostname (e.g. STATION90):" \
        --entry-text="STATION" \
        --width=400 2>/dev/null)

    if [ -z "$HOSTNAME" ]; then
        zenity --error --text="No hostname entered. Cancelled." --width=300 2>/dev/null
        exit 1
    fi

    HOSTNAME=$(echo "$HOSTNAME" | tr '[:lower:]' '[:upper:]')

    zenity --info --text="Scanning hardware for ${HOSTNAME}...\nThis takes about 10 seconds." --width=300 --timeout=3 2>/dev/null &

    RESULT=$("$SCRIPT_DIR/station-assess.sh" "$HOSTNAME" "$OUTPUT_DIR")

    zenity --info \
        --title="Assessment Complete" \
        --text="Done! Saved to:\n${RESULT}\n\nYou can shut down and move to the next machine." \
        --width=400 2>/dev/null
else
    echo ""
    echo "=================================="
    echo " QualFab Station Assessment Tool"
    echo "=================================="
    echo ""
    read -p "Enter station hostname (e.g. STATION90): " HOSTNAME

    if [ -z "$HOSTNAME" ]; then
        echo "No hostname entered. Cancelled."
        exit 1
    fi

    HOSTNAME=$(echo "$HOSTNAME" | tr '[:lower:]' '[:upper:]')

    echo ""
    echo "Scanning hardware for ${HOSTNAME}..."
    echo ""

    RESULT=$("$SCRIPT_DIR/station-assess.sh" "$HOSTNAME" "$OUTPUT_DIR")

    echo ""
    echo "Done! Saved to: ${RESULT}"
    echo ""
    echo "You can shut down and move to the next machine."
    echo ""
    read -p "Press Enter to exit..."
fi
