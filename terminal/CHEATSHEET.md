# Ghostty + tmux Cheatsheet

> Quick-reference for keybindings and shortcuts that are hard to remember.
> For architectural decisions and hard-fought wins, see `REFERENCE.md`.

## tmux Prefix: Ctrl-A

| Action | Keys |
|--------|------|
| Send literal Ctrl-A | Ctrl-A Ctrl-A |

## Windows

| Action | Keys |
|--------|------|
| Next window | Ctrl-A n _or_ Ctrl-A Ctrl-N |
| Previous window | Ctrl-A p _or_ Ctrl-A Ctrl-P |
| Last window (toggle) | Ctrl-A a |
| Go to window N | Ctrl-A 1, Ctrl-A 2, etc. |
| Swap window forward | Ctrl-A > |
| Swap window backward | Ctrl-A < |
| Drag-reorder window | Drag tab on status bar |

## Panes

| Action | Keys |
|--------|------|
| Horizontal split | Ctrl-A \| |
| Vertical split | Ctrl-A - |

## Copy Mode (vi keys)

| Action | Keys |
|--------|------|
| Enter copy mode | Ctrl-A [ |
| Start selection | v |
| Yank (copy) | y |
| Mouse select | Drag to select (copies on release) |

## Prompt Navigation

| Context | Keys |
|---------|------|
| Outside tmux | Cmd+Shift+Up/Down |
| Inside tmux | Ctrl+Shift+Up/Down |

## Mouse (inside tmux, hold Shift to bypass)

| Action | Keys |
|--------|------|
| Open URL | Shift+Cmd+Click |
| Block select | Shift+Alt+click+drag |
| Ghostty text select | Shift+click+drag |

## Session Management

| Action | Keys |
|--------|------|
| Save session | Ctrl-A Ctrl-S |
| Restore session | Ctrl-A Ctrl-R |
| Install plugins (TPM) | Ctrl-A I |
| Reload config | Ctrl-A Shift-R |
