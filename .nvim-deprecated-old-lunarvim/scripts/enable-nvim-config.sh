#!/bin/bash

# Enable an existing named nvim config by symlink'ing it into place.
# If an existing symlinked nvim config is in place, delete those symlinks.
# Error out if you find a non-symlinked nvim config

# Usage:
#   enable-nvim-config.sh NAME
# Example:
#   enable-nvim-config.sh nvim-basic-ide
# Above example will add SYMLINKS that look like this: 
#   ~/.config/nvim       -> ~/.config/nvim--nvim-basic-ide 
#   ~/.cache/nvim        -> ~/.cache/nvim--nvim-basic-ide 
#   ~/.local/state/nvim  -> ~/.local/state/nvim--nvim-basic-ide
#   ~/.local/share/nvim  -> ~/.local/share/nvim--nvim-basic-ide


NAME=$1

if [[ ! $NAME ]] ; then
    echo Usage: Please provide a name.
    exit
fi

# Don't allow this tool to run if it finds an existing non-symlinked config in place.
for THING in ~/.config/nvim ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do

    if test -e $THING && ! test -L $THING ; then
        echo "ERROR: You're trying to run $0, but I found a non-symlinked nvim config in place."
        exit
    fi
done

for THING in ~/.config/nvim ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    EXISTING_THING="${THING}--${NAME}"
    set -x
    # Delete any existing symlink.
    rm -f $THING
    # Make the new symlink.
    ln -s $EXISTING_THING $THING
    set +x
done
