# Ghostty + tmux Usage Notes

Quick reference for Ghostty and tmux features, keybindings, and workarounds.

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

Outside tmux, Ghostty handles it natively via `jump_to_prompt`.
Inside tmux, the key passes through to tmux which uses OSC 133 markers.
Requires shell integration — see `terminal/ghostty/interactive`.

Not available on remote machines where Ghostty isn't installed.

## Mouse

Mouse mode is on. Scroll wheel enters copy mode.

tmux captures mouse events. To bypass tmux and let Ghostty handle the
mouse directly, hold **Shift** as an extra modifier:

| Action | Outside tmux | Inside tmux |
|--------|-------------|-------------|
| Rectangular/block selection | Alt+click+drag | **Shift**+Alt+click+drag |
| Select command output | Cmd+Triple-Click | Not available (architectural) |
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

## Shift+Enter / Alt+Enter (Claude Code newline)

Both work inside and outside tmux. Configured in `terminal/ghostty/config`:
```
keybind = shift+enter=text:\x1b\r
```

## Shell Integration

Ghostty auto-injects shell integration outside tmux. Inside tmux, it's
manually sourced in `terminal/ghostty/interactive`. This enables OSC 133
prompt marking which powers tmux's prompt navigation.

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
- Requires **tmux 3.6a** — 3.5a has paste bugs with CSI-u

## From tmux-sensible

These settings are manually incorporated (not via the plugin). See the
`── From tmux-sensible ──` section in `tmux.conf` for detailed comments:

| Setting | What it does |
|---------|-------------|
| `display-time 4000` | Status messages visible for 4s instead of 750ms |
| `status-interval 5` | Status bar refreshes every 5s instead of 15s |
| `focus-events on` | Forwards focus events so neovim auto-reloads files |
| `aggressive-resize on` | Windows sized per-viewer, not smallest client |
| `status-keys emacs` | Emacs keys in command prompt (even for vim users) |
