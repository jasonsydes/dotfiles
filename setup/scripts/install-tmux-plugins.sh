#!/usr/bin/env bash
# install-tmux-plugins.sh — bootstrap TPM and install tmux plugins.
# Idempotent: clones tpm if absent (skip if present); install_plugins is re-run safe.

set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

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
