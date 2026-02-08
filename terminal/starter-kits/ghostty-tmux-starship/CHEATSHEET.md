# Ghostty + tmux Cheatsheet

> Quick-reference for keybindings and shortcuts that are hard to remember.
> For full explanations, see `README.md`.
>
> **Notation:** This doc uses `Ctrl-A` for readability — this means
> `ctrl-a` (lowercase, no shift). `Ctrl-A` is our tmux prefix (tmux's
> default prefix is `Ctrl-B`). If you use a different prefix, substitute
> yours wherever you see `Ctrl-A`.

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
| Drag-reorder window | Drag tab on status bar |

## Context Menus (built-in since tmux 3.0)

| Action | Keys |
|--------|------|
| Window menu (swap, kill, rename, new) | Ctrl-A < |
| Pane menu (search, split, swap, zoom) | Ctrl-A > |
| Window menu (mouse) | Right-click on status bar tab |
| Pane menu (mouse) | Right-click in a pane |

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
| Select command output | Cmd+Triple-Click (outside tmux only) |
| Trimmed selection (no leading/trailing whitespace) | Shift+Double-Click |
| Open URL | Shift+Cmd+Click |
| Block/rectangular select | Shift+Alt+click+drag |
| Ghostty text select | Shift+click+drag |

## Session Management

| Action | Keys |
|--------|------|
| Save session | Ctrl-A Ctrl-S |
| Restore session | Ctrl-A Ctrl-R |
| Install plugins (TPM) | Ctrl-A I |
| Reload config | Ctrl-A Shift-R |

## Shell / Readline (Alt = Option on macOS)

| Action | Keys |
|--------|------|
| Jump word left | Alt+Left |
| Jump word right | Alt+Right |
| Delete word backward | Alt+Backspace |
| Delete word forward | Alt+D |
| Uppercase word from cursor | Alt+U |
| Lowercase word from cursor | Alt+L |
| Insert last arg from prev command | Alt+. |
| Transpose words | Alt+T |
