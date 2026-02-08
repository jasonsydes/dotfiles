# Ghostty + tmux Test Results

Tested 260207 (local) and 260208 (remote + dev branch).
Config: `terminal/tmux/tmux.conf` on `dev` branch.

## Local (macOS, Ghostty, tmux 3.6a brew)

| Test | Result | Notes |
|------|--------|-------|
| Shift+Enter | PASS | Inside + outside tmux |
| Alt/Opt+Enter | PASS | Inside + outside tmux |
| Multi-line paste | PASS | Requires tmux 3.6a (3.5a has `[106;5u` garbage) |
| True color / RGB | PASS | Smooth gradient |
| Session name | PASS | Right side of status bar |
| OSC 52 clipboard | PASS | |
| Mouse scroll (shell) | PASS | Enters copy mode |
| Mouse scroll (vim) | PASS | Scrolls inside vim, no copy mode (vim sets `mouse_any_flag`) |
| Mouse selection | PASS | Copies to clipboard, stays in place (OSC 52) |
| Rectangular selection | PASS | Alt+click+drag outside, Shift+Alt inside tmux |
| Window drag reorder | PASS | Fixed: `MouseDragEnd1Status` + `run-shell` |
| Cmd+Triple-Click | PASS outside / N/A inside | tmux consumes OSC 133 (architectural) |
| Prompt nav (outside tmux) | PASS | Cmd+Shift+Up/Down |
| Prompt nav (inside tmux) | PASS | Ctrl+Shift+Up/Down |
| Shell integration auto-load | PASS | `__ghostty_precmd` in `precmd_functions` |
| URL click | PASS | Shift+Cmd+Click |
| Extended keys (CSI-u) | PARTIAL | Ctrl+Shift combos work; Ctrl+; and Ctrl+Enter don't |

## Remote — dev branch (talapas, Linux, Ghostty SSH, tmux 3.6a)

| Test | Result | Notes |
|------|--------|-------|
| True color / RGB | PASS | |
| OSC 52 clipboard | PASS | Works through SSH + tmux back to local Ghostty |
| Vi yank (copy-mode) | PASS | |
| Multi-line paste | PASS | |
| Mouse scroll (shell) | PASS | |
| Mouse scroll (vim) | PASS | Scrolls inside vim, no copy mode |
| Mouse selection | PASS | Stays in place on release |
| Rectangular selection | PASS | |
| URL click | PASS | Shift+Cmd+Click |
| Session name | PASS | |
| Resurrect save/restore | PASS | |
| Window drag reorder | PASS | Fixed: `MouseDragEnd1Status` + `run-shell` |
| Shift+Enter / Alt+Enter | PASS | Confirmed via `cat -v` (both send `^[` + newline) |
| Prompt nav (Ctrl+Shift+Up/Down) | FAIL (expected) | No Ghostty on remote, no shell integration, no OSC 133 |

## Known Limitations

- **Cmd+Triple-Click inside tmux** — Architectural. tmux consumes OSC 133 sequences.
- **Prompt nav on remote** — Ghostty shell integration not available (no `GHOSTTY_RESOURCES_DIR`).
- **tmux 3.5a paste bug** — `extended-keys-format csi-u` causes garbage. Requires 3.6a.
- **Extended keys edge cases** — Ctrl+; and Ctrl+Enter don't send distinct codes. Low priority.

## Go-Live Blockers

None. All critical functionality passes on both local and remote.
