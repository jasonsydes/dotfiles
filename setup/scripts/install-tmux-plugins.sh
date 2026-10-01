#!/usr/bin/env bash
# install-tmux-plugins.sh — catppuccin theme, TPM, and the TPM plugins.
# Idempotent: each clone is skipped if its directory exists; install_plugins
# is re-run safe. Writes only inside ~/.config/tmux and ~/.tmux.
#
# Catppuccin is NOT a TPM plugin here: tmux.conf loads it with source-file
# from the XDG path, so it must be on disk before tmux reads the config.
#
# TPM's install_plugins starts a tmux server to read ~/.tmux.conf, so two
# things must already be true, or it aborts with "Tmux Plugin Manager not
# configured in tmux.conf":
#   - ~/.tmux.conf is symlinked (see setup/README.md for the order)
#   - tmux can find terminfo for $TERM (link-terminfo-layouts.sh runs first)
# If it still fails, nothing is lost: start tmux and press prefix + I.

set -euo pipefail

CATPPUCCIN_DIR="$HOME/.config/tmux/plugins/catppuccin/tmux"
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$CATPPUCCIN_DIR" ]; then
    echo "Cloning catppuccin into $CATPPUCCIN_DIR"
    mkdir -p "$(dirname "$CATPPUCCIN_DIR")"
    git clone https://github.com/catppuccin/tmux "$CATPPUCCIN_DIR"
else
    echo "catppuccin already present at $CATPPUCCIN_DIR (skipping clone)"
fi

if [ ! -d "$TPM_DIR" ]; then
    echo "Cloning TPM into $TPM_DIR"
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM already present at $TPM_DIR (skipping clone)"
fi

echo "Installing tmux plugins via TPM"
"$TPM_DIR/bin/install_plugins"

echo "tmux plugins installed."
