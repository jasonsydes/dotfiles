#!/bin/bash

# Take an existing (non-symlinked) lvim config (generally after a fresh install)
# and convert it into a symlinked lvim config.

# Usage:
#   store-exisiting-lvim-config.sh NAME
# Example:
#   store-exisiting-lvim-config.sh lvim-basic-ide
# Above example will result in SYMLINKS that look like this: 
#           INCOMPLETE
#   ~/.config/lvim              -> ~/.config/lvim--lvim-basic-ide
#   ~/.cache/lvim               -> ~/.cache/lvim--lvim-basic-ide
#   ~/.local/state/lvim         -> ~/.local/state/lvim--lvim-basic-ide
#   ~/.local/share/lunarvim     -> ~/.local/share/lunarvim--lvim-basic-ide
#   ~/.local/bin/lvim           -> ~/.local/bin/lvim--lvim-basic-ide



NAME=$1

if [[ ! $NAME ]] ; then
    echo Usage: Please provide a name.
    exit
fi

# Don't allow this tool to run on an existing symlinked config.
# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/lvim; do
for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ; do
    if test -L $THING; then
        echo "ERROR: You're trying to run $0 on an already symlinked lvim config."
        exit
    fi
done

# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/lvim; do
for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ; do
    NEW_THING="${THING}--${NAME}"
    # Just in case a particular THING folder hasn't been made yet (eg ~/.cache/lvim), go ahead and make it.
    mkdir -p $THING
    set -x
    mv $THING $NEW_THING
    ln -s $NEW_THING $THING
    set +x
done
