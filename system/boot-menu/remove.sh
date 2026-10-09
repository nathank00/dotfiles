#!/bin/sh
# Remove the ITX boot menu and go back to Ubuntu's standard one.
#   sudo sh ~/dotfiles/system/boot-menu/remove.sh
set -e

if [ "$(id -u)" != 0 ]; then
    echo "Run this with sudo." >&2
    exit 1
fi

rm -f /etc/grub.d/06_itx /etc/default/grub.d/itx.cfg
rm -rf /boot/grub/themes/itx
update-grub

echo
echo "Standard boot menu restored."
