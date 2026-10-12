#!/usr/bin/env python3
"""Place the focused window on the screen it is on.

Usage: snap.py left|right|small|large|full

  left / right   left or right half                       (Mod+Alt+1 / Mod+Alt+2)
  small          centred, half the width and half the
                 height: a quarter of the screen           (Mod+Alt+-)
  large          centred, 80% of the width and height      (Mod+Alt+/)
  full           the whole screen, inside the usual gap    (Mod+Alt+=)

The window becomes floating so it can take exactly that size.
Mod+Shift+Space puts it back into the tiled layout.
"""
import json
import subprocess
import sys

GAP = 6  # keep in step with "gaps inner" in the i3 config

# centred sizes, as a fraction of the screen's width and height
CENTRED = {
    "small": 0.50,
    "large": 0.80,
}

mode = sys.argv[1] if len(sys.argv) > 1 else "left"
workspaces = json.loads(subprocess.check_output(["i3-msg", "-t", "get_workspaces"]))
rect = next(w for w in workspaces if w["focused"])["rect"]

if mode in ("left", "right"):
    width = (rect["width"] - 3 * GAP) // 2
    height = rect["height"] - 2 * GAP
    x = rect["x"] + GAP if mode == "left" else rect["x"] + 2 * GAP + width
    y = rect["y"] + GAP
elif mode == "full":
    width = rect["width"] - 2 * GAP
    height = rect["height"] - 2 * GAP
    x = rect["x"] + GAP
    y = rect["y"] + GAP
elif mode in CENTRED:
    width = round(rect["width"] * CENTRED[mode])
    height = round(rect["height"] * CENTRED[mode])
    x = rect["x"] + (rect["width"] - width) // 2
    y = rect["y"] + (rect["height"] - height) // 2
else:
    sys.exit(f"snap.py: unknown position '{mode}' (use left, right, small, large or full)")

subprocess.run(
    ["i3-msg", f"floating enable, resize set {width} px {height} px, move position {x} px {y} px"],
    stdout=subprocess.DEVNULL,
)
