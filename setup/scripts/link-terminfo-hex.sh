#!/usr/bin/env bash
# link-terminfo-hex.sh — make ~/.terminfo readable by pixi-installed tools.
#
# ncurses files each terminfo entry under a one-character directory, and two
# builds disagree on which character:
#   Ubuntu/Debian ncurses   ~/.terminfo/x/xterm-ghostty    (first letter)
#   conda-forge ncurses     ~/.terminfo/78/xterm-ghostty   (its hex code)
# Ghostty's ssh-terminfo feature installs xterm-ghostty with the server's own
# tic, so on Linux it lands in the letter layout. pixi's tmux is linked
# against conda-forge ncurses, looks only in the hex layout, and fails with
# "can't find terminfo database". Seen on popsicle, 260930.
#
# For each letter directory this adds the hex-named symlink beside it
# (78 -> x). A hex name that already exists is left alone: on longreads the
# hex directory is the real one and the letter directories are the links.
#
# Idempotent; writes only inside ~/.terminfo; no-op if it does not exist.

set -euo pipefail

TI="$HOME/.terminfo"

if [ ! -d "$TI" ]; then
    echo "No $TI (skipping; Ghostty creates it on the first ssh from Ghostty)"
    exit 0
fi

for dir in "$TI"/?; do
    [ -d "$dir" ] || continue
    letter="${dir##*/}"
    hex="$(printf '%x' "'$letter")"
    if [ -e "$TI/$hex" ] || [ -L "$TI/$hex" ]; then
        continue
    fi
    ln -s "$letter" "$TI/$hex"
    echo "Linked $TI/$hex -> $letter"
done
