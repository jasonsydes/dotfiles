# Ghostty + tmux Reference

> **Origin:** Built over 260205–260208 during a ground-up rebuild of the
> tmux config for Ghostty terminal. Every section below represents a
> hard-fought win, an architectural discovery, or a decision that took
> real debugging to reach.
>
> **What belongs here:** Hard-fought wins, architectural decisions, and
> behaviors that required significant investigation to understand. If it
> took more than 15 minutes to figure out, it belongs here. Duplicate
> content in other docs (CHEATSHEET.md, SETUP-REMOTE.md, etc.) is fine.
>
> **What doesn't belong here:** Routine keybindings, simple config options,
> or things that are obvious from the tmux/Ghostty docs. Those go in
> `CHEATSHEET.md`.

---

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

## Clipboard: OSC 52 Everywhere

Clipboard is handled entirely via OSC 52 (`set-clipboard on` in tmux).
No `pbcopy`, `xclip`, or platform detection needed. Works:
- Local macOS
- Over SSH through tmux back to local Ghostty
- Linux remotes without any clipboard tool installed

tmux's `copy-pipe` and `copy-pipe-and-cancel` without a command argument
use OSC 52 automatically. Bonus: mouse selection stays in place instead
of jumping to the bottom of the pane (the old `copy-pipe "pbcopy"`
behavior exited copy mode on release).

## Prompt Navigation: Two Modes

| Context | Keys | Mechanism |
|---------|------|-----------|
| Outside tmux | Cmd+Shift+Up/Down | Ghostty native `jump_to_prompt` |
| Inside tmux | Ctrl+Shift+Up/Down | tmux `previous-prompt`/`next-prompt` via OSC 133 |

Inside tmux, Ghostty can't handle it natively because tmux is the
terminal. The tmux config binds Ctrl+Shift+Up/Down to copy-mode prompt
navigation. This requires OSC 133 markers, which are injected by
Ghostty's shell integration script.

Ghostty config uses `super+shift` (not `ctrl+shift`) for its native
prompt nav, freeing `ctrl+shift` for tmux passthrough.

## Shell Integration Inside tmux

Ghostty auto-injects shell integration outside tmux via POSIX mode.
Inside tmux, this doesn't work — tmux is the terminal, not Ghostty.

**Solution:** `terminal/ghostty/interactive` manually sources Ghostty's
integration script when both `$TMUX` and `$GHOSTTY_RESOURCES_DIR` are set.
This enables OSC 133 prompt marking inside tmux.

**Load order matters:** bash-preexec must be sourced BEFORE the Ghostty
integration script. The bashrc load chain handles this.

**On remote machines:** `$GHOSTTY_RESOURCES_DIR` is not set (Ghostty isn't
installed), so the guard in `interactive` correctly skips sourcing.
Prompt navigation is not available on remotes.

## Cmd+Triple-Click Inside tmux: Architecturally Impossible

Cmd+Triple-Click selects command output in Ghostty by using OSC 133
prompt markers to find command boundaries. Inside tmux, this is
impossible: tmux consumes OSC 133 sequences for its own prompt tracking
and never forwards them to Ghostty. This is architectural, not a bug.

## Mouse Scroll: App-Aware Behavior

The scroll wheel binding checks `mouse_any_flag`:
- **App sets flag (vim, neovim):** tmux forwards scroll to the app
- **App doesn't set flag (less, bat, shell):** tmux enters copy mode

For less/bat, `export LESS="--mouse"` makes them handle scroll natively.
See `terminal/tmux/mouse-scroll-integration---apps-inside-tmux.md`.

## Mouse: Shift Bypass

tmux's `mouse on` captures mouse events. To bypass tmux and let Ghostty
handle clicks directly, hold **Shift**:

| Action | Outside tmux | Inside tmux |
|--------|-------------|-------------|
| Rectangular/block select | Alt+click+drag | **Shift**+Alt+click+drag |
| Select command output | Cmd+Triple-Click | Not available (architectural) |
| Open URL | Cmd+Click | **Shift**+Cmd+Click |
| Normal text select | Click+drag | **Shift**+Click+drag |

## Window Drag Reorder

Dragging tabs on the status bar to reorder windows requires
`MouseDragEnd1Status` with `run-shell`, not `MouseDrag1Status` with
`swap-window -t=`. The `-t=` syntax doesn't resolve the mouse target
properly in a direct binding — tmux needs `run-shell` to interpolate
`#{window_index}` at execution time.

```
# Doesn't work:
bind -n MouseDrag1Status swap-window -d -t=

# Works:
bind -n MouseDragEnd1Status run-shell 'tmux swap-window -d -t #{window_index}'
```

## Shift+Enter / Alt+Enter (Claude Code)

Both produce `\x1b\r` inside and outside tmux. Configured in Ghostty:
```
keybind = shift+enter=text:\x1b\r
```
Alt+Enter works natively (Alt sends escape prefix).

## tmux Version Requirement

**tmux 3.6a minimum.** tmux 3.5a has a paste bug where
`extended-keys-format csi-u` causes `[106;5u` garbage on multi-line
paste. This is fixed in 3.6a.

## Terminal Features

- Inner TERM: `tmux-256color`
- Outer TERM (Ghostty): `xterm-ghostty` with RGB + extended keys
- Extended keys: CSI-u format (kitty keyboard protocol)
- `allow-passthrough on` for escape sequence forwarding (OSC 133, etc.)

## PROMPT_COMMAND Is a Bash Array

In bash 5.1+, `PROMPT_COMMAND` can be an array. `${PROMPT_COMMAND}`
only expands element [0]. Hard-assigning `PROMPT_COMMAND="string"`
destroys the array. Always append:
```bash
PROMPT_COMMAND[0]="${PROMPT_COMMAND[0]:+${PROMPT_COMMAND[0]};}new_command"
```

## tmux-sensible Settings

Manually incorporated (not via plugin) from tmux-plugins/tmux-sensible:

| Setting | What it does |
|---------|-------------|
| `display-time 4000` | Status messages visible for 4s instead of 750ms |
| `status-interval 5` | Status bar refreshes every 5s instead of 15s |
| `focus-events on` | Forwards focus events so neovim auto-reloads files |
| `aggressive-resize on` | Windows sized per-viewer, not smallest client |
| `status-keys emacs` | Emacs keys in command prompt (even for vim users) |
