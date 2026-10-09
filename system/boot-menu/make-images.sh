#!/bin/sh
# Draw the menu label images and the selection marker into the folder given as $1.
set -e
out="$1"
font=/usr/share/fonts/truetype/jetbrains-mono/JetBrainsMono-Light.ttf
mkdir -p "$out/icons"
label() {
    convert -size 184x48 xc:black -font "$font" -pointsize 20 -kerning 8 \
        -fill '#e6e6e6' -gravity west -annotate +20+0 "$2" -depth 8 "PNG24:$out/icons/$1.png"
}
label itx_ubuntu UBUNTU
label itx_windows WINDOWS
# selection marker: a thin white bar at the left edge of the selected row
convert -size 8x8 xc:black -depth 8 "PNG24:$out/select_c.png"
convert -size 2x8 xc:'#f0f0f0' -depth 8 "PNG24:$out/select_w.png"
