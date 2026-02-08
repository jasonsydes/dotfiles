# Ghostty + tmux Test Results

Tested 260207 (local) and 260208 (remote).
Config: `terminal/tmux/tmux.conf` on branch `feat/260206-ghostty-shell-integration`.

## Local (macOS, Ghostty, tmux 3.6a brew)

| Test | Result | Notes |
|------|--------|-------|
| Shift+Enter | PASS | Inside + outside tmux |
| Alt/Opt+Enter | PASS | Inside + outside tmux |
| Multi-line paste | PASS | Requires tmux 3.6a (3.5a has `[106;5u` garbage) |
| True color / RGB | PASS | Smooth gradient |
| Session name | PASS | Right side of status bar |
| OSC 52 clipboard | PASS | |
| Mouse scroll | PASS | Enters copy mode |
| Mouse selection | PASS | Copies to clipboard |
| Rectangular selection | PASS | Alt+click+drag outside, Shift+Alt inside tmux |
| Window drag reorder | FAIL | Minor — catppuccin interaction or 3.6a change |
| Cmd+Triple-Click | PASS outside / N/A inside | tmux consumes OSC 133 (architectural) |
| Prompt nav (outside tmux) | PASS | Cmd+Shift+Up/Down |
| Prompt nav (inside tmux) | PASS | Ctrl+Shift+Up/Down |
| Shell integration auto-load | PASS | `__ghostty_precmd` in `precmd_functions` |
| URL click | PASS | Shift+Cmd+Click |
| Resurrect save/restore | DEFERRED | Split brew/conda binary issue at time of test |
| Extended keys (CSI-u) | PARTIAL | Ctrl+Shift combos work; Ctrl+; and Ctrl+Enter don't |

## Remote (talapas, Linux, Ghostty SSH, tmux 3.6a)

| Test | Result | Notes |
|------|--------|-------|
| True color / RGB | PASS | |
| OSC 52 clipboard | PASS | Works through SSH + tmux back to local Ghostty |
| Vi yank (copy-mode) | PASS | |
| Multi-line paste | PASS | |
| Mouse scroll | PASS | |
| Mouse selection | PASS | |
| Rectangular selection | PASS | |
| URL click | PASS | Shift+Cmd+Click |
| Session name | PASS | |
| Resurrect save/restore | PASS | |
| Shift+Enter / Alt+Enter | DEFERRED | Will test with Claude Code later |
| Prompt nav (Ctrl+Shift+Up/Down) | FAIL (expected) | No Ghostty on remote, no shell integration, no OSC 133 |
| Window drag reorder | FAIL | Same as local |

## Known Limitations

- **Cmd+Triple-Click inside tmux** — Architectural. tmux consumes OSC 133 sequences.
- **Prompt nav on remote** — Ghostty shell integration not available (no `GHOSTTY_RESOURCES_DIR`).
- **Window drag reorder** — Fails on both local and remote. Low priority.
- **tmux 3.5a paste bug** — `extended-keys-format csi-u` causes garbage. Requires 3.6a.

## Go-Live Blockers

None. All critical functionality passes on both local and remote.
