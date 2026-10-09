#!/bin/sh
# Go back to Ubuntu's standard login screen (GDM) from the next boot.
#   sudo sh ~/dotfiles/system/login-screen/remove.sh
set -e

if [ "$(id -u)" != 0 ]; then
    echo "Run this with sudo." >&2
    exit 1
fi
if [ ! -x /usr/sbin/gdm3 ] || [ ! -e /lib/systemd/system/gdm3.service ]; then
    echo "GDM is not installed, so there is nothing to switch back to." >&2
    exit 1
fi

echo /usr/sbin/gdm3 > /etc/X11/default-display-manager
ln -sf /lib/systemd/system/gdm3.service /etc/systemd/system/display-manager.service
echo "lightdm shared/default-x-display-manager select gdm3" | debconf-set-selections || true
echo "gdm3 shared/default-x-display-manager select gdm3" | debconf-set-selections || true

rm -f /etc/lightdm/lightdm.conf.d/50-itx.conf /etc/lightdm/itx-display-setup.sh

echo
echo "Standard login screen restored. It appears at the next restart."
