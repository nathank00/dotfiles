#!/bin/sh
# Install the ITX login screen: LightDM with a small dark login box over the
# current wallpaper. It replaces Ubuntu's login screen (GDM) from the next boot.
#   sudo sh ~/dotfiles/system/login-screen/install.sh
# Undo with:
#   sudo sh ~/dotfiles/system/login-screen/remove.sh
set -e

if [ "$(id -u)" != 0 ]; then
    echo "Run this with sudo." >&2
    exit 1
fi
user="${SUDO_USER:-}"
if [ -z "$user" ] || [ "$user" = root ]; then
    echo "Run this with sudo from your own account, not as root directly." >&2
    exit 1
fi
home="$(getent passwd "$user" | cut -d: -f6)"
here="$(cd "$(dirname "$0")" && pwd)"

# Install without the "choose a display manager" dialog; the switch is done
# explicitly at the end of this script.
DEBIAN_FRONTEND=noninteractive apt-get install -y lightdm lightdm-gtk-greeter fonts-jetbrains-mono

# theme and settings
install -d -m 755 /usr/share/themes/ITX-Greeter/gtk-3.0
install -m 644 "$here/gtk.css" /usr/share/themes/ITX-Greeter/gtk-3.0/gtk.css
if [ -f /etc/lightdm/lightdm-gtk-greeter.conf ] && [ ! -f /etc/lightdm/lightdm-gtk-greeter.conf.before-itx ]; then
    cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf.before-itx
fi
install -m 644 "$here/lightdm-gtk-greeter.conf" /etc/lightdm/lightdm-gtk-greeter.conf
install -m 755 "$here/display-setup.sh" /etc/lightdm/itx-display-setup.sh
install -d -m 755 /etc/lightdm/lightdm.conf.d
install -m 644 "$here/50-itx.conf" /etc/lightdm/lightdm.conf.d/50-itx.conf

# a folder the login screen can read and you can write: i3 copies the current
# wallpaper here every time it starts or reloads
install -d -o "$user" -m 755 /usr/local/share/itx
if [ -f "$home/Pictures/wallpaper.jpg" ]; then
    install -o "$user" -m 644 "$home/Pictures/wallpaper.jpg" /usr/local/share/itx/wallpaper.jpg
fi

# check everything LightDM needs is in place before switching to it
if [ ! -x /usr/sbin/lightdm ] || [ ! -e /lib/systemd/system/lightdm.service ] \
   || [ ! -x /usr/sbin/lightdm-gtk-greeter ] || ! lightdm --show-config >/dev/null 2>&1; then
    echo "LightDM is not fully installed; leaving the current login screen in place." >&2
    exit 1
fi

# make LightDM the login manager (the same two steps its own package performs)
echo /usr/sbin/lightdm > /etc/X11/default-display-manager
ln -sf /lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service
echo "lightdm shared/default-x-display-manager select lightdm" | debconf-set-selections || true
echo "gdm3 shared/default-x-display-manager select lightdm" | debconf-set-selections || true

echo
echo "Login screen installed. It appears at the next restart."
echo "If the screen stays black after a restart, run this from another machine:"
echo "  ssh -t itx 'sudo sh ~/dotfiles/system/login-screen/remove.sh && sudo reboot'"
