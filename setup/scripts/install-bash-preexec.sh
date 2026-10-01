#!/usr/bin/env bash
# install-bash-preexec.sh — fetch bash-preexec to ~/.bash-preexec.sh.
# Idempotent: skips the download if the file is already there.
#
# bash/bashrc sources ~/.bash-preexec.sh right after starship (see the LOAD
# ORDER MATTERS block there). Without it the shell still starts, but the
# precmd/preexec hook arrays that later fragments rely on never exist.

set -euo pipefail

DEST="$HOME/.bash-preexec.sh"
URL="https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh"

if [ -f "$DEST" ]; then
    echo "bash-preexec already present at $DEST (skipping download)"
    exit 0
fi

echo "Downloading bash-preexec to $DEST"
# Download to a temp name first so a failed transfer never leaves a
# truncated file that bashrc would then source.
curl --fail --silent --show-error --location "$URL" --output "$DEST.tmp"
mv "$DEST.tmp" "$DEST"
