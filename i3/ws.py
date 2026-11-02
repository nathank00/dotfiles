#!/usr/bin/env python3
"""Step to the next / previous desktop (workspace) on the current monitor.

Usage: ws.py next|prev [move]

  next / prev   the next or previous desktop on this monitor. Going right past
                the last one opens a new, empty desktop on this monitor.
  move          take the focused window along.

Bound to Ctrl+Alt+Left/Right, and Ctrl+Alt+Shift+Left/Right to move a window.
"""
import json
import subprocess
import sys

LAST = 10  # Mod+0 is desktop 10; don't go past it

direction = sys.argv[1] if len(sys.argv) > 1 else "next"
move = len(sys.argv) > 2 and sys.argv[2] == "move"

workspaces = json.loads(subprocess.check_output(["i3-msg", "-t", "get_workspaces"]))
current = next(w for w in workspaces if w["focused"])
here = sorted(w["num"] for w in workspaces
              if w["output"] == current["output"] and w["num"] > 0)
used = {w["num"] for w in workspaces}

if direction == "next":
    later = [n for n in here if n > current["num"]]
    if later:
        target = later[0]
    else:
        # open a new desktop, unless this one is already an empty new one
        tree = json.loads(subprocess.check_output(["i3-msg", "-t", "get_tree"]))

        def find(node):
            if node.get("type") == "workspace" and node.get("num") == current["num"]:
                return node
            for child in node.get("nodes", []):
                found = find(child)
                if found:
                    return found
            return None

        node = find(tree)
        if node and not node.get("nodes") and not node.get("floating_nodes") and not move:
            sys.exit(0)
        target = max(used) + 1
        if target > LAST:
            sys.exit(0)
else:
    earlier = [n for n in here if n < current["num"]]
    if not earlier:
        sys.exit(0)
    target = earlier[-1]

cmd = f"workspace number {target}"
if move:
    cmd = f"move container to workspace number {target}; " + cmd
subprocess.run(["i3-msg", cmd], stdout=subprocess.DEVNULL)
