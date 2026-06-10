#!/bin/bash
# QualFab PC Decommission — Easy Launcher
# Double-click this from the file manager or run: bash run-assessment.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
mkdir -p "$OUTPUT_DIR"

echo ""
echo "==================================="
echo " QualFab Station Assessment Tool"
echo "==================================="
echo ""

if [ -t 0 ]; then
    read -p "Enter station hostname (e.g. STATION90): " STATION_NAME
else
    exec xterm -hold -e bash "$0" "$@"
    exit $?
fi

if [ -z "$STATION_NAME" ]; then
    echo "No hostname entered. Cancelled."
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

STATION_NAME=$(echo "$STATION_NAME" | tr '[:lower:]' '[:upper:]')

echo ""
echo "Scanning hardware for ${STATION_NAME}..."
echo "This takes about 10 seconds..."
echo ""

sudo bash "$SCRIPT_DIR/station-assess.sh" "$STATION_NAME" "$OUTPUT_DIR"

RESULT="${OUTPUT_DIR}/${STATION_NAME}_hardware.txt"

if [ -f "$RESULT" ]; then
    SIZE=$(du -h "$RESULT" | awk '{print $1}')
    echo ""
    echo "==================================="
    echo " DONE!"
    echo "==================================="
    echo ""
    echo " Saved to: $RESULT"
    echo " File size: $SIZE"
    echo ""
    echo " You can shut down and move to the next machine."
    echo ""
else
    echo ""
    echo "==================================="
    echo " ERROR"
    echo "==================================="
    echo ""
    echo " No output file was created."
    echo " Try running manually:"
    echo ""
    echo "   sudo bash $SCRIPT_DIR/station-assess.sh $STATION_NAME $OUTPUT_DIR"
    echo ""
fi

read -p "Press Enter to exit..."
