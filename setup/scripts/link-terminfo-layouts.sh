#!/usr/bin/env bash
# link-terminfo-layouts.sh — make ~/.terminfo readable by both ncurses builds.
#
# ncurses files each terminfo entry under a one-character directory, and two
# builds disagree on which character:
#   Ubuntu/Debian ncurses   ~/.terminfo/x/xterm-ghostty    (first letter)
#   conda-forge ncurses     ~/.terminfo/78/xterm-ghostty   (its hex code)
# pixi's tmux is linked against conda-forge ncurses and reads only the hex
# layout; apt-installed programs read only the letter layout.
#
# Ghostty's ssh-terminfo feature installs xterm-ghostty by running `tic` on
# the server over a non-interactive ssh. On hosts that read ~/.bashrc for
# those (SSH_SOURCE_BASHRC), ~/.pixi/bin is first on PATH, so once pixi's
# ncurses is installed the `tic` that runs is pixi's. Where the entry lands
# then depends on the host:
#   - no pixi ncurses yet (popsicle, 260930): letter layout only
#   - pixi ncurses, ~/.terminfo exists (kelvin, 260630): hex layout only
#   - pixi ncurses, no ~/.terminfo (kelvin, 261001): inside pixi's own
#     ncurses env, where nothing else looks
#
# This script makes every case end the same way:
#   1. If ~/.terminfo has no xterm-ghostty but pixi's infocmp can find one,
#      compile it into ~/.terminfo with pixi's tic and an explicit -o.
#   2. Beside each letter directory add its hex symlink (78 -> x), and
#      beside each hex directory its letter symlink (x -> 78). A name that
#      already exists is left alone (longreads: real file in 78/, file-level
#      symlinks in the letter directories).
#
# Idempotent; writes only inside ~/.terminfo. Skips step 1 on macOS, where
# Ghostty ships its own entry and sets TERMINFO.

set -euo pipefail

TI="$HOME/.terminfo"
PIXI_BIN="$HOME/.pixi/bin"
ENTRY=xterm-ghostty

# ── 1. Recover an entry that only pixi's ncurses can see ────────────────────

if [ "$(uname -s)" != Darwin ] \
    && [ ! -e "$TI/x/$ENTRY" ] && [ ! -e "$TI/78/$ENTRY" ] \
    && [ -x "$PIXI_BIN/infocmp" ] && [ -x "$PIXI_BIN/tic" ]; then
    src="$(mktemp)"
    if "$PIXI_BIN/infocmp" -x "$ENTRY" > "$src" 2>/dev/null; then
        mkdir -p "$TI"
        "$PIXI_BIN/tic" -x -o "$TI" "$src"
        echo "Compiled $ENTRY into $TI (pixi's ncurses had the only copy)"
    fi
    rm -f "$src"
fi

if [ ! -d "$TI" ]; then
    echo "No $TI (skipping; Ghostty creates it on the first ssh from Ghostty)"
    exit 0
fi

# ── 2. Link each layout to the other ────────────────────────────────────────

# Letter directory -> hex symlink beside it.
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

# Hex directory -> letter symlink beside it.
for dir in "$TI"/??; do
    [ -d "$dir" ] || continue
    hex="${dir##*/}"
    [[ $hex =~ ^[0-9a-f]{2}$ ]] || continue
    letter="$(printf '%b' "\\x$hex")"
    [[ $letter =~ ^[A-Za-z0-9]$ ]] || continue
    if [ -e "$TI/$letter" ] || [ -L "$TI/$letter" ]; then
        continue
    fi
    ln -s "$hex" "$TI/$letter"
    echo "Linked $TI/$letter -> $hex"
done
