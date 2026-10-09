#!/usr/bin/env python3
"""Snap the focused window to the left or right half of the screen it is on.

Usage: snap.py left|right
The window becomes floating so it can take exactly half the screen.
Mod+Shift+Space puts it back into the tiled layout.
"""
import json
import subprocess
import sys

GAP = 6  # keep in step with "gaps inner" in the i3 config

side = sys.argv[1] if len(sys.argv) > 1 else "left"
workspaces = json.loads(subprocess.check_output(["i3-msg", "-t", "get_workspaces"]))
rect = next(w for w in workspaces if w["focused"])["rect"]

width = (rect["width"] - 3 * GAP) // 2
height = rect["height"] - 2 * GAP
x = rect["x"] + GAP if side == "left" else rect["x"] + 2 * GAP + width
y = rect["y"] + GAP

subprocess.run(
    ["i3-msg", f"floating enable, resize set {width} px {height} px, move position {x} px {y} px"],
    stdout=subprocess.DEVNULL,
)
