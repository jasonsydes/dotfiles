#!/bin/bash

# Enable an existing named lvim config by symlink'ing it into place.
# If an existing symlinked lvim config is in place, delete those symlinks.
# Error out if you find a non-symlinked lvim config

# Usage:
#   enable-lvim-config.sh NAME
# Example:
#   enable-lvim-config.sh lvim-basic-ide
# Above example will result in SYMLINKS that look like this: 
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

# Don't allow this tool to run if it finds an existing non-symlinked config in place.
# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/lvim; do
# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ; do
# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/nvim ~/.local/share/nvim ; do
for THING in ~/.config/lvim ~/.cache/lvim ~/.local/share/lunarvim ~/.local/state/nvim ~/.local/share/nvim ; do

    if test -e $THING && ! test -L $THING ; then
        echo "ERROR: You're trying to run $0, but I found a non-symlinked lvim config in place."
        exit
    fi
done

# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/lvim; do
# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ; do
# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/nvim ~/.local/share/nvim ; do
for THING in ~/.config/lvim ~/.cache/lvim ~/.local/share/lunarvim ~/.local/state/nvim ~/.local/share/nvim ; do
    EXISTING_THING="${THING}--${NAME}"
    set -x
    # Delete any existing symlink.
    rm -f $THING
    # Make the new symlink.
    ln -s $EXISTING_THING $THING
    set +x
done
