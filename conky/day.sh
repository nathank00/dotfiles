#!/bin/sh
# Prints today's name in capitals for the desktop widget, with adjustable
# spacing between the letters. Used by conky.conf.

gap=28     # pixels between letters: lower is tighter, higher is wider
nudge=24   # conky centres a line half a letter too far left when it starts
           # with an offset; this corrects it (about 0.4 x the font size)

date +%A | tr '[:lower:]' '[:upper:]' | awk -v g="$gap" -v k="$nudge" '{
    n = length($0)
    # the added spacing is not counted when conky centres the line, so start
    # half of it to the left
    printf "${offset %d}", k - int((n - 1) * g / 2)
    for (i = 1; i <= n; i++) {
        printf "%s", substr($0, i, 1)
        if (i < n) printf "${offset %d}", g
    }
    printf "\n"
}'
