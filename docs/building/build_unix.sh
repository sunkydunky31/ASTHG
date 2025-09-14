#!/bin/bash
clear

echo -ne "\033]0;ASTHG Build State\007"

# ------------- CONFIG -----------------
CWD="$HOME/Documents/ASTHG/"
PLATFORM="cpp"
BUILD_FLAGS="-debug"
# --------------------------------------

echo "Current configuration:"
echo "CWD: $CWD"
echo "Platform: $PLATFORM"
echo "Build Flags: $BUILD_FLAGS"
echo
read -p "Press any key to continue..."
clear

cd "$CWD" || { echo "Directory not found: $CWD"; exit 1; }

echo "Building..."
lime test "$PLATFORM" "$BUILD_FLAGS"
