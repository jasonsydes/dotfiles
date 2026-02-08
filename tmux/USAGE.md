# tmux Usage Notes

Quick reference for tmux keybindings, features, and config choices.

## Prefix

The prefix is **Ctrl-A** (not the default Ctrl-B).

To send a literal Ctrl-A to the program inside (e.g. go to beginning of
line in bash), press **Ctrl-A Ctrl-A**.

## Window Navigation

| Action | Keys |
|--------|------|
| Next window | Ctrl-A n _or_ Ctrl-A Ctrl-N |
| Previous window | Ctrl-A p _or_ Ctrl-A Ctrl-P |
| Last window (toggle) | Ctrl-A a |
| Go to window N | Ctrl-A N (e.g. Ctrl-A 1) |

The Ctrl-P/N variants let you hold Ctrl the whole time — faster than
lifting Ctrl between the prefix and the key.

## Splits

| Action | Keys |
|--------|------|
| Horizontal split | Ctrl-A \| |
| Vertical split | Ctrl-A - |

New panes open in the current directory.

## Copy Mode (vi keys)

| Action | Keys |
|--------|------|
| Enter copy mode | Ctrl-A [ |
| Start selection | v |
| Yank (copy to clipboard) | y |
| Mouse select | drag to select (copies on release via OSC 52) |

Clipboard works via OSC 52 — yank in tmux lands on the system clipboard,
even over SSH.

## Prompt Navigation (OSC 133)

| Action | Outside tmux | Inside tmux |
|--------|-------------|-------------|
| Previous prompt | Cmd+Shift+Up | Ctrl+Shift+Up |
| Next prompt | Cmd+Shift+Down | Ctrl+Shift+Down |

Requires shell integration (Ghostty's OSC 133 markers). Inside tmux these
are manually sourced — see `terminal/ghostty/interactive`.

## Mouse

Mouse mode is on. Scroll wheel enters copy mode. Drag windows on the
status bar to reorder them.

To bypass tmux's mouse capture and let Ghostty handle clicks directly,
hold **Shift** (see `terminal/ghostty/USAGE.md`).

## Session Management

| Action | Keys |
|--------|------|
| Save session (resurrect) | Ctrl-A Ctrl-S |
| Restore session (resurrect) | Ctrl-A Ctrl-R |
| Install plugins (TPM) | Ctrl-A I |
| Reload config | Ctrl-A Shift-R |

Closing a session does not detach from tmux (`detach-on-destroy off`).

## Config Reload

**Ctrl-A Shift-R** reloads `~/.tmux.conf`. Note: reloading applies new
settings but doesn't undo removed settings from a previous config — for a
clean slate, restart the tmux server.

## From tmux-sensible

These settings are manually incorporated (not via the plugin) from
[tmux-plugins/tmux-sensible](https://github.com/tmux-plugins/tmux-sensible).
See the `── From tmux-sensible ──` section in `tmux.conf` for detailed
comments on each one:

| Setting | What it does |
|---------|-------------|
| `display-time 4000` | Status messages visible for 4s instead of 750ms |
| `status-interval 5` | Status bar refreshes every 5s instead of 15s |
| `focus-events on` | Forwards focus events so neovim auto-reloads files |
| `aggressive-resize on` | Windows sized per-viewer, not smallest client |
| `status-keys emacs` | Emacs keys in command prompt (even for vim users) |

Settings already covered elsewhere in the config: `escape-time 0`,
`history-limit 1000000`, `default-terminal tmux-256color`, `set-clipboard on`,
`send-prefix`.

## Terminal Setup

- Inner TERM: `tmux-256color`
- Outer TERM (Ghostty): `xterm-ghostty` with RGB + extended keys
- Extended keys: CSI-u format (kitty keyboard protocol)
- Requires **tmux 3.6a** (brew) — 3.5a has paste bugs with CSI-u
