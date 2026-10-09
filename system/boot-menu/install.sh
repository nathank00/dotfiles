#!/bin/sh
# Install the ITX boot menu (black screen, two entries: Ubuntu and Windows).
#   sudo sh ~/dotfiles/system/boot-menu/install.sh
# Undo with:
#   sudo sh ~/dotfiles/system/boot-menu/remove.sh
set -e

if [ "$(id -u)" != 0 ]; then
    echo "Run this with sudo." >&2
    exit 1
fi

here="$(cd "$(dirname "$0")" && pwd)"
theme=/boot/grub/themes/itx
font=/usr/share/fonts/truetype/jetbrains-mono/JetBrainsMono-Light.ttf

if [ ! -f "$font" ]; then
    apt-get install -y fonts-jetbrains-mono
fi
if ! command -v convert >/dev/null; then
    apt-get install -y imagemagick
fi

# build the theme in a scratch folder first, so a failure leaves nothing half-done
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cp "$here/theme.txt" "$work/"
sh "$here/make-images.sh" "$work"

mkdir -p /boot/grub/themes
rm -rf "$theme"
cp -r "$work" "$theme"
chmod -R a+rX "$theme"

install -m 755 "$here/06_itx" /etc/grub.d/06_itx
mkdir -p /etc/default/grub.d
install -m 644 "$here/itx.cfg" /etc/default/grub.d/itx.cfg

update-grub

echo
echo "Boot menu installed. It appears at the next restart."
echo "To boot Windows once from Ubuntu:  sudo grub-reboot windows && sudo reboot"
