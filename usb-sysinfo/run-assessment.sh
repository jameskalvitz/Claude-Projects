#!/bin/bash
# QualFab PC Decommission — Easy Launcher
# Double-click this from the file manager or run: sudo bash run-assessment.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
mkdir -p "$OUTPUT_DIR"

get_hostname() {
    if command -v zenity &>/dev/null && [ -n "$DISPLAY" ]; then
        zenity --entry \
            --title="QualFab Station Assessment" \
            --text="Enter station hostname (e.g. STATION90):" \
            --entry-text="STATION" \
            --width=400 2>/dev/null
    else
        echo "" >&2
        echo "==================================" >&2
        echo " QualFab Station Assessment Tool" >&2
        echo "==================================" >&2
        echo "" >&2
        read -p "Enter station hostname (e.g. STATION90): " name </dev/tty
        echo "$name"
    fi
}

show_result() {
    local msg="$1"
    if command -v zenity &>/dev/null && [ -n "$DISPLAY" ]; then
        zenity --info \
            --title="Assessment Complete" \
            --text="$msg" \
            --width=400 2>/dev/null
    else
        echo "" >&2
        echo "$msg" >&2
        echo "" >&2
        read -p "Press Enter to exit..." </dev/tty
    fi
}

show_error() {
    local msg="$1"
    if command -v zenity &>/dev/null && [ -n "$DISPLAY" ]; then
        zenity --error --text="$msg" --width=300 2>/dev/null
    else
        echo "ERROR: $msg" >&2
    fi
}

STATION_NAME=$(get_hostname)

if [ -z "$STATION_NAME" ]; then
    show_error "No hostname entered. Cancelled."
    exit 1
fi

STATION_NAME=$(echo "$STATION_NAME" | tr '[:lower:]' '[:upper:]')

if [ "$EUID" -ne 0 ]; then
    echo "Elevating to root for hardware access..."
    sudo bash "$SCRIPT_DIR/station-assess.sh" "$STATION_NAME" "$OUTPUT_DIR"
    RESULT="${OUTPUT_DIR}/${STATION_NAME}_hardware.txt"
else
    "$SCRIPT_DIR/station-assess.sh" "$STATION_NAME" "$OUTPUT_DIR"
    RESULT="${OUTPUT_DIR}/${STATION_NAME}_hardware.txt"
fi

if [ -f "$RESULT" ]; then
    show_result "Done! Saved to:\n${RESULT}\n\nYou can shut down and move to the next machine."
else
    show_error "Something went wrong — no output file created.\nTry running manually:\n\nsudo bash $SCRIPT_DIR/station-assess.sh $STATION_NAME $OUTPUT_DIR"
fi
