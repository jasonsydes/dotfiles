# Ghostty + tmux Starter Kit

A minimal, well-commented dotfiles setup for [Ghostty](https://ghostty.org/) terminal + [tmux](https://github.com/tmux/tmux).

- Jason Sydes
- 2026-02-08

> **Note:** These configs are extracted from a working installation but have
> not been tested as a standalone kit. This is meant to communicate my setup
> to other terminal users, not as a turnkey solution. It should be easily
> adaptable to your own dotfiles.

## What's included

- **Ghostty config** — theme, font, keybindings, shell integration
- **tmux config** — Ctrl-A prefix, vi copy mode, mouse, OSC 52 clipboard, prompt navigation, [Catppuccin Mocha](https://github.com/catppuccin/tmux) theme, settings from [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
- **bashrc** — minimal bash config that wires Ghostty shell integration inside tmux
- **inputrc** — readline config: bracketed paste security, history prefix search, case-insensitive completion, magic space

## Requirements

- [Ghostty](https://ghostty.org/) terminal
- tmux 3.6+ (`brew install tmux`) — 3.5a has paste bugs with CSI-u extended keys
- bash 5+ (`brew install bash` on macOS)
- A [Nerd Font](https://www.nerdfonts.com/) (config uses Inconsolata Nerd Font)
- [bash-preexec](https://github.com/rcaloras/bash-preexec)

## Install

```bash
# 1. Clone this repo
git clone <this-repo> ~/dotfiles

# 2. Install bash-preexec
curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh

# 3. Install TPM (tmux plugin manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 4. Install Catppuccin tmux theme
git clone https://github.com/catppuccin/tmux ~/.tmux/plugins/tmux

# 5. Symlink configs
mkdir -p ~/.config/ghostty
ln -s ~/dotfiles/ghostty/config ~/.config/ghostty/config
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/bash/bashrc ~/.bashrc
ln -s ~/dotfiles/bash/inputrc ~/.inputrc

# 6. Open Ghostty, start tmux, press Ctrl-A I to install tmux plugins
```

## Prefix

The tmux prefix is **Ctrl-A** (not the default Ctrl-B).

To send a literal Ctrl-A to the program inside (e.g. go to beginning of
line in bash), press **Ctrl-A Ctrl-A**.

## Window & Pane Navigation

| Action | Keys |
|--------|------|
| Next window | Ctrl-A n _or_ Ctrl-A Ctrl-N |
| Previous window | Ctrl-A p _or_ Ctrl-A Ctrl-P |
| Last window (toggle) | Ctrl-A a |
| Go to window N | Ctrl-A N (e.g. Ctrl-A 1) |
| Horizontal split | Ctrl-A \| |
| Vertical split | Ctrl-A - |

The Ctrl-P/N variants let you hold Ctrl the whole time — faster than
lifting Ctrl between the prefix and the key. New panes open in the
current directory.

## Copy Mode (vi keys)

| Action | Keys |
|--------|------|
| Enter copy mode | Ctrl-A [ |
| Start selection | v |
| Yank (copy to clipboard) | y |
| Mouse select | drag to select (copies on release via OSC 52) |

Clipboard works via OSC 52 — yank in tmux lands on the system clipboard,
even over SSH. No `pbcopy`/`xclip` needed.

## Prompt Navigation (OSC 133)

| Action | Outside tmux | Inside tmux |
|--------|-------------|-------------|
| Previous prompt | Cmd+Shift+Up | Ctrl+Shift+Up |
| Next prompt | Cmd+Shift+Down | Ctrl+Shift+Down |

Outside tmux, Ghostty handles it natively. Inside tmux, the key passes
through to tmux which uses OSC 133 markers from shell integration.

## Mouse

Mouse mode is on. Scroll wheel enters copy mode. Drag windows on the
status bar to reorder them.

tmux captures mouse events. To bypass tmux and let Ghostty handle the
mouse directly, hold **Shift** as an extra modifier:

| Action | Outside tmux | Inside tmux |
|--------|-------------|-------------|
| Rectangular/block selection | Alt+click+drag | **Shift**+Alt+click+drag |
| Select command output | Cmd+Triple-Click | Not available (architectural) |
| Trimmed selection (no whitespace) | Shift+Double-Click | Shift+Double-Click |
| Open URL | Cmd+Click | **Shift**+Cmd+Click |
| Normal text selection (Ghostty) | Click+drag | **Shift**+Click+drag |

The Shift bypass works because tmux's `mouse on` only captures unmodified
and standard-modified mouse events.

## Session Management

| Action | Keys |
|--------|------|
| Save session (resurrect) | Ctrl-A Ctrl-S |
| Restore session (resurrect) | Ctrl-A Ctrl-R |
| Install plugins (TPM) | Ctrl-A I |
| Reload config | Ctrl-A Shift-R |

Closing a session does not detach from tmux (`detach-on-destroy off`).

Reloading applies new settings but doesn't undo removed settings from
a previous config — for a clean slate, restart the tmux server.

## Shift+Enter (Claude Code newline)

Works inside and outside tmux. Configured in `ghostty/config`:
```
keybind = shift+enter=text:\x1b\r
```

## Shell Integration

Ghostty auto-injects shell integration outside tmux. Inside tmux, it's
manually sourced in the bashrc. This enables OSC 133 prompt marking
which powers tmux's prompt navigation.

Features that work via shell integration:
- Prompt navigation (Cmd+Shift or Ctrl+Shift, see above)
- Cmd+Triple-Click to select command output (outside tmux only —
  inside tmux this is architecturally impossible because tmux consumes
  OSC 133 sequences for its own prompt tracking, they never reach Ghostty)
- Working directory reporting (OSC 7)
- Title bar updates

## Terminal Setup

- Inner TERM: `tmux-256color`
- Outer TERM (Ghostty): `xterm-ghostty` with RGB + extended keys
- Extended keys: CSI-u format (kitty keyboard protocol)

## From tmux-sensible

These settings are manually incorporated (not via the plugin) from
[tmux-plugins/tmux-sensible](https://github.com/tmux-plugins/tmux-sensible).
See the `── From tmux-sensible ──` section in `tmux/tmux.conf` for
detailed comments on each one:

| Setting | What it does |
|---------|-------------|
| `display-time 4000` | Status messages visible for 4s instead of 750ms |
| `status-interval 5` | Status bar refreshes every 5s instead of 15s |
| `focus-events on` | Forwards focus events so neovim auto-reloads files |
| `aggressive-resize on` | Windows sized per-viewer, not smallest client |
| `status-keys emacs` | Emacs keys in command prompt (even for vim users) |

## Known Quirks

- **No Cmd+F search in Ghostty** (yet): Coming in Ghostty 1.3. Workaround:
  use tmux copy mode (`Ctrl-A [` then `/` to search).
- **Cmd+Triple-Click doesn't work inside tmux**: Architecturally impossible —
  tmux consumes the OSC 133 sequences that power this feature. Works fine
  outside tmux.
- **Mouse scroll in less/bat/man enters tmux copy mode**: By default, these
  apps don't tell tmux they handle mouse events. Add `export LESS="--mouse"`
  to your bashrc to fix (commented out in the included bashrc).
