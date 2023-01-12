#!/bin/bash

# Disable a symlinked lvim config by deleting the symlinks.

# Usage:
#   disable-lvim-config.sh
# Example:
#   disable-lvim-config.sh 
# Above example will DELETE SYMLINKS that look like this: 
#           INCOMPLETE
#   ~/.config/lvim              -> ~/.config/lvim--lvim-basic-ide 
#   ~/.cache/lvim               -> ~/.cache/lvim--lvim-basic-ide 
#   ~/.local/state/lvim         -> ~/.local/state/lvim--lvim-basic-ide
#   ~/.local/share/lunarvim     -> ~/.local/share/lunarvim--lvim-basic-ide
#   ~/.local/bin/lvim           -> ~/.local/bin/lvim--lvim-basic-ide

# Don't allow this tool to run on a non-symlinked config.
# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/lvim; do
for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ; do
    if ! test -L $THING; then
        echo "ERROR: You're trying to run $0 on a non-symlinked lvim config."
        exit
    fi
done

# for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ~/.local/state/lvim; do
for THING in ~/.config/lvim ~/.cache/lvim ~/.local/bin/lvim ~/.local/share/lunarvim ; do
    set -x
    rm $THING
    set +x
done
