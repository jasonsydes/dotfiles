# Remote Machine Setup — Ghostty + tmux

Instructions for setting up the new tmux config on a remote machine
connected from Ghostty via SSH.

## Prerequisites

- **tmux 3.6a+** — required. 3.5a has a paste bug with `extended-keys-format csi-u`
  that produces `[106;5u` garbage. Install from source or package manager.
- **git** — for cloning the repo and TPM
- **Ghostty** on the local machine — `ssh-terminfo` auto-installs `xterm-ghostty`
  terminfo on the remote on first SSH connect

## 1. Verify terminfo

After SSH from Ghostty:

```bash
infocmp xterm-ghostty
```

If missing, copy it manually from your local machine:

```bash
# On local machine
infocmp -x xterm-ghostty > /tmp/xterm-ghostty.terminfo
scp /tmp/xterm-ghostty.terminfo remote:~/.terminfo/
# On remote
tic -x ~/.terminfo/xterm-ghostty.terminfo
```

## 2. Clone dotfiles

```bash
DIR=~/C/devops/dotfiles   # or wherever you want

git clone --bare https://github.com/jasonsydes/dotfiles "$DIR/.bare-repo"

# Set up fetch refspec (bare clones don't have one by default)
git -C "$DIR/.bare-repo" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git -C "$DIR/.bare-repo" fetch origin

# Create worktrees
git -C "$DIR/.bare-repo" worktree add "$DIR/hub" origin/dev --checkout -b dev
git -C "$DIR/.bare-repo" worktree add "$DIR/WK/feat/ghostty-shell-integration" feat/260206-ghostty-shell-integration

# Symlink — point at the branch you want active
ln -sfn "$DIR/hub" ~/.dotfiles
# Or for testing the feature branch:
ln -sfn "$DIR/WK/feat/ghostty-shell-integration" ~/.dotfiles
```

## 3. Install TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## 4. Install catppuccin

Catppuccin is loaded via `source-file`, not TPM. Clone it manually:

```bash
git clone https://github.com/catppuccin/tmux ~/.tmux/plugins/tmux
```

## 5. Launch tmux and install plugins

```bash
tmux -f ~/.dotfiles/terminal/tmux/tmux.conf new -s main
```

First launch will error on catppuccin source-file if step 4 was skipped.
Inside tmux:

1. Press `Ctrl-A I` to install remaining TPM plugins (resurrect)
2. Reload: `tmux source-file ~/.dotfiles/terminal/tmux/tmux.conf`

## 6. Verify

Quick smoke tests:

```bash
# True color — should show smooth gradient
awk 'BEGIN{ for(i=0;i<256;i++) printf "\033[48;2;%d;0;%dm \033[0m",i,255-i; print ""}'

# OSC 52 clipboard — Cmd+V locally after running this
printf '\033]52;c;%s\a' "$(echo -n 'hello from remote' | base64)"

# Paste — paste multi-line text, should be clean (no [106;5u garbage)
```

## What works / doesn't on remote

- **Clipboard (OSC 52):** Works through SSH + tmux back to local Ghostty
- **True color:** Works
- **Paste:** Works (tmux 3.6a+)
- **Mouse:** Works (scroll, select, rectangular)
- **URL click:** Works (Shift+Cmd+Click)
- **Resurrect save/restore:** Works (Ctrl-A Ctrl-S / Ctrl-A Ctrl-R)
- **Prompt nav (Ctrl+Shift+Up/Down):** Does NOT work — requires Ghostty
  shell integration (`GHOSTTY_RESOURCES_DIR`), which isn't available on
  the remote since Ghostty isn't installed there
- **Cmd+Triple-Click:** Does NOT work inside tmux (architectural — tmux
  consumes OSC 133 sequences)

## Notes

- `pbcopy` is not used — clipboard is entirely OSC 52 (cross-platform)
- `delta` (git pager) is optional — install it or set `core.pager=less`
- The config expects `~/.tmux/plugins/tmux/` (catppuccin) and
  `~/.tmux/plugins/tpm/` (TPM) to exist before sourcing
