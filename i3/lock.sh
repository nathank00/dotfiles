#!/bin/sh
# Lock screen: black, with one mark per typed key and a blinking cursor.
export XSECURELOCK_PASSWORD_PROMPT=asterisks
export XSECURELOCK_AUTH_CURSOR_BLINK=1
export XSECURELOCK_FONT='JetBrains Mono:size=16'
export XSECURELOCK_AUTH_BACKGROUND_COLOR='#000000'
export XSECURELOCK_AUTH_FOREGROUND_COLOR='#c8c8c8'
export XSECURELOCK_AUTH_WARNING_COLOR='#ef4444'
export XSECURELOCK_SHOW_HOSTNAME=0
export XSECURELOCK_SHOW_USERNAME=0
export XSECURELOCK_SHOW_DATETIME=0
export XSECURELOCK_SHOW_KEYBOARD_LAYOUT=0
export XSECURELOCK_SHOW_LOCKS_AND_LATCHES=0
export XSECURELOCK_SINGLE_AUTH_WINDOW=1
# let the first key count, so the password can be typed straight away
export XSECURELOCK_DISCARD_FIRST_KEYPRESS=0
# hide the "Password:" label, if the filter script is present and runnable
filter="$HOME/dotfiles/i3/lock-authproto.py"
if [ -x "$filter" ]; then
    export XSECURELOCK_AUTHPROTO="$filter"
fi
exec xsecurelock
