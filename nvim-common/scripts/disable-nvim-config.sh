#!/bin/bash

# Disable a symlinked nvim config by deleting the symlinks.

# UPDATE 260509:
#   We now HAND-MANAGE the symlinks of ~/.config/nvim.
#   See store-existing-nvim-config.sh for details.
#
# Usage:
#   disable-nvim-config.sh
# Example:
#   disable-nvim-config.sh 
# Above example will DELETE SYMLINKS that look like this: 
#   ~/.cache/nvim        -> ~/.cache/nvim--nvim-basic-ide 
#   ~/.local/state/nvim  -> ~/.local/state/nvim--nvim-basic-ide
#   ~/.local/share/nvim  -> ~/.local/share/nvim--nvim-basic-ide
#   ---
#   Next line is no longer supported, see UPDATE above!
#   ~/.config/nvim       -> ~/.config/nvim--nvim-basic-ide        NO LONGER SUPPORTED! SEE ABOVE!

# Don't allow this tool to run on a non-symlinked config.
for THING in ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    if ! test -L $THING; then
        echo "ERROR: You're trying to run $0 on a non-symlinked nvim config."
        exit
    fi
done

echo
echo 'Please note! You need to hand-manage the ~/.config/nvim symlink/folder! Read this script for details!'
echo

for THING in ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    set -x
    rm $THING
    set +x
done
