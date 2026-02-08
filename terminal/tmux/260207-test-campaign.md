# Ghostty + tmux Test Campaign

## Setup

Start a test tmux session with the new config (use brew 3.6a, not conda 3.5a):

```bash
/opt/homebrew/bin/tmux -L test36 -f ~/C/devops/dotfiles/WK/feat/ghostty-shell-integration/terminal/tmux/tmux.conf new -s test-3.6a
```

Verify shell integration loaded automatically (should see `__ghostty_precmd`):

```bash
declare -p precmd_functions 2>/dev/null | grep ghostty
```

Then paste this block to generate testable output:

```bash
echo "--- command 1 ---"
ls -la
echo "--- command 2 ---"
date
echo "--- command 3 ---"
echo "https://example.com"
echo "--- command 4 ---"
echo "clipboard test: copy this text"
```

---

## Active Tests (iterating on these)

Nothing currently — all active issues resolved or confirmed architectural.

---

## Full Test Suite (checkpoint / go-live)

Run all of these when doing a full checkpoint or before going live.
Tested on 260207. tmux 3.6a via brew, Ghostty with shell integration.

### Keyboard Input

1. **Shift+Enter** — In Claude Code, press Shift+Enter. Inserts newline (not submit). **PASS (inside + outside tmux)**
2. **Alt/Opt+Enter** — In Claude Code, press Alt+Enter. Inserts newline (not submit). **PASS (inside + outside tmux)**
3. **Paste multi-line text** — Copy a multi-line block (e.g. from a file), paste into tmux. Lines should appear clean with no `[106;5u` garbage. **FAIL on tmux 3.5a / PASS on tmux 3.6a** (Note: Claude Code vim mode shows È/É bracketed paste markers — known Claude Code bug, not ours)

### Display

4. **True color / RGB** — Run: `awk 'BEGIN{ for(i=0;i<256;i++) printf "\033[48;2;%d;0;%dm \033[0m",i,255-i; print ""}'`. Smooth gradient, no banding. **PASS**
5. **Session name** — Check right side of status bar. Full name visible, not truncated. **PASS**

### Clipboard

6. **OSC 52 clipboard** — Enter copy mode (`Ctrl-A [`), select with `v`, yank with `y`, then Cmd+V in another app. Yanked text on system clipboard. **PASS**

### Mouse

7. **Mouse scroll (shell)** — Scroll up with trackpad/mouse wheel at a plain shell prompt. Enters copy mode, scrollback works. **PASS**
7b. **Mouse scroll (vim)** — Open vim/neovim, scroll with trackpad. Should scroll *inside vim* without entering tmux copy mode. Vim handles mouse natively via `mouse_any_flag`. See `terminal/tmux/mouse-scroll-integration---apps-inside-tmux.md`. **PASS**
8. **Mouse selection** — Click-drag to select text in a pane. Text selected, released to clipboard. **PASS**
9. **Rectangular selection** — Alt+click+drag outside tmux, Shift+Alt+click+drag inside tmux. Block/column selection. **PASS**
10. **Window drag reorder** — Drag a window tab on the status bar. Window reorders. **FAIL** (may be catppuccin interaction or 3.6a change, investigate later)

### Shell Integration (Ghostty-specific)

11. **Cmd+Triple-Click** — Run `ls -la`, Cmd+Triple-Click on output. Command output selected. **PASS outside tmux / NOT AVAILABLE inside (architectural — tmux consumes OSC 133)**
12. **Jump to prompt (outside tmux)** — Cmd+Shift+Up / Cmd+Shift+Down. Jumps between prompts. **PASS**
13. **Jump to prompt (inside tmux)** — Ctrl+Shift+Up / Ctrl+Shift+Down. Jumps between prompts. **PASS**
14. **Shell integration auto-loads** — Start new tmux session, check `declare -p precmd_functions | grep ghostty`. Should show `__ghostty_precmd` without manual sourcing. **PASS**
15. **URL click** — `echo "https://example.com"`, Shift+Cmd+Click on it inside tmux. Opens in browser. **PASS**

### Plugins

16. **tmux-resurrect save** — `Ctrl-A` then `Ctrl-S`. "Environment saved" message. **DEFERRED** (TPM can't load plugins in split-binary env: brew 3.6a server + conda 3.5a in PATH. Retest after switching to single brew install.)
17. **tmux-resurrect restore** — `Ctrl-A` then `Ctrl-R`. Sessions/windows restored. **DEFERRED** (same)
18. **resurrect nvim session** — Open nvim, save resurrect, kill, restore. nvim session restored. **DEFERRED** (same)

### Extended Keys

19. **CSI-u / extended keys** — **PARTIAL PASS**. Ctrl+Shift+P is distinct from Ctrl+P in nvim (pass). Ctrl+Shift+Up/Down works for tmux prompt nav (pass). But Ctrl+; and Ctrl+Enter send plain unmodified keys in `cat -v` (fail). May be Ghostty limitation or need config tweak. Low priority unless specific use case needs it.

---

## Known Limitations

- **Cmd+Triple-Click inside tmux** — Not possible. tmux consumes OSC 133 sequences for its own prompt tracking. Ghostty never sees them. This is architectural, not a bug.
- **tmux 3.5a paste bug** — `extended-keys-format csi-u` causes `[106;5u` garbage on paste. Fixed in tmux 3.6a.
- **Requires tmux 3.6a** — Install via `brew install tmux`. Conda has 3.5a which has the paste bug.

## Requirements for Go-Live

- [ ] Upgrade production tmux from conda 3.5a to brew 3.6a
- [ ] Run full test suite above with all items passing
- [ ] Test resurrect save/restore cycle
