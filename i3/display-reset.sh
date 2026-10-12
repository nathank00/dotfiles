#!/bin/sh
# Set up the link to the right (DisplayPort) monitor again.
#
# After the monitors have been switched off (lock screen or sleep), the RTX 5080
# sometimes brings DisplayPort back with an unstable link, and the right monitor
# keeps blanking for a second at a time. Dropping briefly to 60 Hz and back makes
# the card set the link up from scratch, as a reboot would.
#
# lock.sh runs this after unlocking whenever the monitors were off. To run it by
# hand:  sh ~/dotfiles/i3/display-reset.sh
OUTPUT=DP-0
MODE=2560x1440
RATE=180    # keep in step with the xrandr line in i3/config

xrandr --output "$OUTPUT" --mode "$MODE" --rate 60 || exit 1
sleep 2
xrandr --output "$OUTPUT" --mode "$MODE" --rate "$RATE"
