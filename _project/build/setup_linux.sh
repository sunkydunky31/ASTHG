#!/bin/bash

# --- Localized Data
export TEXTDOMAIN='setup_linux'
export TEXTDOMAINDIR="locales"

function t {
  if command -v gettext > /dev/null 2>&1; then
    gettext "$1"
  else
    printf "%s" "$1"
  fi

  echo ""
}

# ---

# Check if HAXELIB command exists
if ! command -v haxelib > /dev/null 2>&1; then
  t "'haxelib' command doesn't exists! Do you have Haxe installed?"
  echo ""
  exit 1
fi

# --- Functions

function installDeps {
  t 'Installing dependencies.'
  t 'This might take a few moments depending on your internet speed.'

  haxelib --global install hmm
  haxelib run hmm install
}

# Remove unnecessary packages
function removeRedundantDeps {
  t 'Removing redundant dependencies.'

  for current in .haxelib/*/.current; do
    [ -f "$current" ] || continue
    libpath=$(dirname "$current")
    libname=$(basename "$libpath")
    curversion=$(cat "$current")

    for x in "$libpath"/*/; do
      [ -d "$x" ] || continue;
      redundant=$(basename "$x")

      if [ "$redundant" != "$curversion" ] && [ "$redundant" != "${curversion//./,}" ]; then
        t "Removing '$redundant' from '$libname'"
        haxelib remove "$libname" "${redundant//,/.}"
      fi
    done
  done
}

NUM_OPTIONS=2
MENU_OPTIONS=(
  "$(t 'Install dependencies')"
  "$(t 'Setup for Linux')"
  "$(t 'Remove redundant libraries')"
)

echo "===== $(t 'ASTHE Setup') ====="
for num in $(seq 0 $NUM_OPTIONS); do
  echo "[$num] ${MENU_OPTIONS[$num]}"
done
read -rp "$(t "Choose an option (0/$NUM_OPTIONS): ")" choose

case "$choose" in
  0)
    installDeps
    removeRedundantDeps
    ;;
  1)
    # Setup build environment
    haxelib run lime setup linux --global
    ;;
  2)
    # Setup build environment
    removeRedundantDeps
    ;;
  *)
    t "Unsupported option, try again!"
    ;;
esac
