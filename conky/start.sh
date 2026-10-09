#!/bin/sh
# (Re)start the desktop clock widget on the primary monitor.
# Run by i3 on login and on reload.
pkill -x conky
sleep 1

conf="$HOME/dotfiles/conky/conky.conf"

# Find which screen number conky should use for the primary monitor: take the
# primary monitor's position from xrandr, then look that position up in the
# screen list conky itself reads.
head=0
origin="$(xrandr --query 2>/dev/null | awk '/ connected primary / { n = split($4, p, "+"); if (n == 3) print p[2] "," p[3]; exit }')"
if [ -n "$origin" ]; then
    found="$(xdpyinfo -ext XINERAMA 2>/dev/null | awk -v o="$origin" '$1 == "head" && $NF == o { gsub(/[#:]/, "", $2); print $2; exit }')"
    [ -n "$found" ] && head="$found"
fi

run="${XDG_RUNTIME_DIR:-/tmp}/conky-itx.conf"
sed "s/^\( *xinerama_head *= *\)[0-9][0-9]*,/\1$head,/" "$conf" > "$run"
exec conky -c "$run"
