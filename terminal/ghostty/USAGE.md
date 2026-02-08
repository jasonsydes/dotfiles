# Ghostty Usage Notes

Quick reference for Ghostty features and workarounds, especially inside tmux.

## Mouse Modifiers Inside tmux

tmux captures mouse events. To bypass tmux and let Ghostty handle the mouse
directly, hold **Shift** as an extra modifier.

| Action | Outside tmux | Inside tmux |
|--------|-------------|-------------|
| Rectangular/block selection | Alt+click+drag | **Shift**+Alt+click+drag |
| Select command output | Cmd+Triple-Click | Not available (architectural limitation) |
| Open URL | Cmd+Click | **Shift**+Cmd+Click |
| Normal text selection (Ghostty) | Click+drag | **Shift**+Click+drag |

The Shift bypass works because tmux's `mouse on` only captures unmodified
and standard-modified mouse events. Shift tells tmux to ignore the click
and pass it to the outer terminal.

## Prompt Navigation

| Action | Outside tmux | Inside tmux |
|--------|-------------|-------------|
| Jump to previous prompt | Cmd+Shift+Up | Ctrl+Shift+Up |
| Jump to next prompt | Cmd+Shift+Down | Ctrl+Shift+Down |

Outside tmux, Ghostty handles it natively via `jump_to_prompt`.
Inside tmux, the key passes through to tmux which uses OSC 133 markers.
See `terminal/ghostty/config` and `tmux/tmux.260205-NEW.conf` for the bindings.

## Shift+Enter / Alt+Enter (Claude Code newline)

Both work inside and outside tmux. Configured in `terminal/ghostty/config`:
```
keybind = shift+enter=text:\x1b\r
```

## Clipboard

OSC 52 clipboard works inside tmux (set-clipboard on). Yank in tmux copy
mode and it lands on the system clipboard. Works over SSH too — the escape
sequence travels back through the SSH tunnel to Ghostty.

## tmux Shortcuts (custom bindings)

| Action | Keys |
|--------|------|
| Horizontal split | Ctrl-A \| |
| Vertical split | Ctrl-A - |
| Save sessions (resurrect) | Ctrl-A Ctrl-S |
| Restore sessions (resurrect) | Ctrl-A Ctrl-R |
| Install plugins (TPM) | Ctrl-A I |

## tmux Version Requirement

Requires **tmux 3.6a** (brew). tmux 3.5a (conda) has a paste bug where
`extended-keys-format csi-u` causes `[106;5u` garbage on multi-line paste.

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
