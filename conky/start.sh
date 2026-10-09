#!/bin/sh
# (Re)start the desktop clock widget. Run by i3 on login and on reload.
pkill -x conky
sleep 1
exec conky -c "$HOME/dotfiles/conky/conky.conf"
