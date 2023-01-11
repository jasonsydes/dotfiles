#!/bin/bash

# Disable a symlinked nvim config by deleting the symlinks.

# Usage:
#   disable-nvim-config.sh
# Example:
#   disable-nvim-config.sh 
# Above example will DELETE SYMLINKS that look like this: 
#           INCOMPLETE
#   ~/.config/nvim       -> ~/.config/nvim--nvim-basic-ide 
#   ~/.cache/nvim        -> ~/.cache/nvim--nvim-basic-ide 
#   ~/.local/state/nvim  -> ~/.local/state/nvim--nvim-basic-ide
#   ~/.local/share/nvim  -> ~/.local/share/nvim--nvim-basic-ide


# Don't allow this tool to run on a non-symlinked config.
for THING in ~/.config/nvim ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    if ! test -L $THING; then
        echo "ERROR: You're trying to run $0 on a non-symlinked nvim config."
        exit
    fi
done

for THING in ~/.config/nvim ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    set -x
    rm $THING
    set +x
done
