#!/bin/bash

# ORIGINAL CODE:
# https://learn.microsoft.com/pt-br/powershell/scripting/install/install-alpine?view=powershell-7.6
# https://learn.microsoft.com/pt-br/powershell/scripting/install/install-debian?view=powershell-7.6
# https://learn.microsoft.com/pt-br/powershell/scripting/install/install-rhel?view=powershell-7.6
# https://learn.microsoft.com/pt-br/powershell/scripting/install/install-ubuntu?view=powershell-7.6

# Check if the user already has PSCore
if command -v pwsh > /dev/null 2>&1; then
  echo "PowerShell Core is already installed on your system."
  exit 0
fi

if [ -f /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  DIST=$ID
  DIST_VER=$VERSION_ID
fi


if command -v doas > /dev/null 2>&1; then
  SUDOCMD="doas"
elif command -v sudo > /dev/null 2>&1; then
  SUDOCMD="sudo"
else
  SUDOCMD=""
fi

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PSVERSION=$(cat "$SCRIPT_DIR/version.txt")
echo "Script DIR: $SCRIPT_DIR"

echo "Distribution found: '$DIST' v$DIST_VER"
echo "Installing PowerShell Core. . ."
echo "---------------------------------------------------------------"

case "$DIST" in
  alpine)

    $SUDOCMD apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl3 libstdc++ tzdata userspace-rcu zlib icu-libs curl

    apk add -X https://dl-cdn.alpinelinux.org/alpine/edge/main --no-cache lttng-ust openssh-client && curl -L https://github.com/PowerShell/PowerShell/releases/download/v"$PSVERSION"/powershell-"$PSVERSION"-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz

    $SUDOCMD mkdir -p /opt/microsoft/powershell/7
    $SUDOCMD tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
    $SUDOCMD chmod +x /opt/microsoft/powershell/7/pwsh
    $SUDOCMD ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
    ;;
  rhel)
    if [ "${DIST_VER%.*}" -ge 8 ]
      then majorver=8
    elif [ "${DIST_VER%.*}" -ge 9 ]
      then majorver=9
    fi

    curl -sSL -O https://packages.microsoft.com/config/rhel/"$majorver"/packages-microsoft-prod.rpm

    $SUDOCMD rpm -i packages-microsoft-prod.rpm

    rm packages-microsoft-prod.rpm

    $SUDOCMD dnf update

    $SUDOCMD dnf install powershell -y
    ;;
  debian|ubuntu)
    $SUDOCMD apt-get update

    if [ "$DIST" = "ubuntu" ]; then
      $SUDOCMD apt-get install -y wget apt-transport-https software-properties-common
    else
      $SUDOCMD apt-get install -y wget
    fi

    wget -q https://packages.microsoft.com/config/"$DIST"/"$DIST_VER"/packages-microsoft-prod.deb

    $SUDOCMD dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    $SUDOCMD apt-get update
    $SUDOCMD apt-get install -y powershell
    ;;
  *)
    echo "Sorry, the distribution '$DIST' is not supported in this script."
    echo "Go to the project's repository and offer support to it!"

    exit 1
    ;;
esac

echo "---------------------------------------------------------------"
echo "Finished installation!"