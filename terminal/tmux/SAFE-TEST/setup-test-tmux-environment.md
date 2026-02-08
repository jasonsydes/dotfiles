# Setup test tmux environment

Safe way to test a new tmux config without disturbing your production
tmux sessions. Uses a separate socket (`-L test`), temporary symlinks,
and a plugin backup so nothing is lost. Walk through each section
step by step — copy/paste the code blocks, do the manual steps between.

When done, run `revert-to-normal-tmux-environment.md` to undo everything.

See [Why this exists](#why-this-exists) for background.

The point: a clean, isolated test environment that behaves like a real fresh
install — no hacks, no surprises, no interference with production tmux.

## How to use

## Setup — copy/paste this entire block into shell
```
# Point .dotfiles and .tmux.conf at test config
ln -sfn ~/C/devops/dotfiles/WK/feat/ghostty-shell-integration ~/.dotfiles
ln -sfn ~/.dotfiles/terminal/tmux/tmux.conf ~/.tmux.conf

# Back up plugins and reinstall fresh
mv ~/.tmux/plugins ~/.tmux/plugins.SAFE-TEST-BAK
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.tmux/plugins/tmux
```

# Start test server
tmux -L test new -s 210101-test-new-tmux

# Inside test server: install remaining plugins (yank, resurrect)
Press Ctrl-A then I (capital I)

# Restart tmux server to pick up plugins
Ctrl-D to close window, then:
tmux -L test new -s 210101-test-new-tmux

# Poke around. How do things look?

# When done — Ctrl-D out of all windows, then:
tmux -L test kill-server

# Revert: see revert-to-normal-tmux-environment.md

---

## Why this exists

Previous attempts at testing the new tmux config ran into problems:

- **TPM really wants `~/.tmux.conf`**. Using `tmux -f /path/to/config` causes
  TPM's `set -g @plugin` syntax to silently fail. There's a documented
  workaround (`@tpm_plugins` list syntax) but it's untested and fragile.
  Easier to just symlink `~/.tmux.conf` to the config under test.
- **Stale plugins caused cross-talk**. Old production plugins in `~/.tmux/plugins`
  bled into test sessions, causing confusing rendering issues (e.g. catppuccin
  not loading cleanly). A full wipe + fresh clone eliminates that variable.
- **Config reloading (`source-file`) hides bugs**. Cold-start behavior differs
  from reload behavior (especially with catppuccin/TPM timing). Restarting
  the test server catches issues that reloading masks.

The point: a clean, isolated test environment that behaves like a real fresh
install — no hacks, no surprises, no interference with production tmux.
