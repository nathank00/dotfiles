#!/bin/bash
# Lock screen: black, with one mark per typed key and a blinking cursor.

# i3 starts this with "sh"; the compositor handling below needs bash.
[ -n "$BASH_VERSION" ] || exec bash "$0" "$@"

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

# A compositor (picom) paints over the lock screen, and xsecurelock then covers
# everything with "INCOMPATIBLE COMPOSITOR, PLEASE FIX!". Its two built-in
# workarounds can let the desktop show through instead, so the compositor is
# simply stopped while the screen is locked and started again, exactly as it
# was running, after unlocking.
picom_cmd=()
picom_pid=$(pgrep -x -u "$(id -u)" picom | head -n 1)
if [ -n "$picom_pid" ]; then
    mapfile -d '' -t picom_cmd < "/proc/$picom_pid/cmdline"
    pkill -x -u "$(id -u)" picom
    for _ in 1 2 3 4 5 6 7 8 9 10; do
        pgrep -x -u "$(id -u)" picom >/dev/null || break
        sleep 0.1
    done
fi

# Note whether the monitors switch off while locked, or the PC sleeps, so the
# DisplayPort link can be set up again after unlocking (see display-reset.sh).
slept_seconds() {
    python3 -c 'import time; print(int(time.clock_gettime(time.CLOCK_BOOTTIME) - time.monotonic()))'
}
slept_before=$(slept_seconds)
monitors_off=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/lock-monitors-off.XXXXXX")

xsecurelock &
lock_pid=$!

# xss-lock hands over a "hold off sleeping until locked" handle. xsecurelock
# releases its copy once the screen is locked; release this script's copy too,
# or every suspend would wait several seconds for nothing.
case "$XSS_SLEEP_LOCK_FD" in
    ''|*[!0-9]*) ;;
    *) exec {XSS_SLEEP_LOCK_FD}<&- ;;
esac

# check the monitors' power state every few seconds while locked
(
    while kill -0 "$lock_pid" 2>/dev/null; do
        state=$(xset q 2>/dev/null | sed -n 's/.*Monitor is //p')
        if [ -n "$state" ] && [ "$state" != "On" ]; then
            echo "$state" > "$monitors_off"
        fi
        sleep 5
    done
) &
watch_pid=$!

# if asked to stop (for example "loginctl unlock-session"), unlock
trap 'kill "$lock_pid" 2>/dev/null' TERM INT HUP
while kill -0 "$lock_pid" 2>/dev/null; do
    wait "$lock_pid"
done
kill "$watch_pid" 2>/dev/null

# unlocked: if the monitors were off (or the PC slept), reset the DisplayPort link
if [ -s "$monitors_off" ] || [ "$(slept_seconds)" -gt $((slept_before + 5)) ]; then
    sh "$HOME/dotfiles/i3/display-reset.sh" >/dev/null 2>&1
fi
rm -f "$monitors_off"

if [ "${#picom_cmd[@]}" -gt 0 ]; then
    setsid -f "${picom_cmd[@]}" >/dev/null 2>&1 </dev/null
fi
