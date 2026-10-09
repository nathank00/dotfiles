#!/usr/bin/env python3
"""Display filter for the lock screen: hides the "Password:" label.

xsecurelock asks this program to check the password. It runs the system's
normal password checker (authproto_pam) and passes everything through
unchanged, except that the text of password prompts is blanked.

The unlock decision is never made here: this exits 0 only when the real
checker exited 0. Any error in this script exits 1, which keeps the screen
locked.
"""
import subprocess
import sys

REAL = "/usr/libexec/xsecurelock/authproto_pam"


def read_packet(stream):
    """Read one '<type> <length>\\n<message>\\n' packet; None at end of stream."""
    kind = stream.read(1)
    if not kind:
        return None
    if stream.read(1) != b" ":
        raise ValueError("bad packet header")
    digits = b""
    while True:
        ch = stream.read(1)
        if ch == b"\n":
            break
        if not ch.isdigit() or len(digits) > 8:
            raise ValueError("bad packet length")
        digits += ch
    length = int(digits)
    message = stream.read(length)
    if len(message) != length or stream.read(1) != b"\n":
        raise ValueError("truncated packet")
    return kind, message


def main():
    child = subprocess.Popen([REAL] + sys.argv[1:], stdout=subprocess.PIPE)
    out = sys.stdout.buffer
    while True:
        packet = read_packet(child.stdout)
        if packet is None:
            break
        kind, message = packet
        if kind == b"P":
            message = b" "
        out.write(kind + b" " + str(len(message)).encode() + b"\n" + message + b"\n")
        out.flush()
    return 0 if child.wait() == 0 else 1


if __name__ == "__main__":
    try:
        code = main()
    except BaseException:
        code = 1
    sys.exit(code)
