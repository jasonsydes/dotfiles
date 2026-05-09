#!/bin/bash

# Take an existing (non-symlinked) nvim config (generally after a fresh install)
# and convert it into a symlinked nvim config.

# UPDATE 260509:
#   We now HAND-MANAGE the symlinks of ~/.config/nvim.
#   Why? 
#   Currently, we're just pointing the nvim config at our devops repo, for example like so:
#      ~/config/nvim -> /Users/sydes/C/devops/vim/nvim-configs/nvim--kickstart.2025-05-22
#   This is fine.
#   I don't want to rewrite these scripts to support that use case.
#   These scripts are fine as is for the other three files beyond ~/.config/nvim
#   ~/.config/nvim can become a special case.

# Usage:
#   store-exisiting-nvim-config.sh NAME
# Example:
#   store-exisiting-nvim-config.sh nvim-basic-ide
# Above example will result in SYMLINKS that look like this: 
#   ~/.cache/nvim        -> ~/.cache/nvim--nvim-basic-ide 
#   ~/.local/state/nvim  -> ~/.local/state/nvim--nvim-basic-ide
#   ~/.local/share/nvim  -> ~/.local/share/nvim--nvim-basic-ide
#   ---
#   Next line is no longer supported, see UPDATE above!
#   ~/.config/nvim       -> ~/.config/nvim--nvim-basic-ide     NO LONGER SUPPORTED! SEE ABOVE!


NAME=$1

if [[ ! $NAME ]] ; then
    echo Usage: Please provide a name.
    exit
fi

# Don't allow this tool to run on an existing symlinked config.
for THING in ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    if test -L $THING; then
        echo "ERROR: You're trying to run $0 on an already symlinked nvim config."
        exit
    fi
done

echo
echo 'WARNING: Please note! You need to hand-manage the ~/.config/nvim symlink/folder! Read this script for details!'
echo

for THING in ~/.cache/nvim ~/.local/state/nvim ~/.local/share/nvim; do
    NEW_THING="${THING}--${NAME}"
    # Just in case a particular THING folder hasn't been made yet (eg ~/.cache/nvim), go ahead and make it.
    mkdir -p $THING
    set -x
    mv $THING $NEW_THING
    ln -s $NEW_THING $THING
    set +x
done
