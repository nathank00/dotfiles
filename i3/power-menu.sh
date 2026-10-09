#!/bin/sh
# Session menu for Mod+Shift+e: pick with the arrow keys and Enter, Esc cancels.
choice="$(printf 'Log out\nLock\nRestart\nShut down\n' | rofi -dmenu -i -no-custom -p '>' -l 4)"

case "$choice" in
    'Log out')   i3-msg exit ;;
    'Lock')      loginctl lock-session ;;
    'Restart')   systemctl reboot ;;
    'Shut down') systemctl poweroff ;;
esac
