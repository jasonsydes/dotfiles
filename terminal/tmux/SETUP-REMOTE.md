# Remote Machine Setup — Ghostty + tmux

What the tmux config needs on a remote host reached from Ghostty over SSH,
and what works there once it is running.

Installing the dotfiles themselves (clone, symlinks,
`pixi run -e server setup`) is `setup/guide-new-linux-server.md`. That
procedure provides every prerequisite below; this file explains them and
covers what is specific to tmux on a remote.

## Prerequisites

All three are installed by `pixi run -e server setup`.

- **tmux 3.6a+** — 3.5a has a paste bug with `extended-keys-format csi-u`
  that produces `[106;5u` garbage. The profiles pin `tmux=3.7c_` exactly;
  conda-forge tmux versions sort oddly (see `pixi.toml`). After `exec bash -l`,
  `command -v tmux` should print `~/.pixi/bin/tmux`, not the system one.
- **`xterm-ghostty` terminfo** — Ghostty's `ssh-terminfo` feature installs
  it on the first SSH connect from Ghostty. On Linux it lands in the
  letter layout (`~/.terminfo/x/`), which pixi's tmux cannot read;
  `setup/scripts/link-terminfo-hex.sh` adds the hex-layout links it needs.
  Symptom when they are missing: `can't find terminfo database`. Details:
  `setup/guide-troubleshooting.md`, "Terminfo: pixi tmux and Ghostty".
- **catppuccin and TPM** — `~/.config/tmux/plugins/catppuccin/tmux/` and
  `~/.tmux/plugins/tpm/`, from `setup/scripts/install-tmux-plugins.sh`.
  Catppuccin is loaded with `source-file`, not TPM, so tmux reports an
  error on startup if it is missing.

### If the terminfo entry is missing entirely

For example, after connecting only from another terminal. Copy it from the
local machine, then add the hex links:

```bash
# On local machine
infocmp -x xterm-ghostty > /tmp/xterm-ghostty.terminfo
scp /tmp/xterm-ghostty.terminfo remote:~/.terminfo/
# On remote
tic -x ~/.terminfo/xterm-ghostty.terminfo
bash ~/.dotfiles/setup/scripts/link-terminfo-hex.sh
```

## Launch

```bash
tmux new -s main
```

If the catppuccin bar or a plugin is missing, press `Ctrl-A I` inside tmux
to install the TPM plugins, then reload with `tmux source-file ~/.tmux.conf`.

## Trying a feature branch

On a ghee-layout host, `~/.dotfiles` is a symlink, so a feature worktree
can be made live and then swapped back:

```bash
DIR=~/C/devops/dotfiles
git -C "$DIR/.bare-repo" worktree add "$DIR/WK/feat/<name>" <branch>
ln -sfn "$DIR/WK/feat/<name>" ~/.dotfiles     # try it
ln -sfn "$DIR/hub" ~/.dotfiles                # back to normal
```

## Verify

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
- `delta` is required, not optional: `git/.gitconfig` sets `pager = delta`.
  Every setup profile installs `git-delta`.
