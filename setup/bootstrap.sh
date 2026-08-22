#!/usr/bin/env bash
# bootstrap.sh — install pixi if not present.
# Idempotent: skips install if pixi is already available.
#
# After this script runs, pixi lives at ~/.pixi/bin/pixi but is not yet on
# PATH for the current shell. Prepend ~/.pixi/bin to PATH, or invoke pixi
# via its full path until `exec bash` picks up the dotfiles bashrc (which
# handles PATH).
#
# (We intentionally set PIXI_NO_PATH_UPDATE=1 so the installer does not
# modify the user's shell rc — the dotfiles bashrc handles PATH.)

set -euo pipefail

if command -v pixi >/dev/null 2>&1; then
    echo "pixi already on PATH: $(command -v pixi) ($(pixi --version))"
    exit 0
fi

if [ -x "$HOME/.pixi/bin/pixi" ]; then
    echo "pixi already installed at \$HOME/.pixi/bin/pixi (but not on PATH for this shell)"
    echo "  -> export PATH=\"\$HOME/.pixi/bin:\$PATH\""
    exit 0
fi

echo "Installing pixi..."
echo "(PIXI_NO_PATH_UPDATE=1 — installer will not modify your shell rc;"
echo " the dotfiles bashrc handles PATH after setup.)"
echo

export PIXI_NO_PATH_UPDATE=1
curl -fsSL https://pixi.sh/install.sh | bash

echo
echo "pixi installed at \$HOME/.pixi/bin/pixi"
echo
echo "Next steps (in this same shell, from the dotfiles repo root):"
echo "  export PATH=\"\$HOME/.pixi/bin:\$PATH\"     # add pixi to PATH for this shell"
echo "  pixi run -e <profile> setup                # install tools + symlink configs"
echo "                                             # profiles: container-slim, laptop"
echo "  exec bash                                  # pick up new shell"
