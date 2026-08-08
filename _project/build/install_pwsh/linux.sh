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
  . /etc/os-release
  DIST=$ID
  DIST_VER=$VERSION_ID
fi

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PSVERSION=$(cat "$SCRIPT_DIR/version.txt")
echo "Script DIR: $SCRIPT_DIR"

echo "Distribution found: '$DIST' v$DIST_VER"
echo "Installing PowerShell Core. . ."
echo "---------------------------------------------------------------"

case "$DIST" in
  alpine)
    
  if ["$DIST_VER" -ge "3.16"]; then
    echo "Version is >= 3.16"
    doas apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl3 libstdc++ tzdata userspace-rcu zlib icu-libs curl
  else
    echo "Version is <= 3.16"
    sudo apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl3 libstdc++ tzdata userspace-rcu zlib icu-libs curl
  fi

    apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust openssh-client \
    curl -L https://github.com/PowerShell/PowerShell/releases/download/v$PSVERSION/powershell-$PSVERSION-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz

    sudo mkdir -p /opt/microsoft/powershell/7
    sudo tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
    sudo chmod +x /opt/microsoft/powershell/7/pwsh
    sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
    ;;
  rhel)
    if [ ${DIST_VER%.*} -ge 8 ]
      then majorver=8
    elif [ ${DIST_VER%.*} -ge 9 ]
      then majorver=9
    fi

    curl -sSL -O https://packages.microsoft.com/config/rhel/$majorver/packages-microsoft-prod.rpm

    sudo rpm -i packages-microsoft-prod.rpm

    rm packages-microsoft-prod.rpm

    sudo dnf update

    sudo dnf install powershell -y
    ;;
  debian|ubuntu)
    sudo apt-get update

    if ["$DIST" -eq "ubuntu"]; then
      sudo apt-get install -y wget apt-transport-https software-properties-common
    else
      sudo apt-get install -y wget
    fi

    wget -q https://packages.microsoft.com/config/$DIST/$DIST_VER/packages-microsoft-prod.deb

    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    sudo apt-get update

    sudo apt-get install -y powershell
    ;;
  *)
    echo "Sorry, the distribution '$DIST' is not supported in this script."
    echo "Go to the project's repository and offer support to it!"

    exit 1
    ;;
esac

echo "---------------------------------------------------------------"
echo "Finished installation!"