#!/bin/sh
# Run by LightDM before the login screen appears: put the monitors in the
# same arrangement the desktop uses (HDMI left, DP right).
# This must always exit 0, or LightDM will not show the login screen.
xrandr --output HDMI-0 --primary --mode 2560x1440 --rate 180 --pos 0x0 \
       --output DP-0 --mode 2560x1440 --rate 180 --pos 2560x0 >/dev/null 2>&1 || true
exit 0
