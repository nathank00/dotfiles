#!/bin/sh
# Set the wallpaper from ~/Pictures/wallpaper.jpg (a local file, not part of
# the dotfiles repo) and hand a copy to the login screen so it matches.
# Run by i3 on login and on every Mod+Shift+r.
wallpaper="$HOME/Pictures/wallpaper.jpg"
shared=/usr/local/share/itx

feh --no-fehbg --bg-fill "$wallpaper" 2>/dev/null || xsetroot -solid "#0a0a0a"

# the shared folder only exists once the ITX login screen is installed
if [ -f "$wallpaper" ] && [ -d "$shared" ] && [ -w "$shared" ]; then
    install -m 644 "$wallpaper" "$shared/wallpaper.jpg"
fi
