#!/bin/bash

# Take an existing (non-symlinked) nvim config (generally after a fresh install)
# and convert it into a symlinked nvim config.

# Usage:
#   store-exisiting-nvim-config.sh NAME
# Example:
#   store-exisiting-nvim-config.sh nvim-basic-ide
# Above example will result in SYMLINKS that look like this: 
#           INCOMPLETE
#   ~/.config/nvim       -> ~/.config/nvim--nvim-basic-ide 
#   ~/.cache/nvim        -> ~/.cache/nvim--nvim-basic-ide 
#   ~/.local/state/nvim  -> ~/.local/state/nvim--nvim-basic-ide
#   ~/.local/share/nvim  -> ~/.local/share/nvim--nvim-basic-ide


NAME=$1

if [[ ! $NAME ]] ; then
    echo Usage: Please provide a name.
    exit
fi

# Don't allow this tool to run on an existing symlinked config.
for THING in ~/.config/nvim ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    if test -L $THING; then
        echo "ERROR: You're trying to run $0 on an already symlinked nvim config."
        exit
    fi
done

for THING in ~/.config/nvim ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    NEW_THING="${THING}--${NAME}"
    # Just in case a particular THING folder hasn't been made yet (eg ~/.cache/nvim), go ahead and make it.
    mkdir -p $THING
    set -x
    mv $THING $NEW_THING
    ln -s $NEW_THING $THING
    set +x
done
