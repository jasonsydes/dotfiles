# Mouse Scroll Integration — Apps Inside tmux

## How tmux decides who handles scroll

The tmux config checks `mouse_any_flag` on scroll:

```
if-shell -F "#{mouse_any_flag}" "send-keys -M" \
    "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
```

- **App sets `mouse_any_flag`:** tmux forwards scroll to the app (app scrolls natively)
- **App does NOT set the flag:** tmux intercepts scroll and enters copy mode

## App status

| App | Works natively? | Scroll behavior | Fix |
|-----|----------------|----------------|-----|
| vim/neovim | Yes | Scrolls inside vim | None needed — sets `mouse_any_flag` |
| less | No | Enters tmux copy mode | `export LESS="--mouse"` |
| bat | No | Enters tmux copy mode | Uses less internally — same LESS env var fix |
| plain shell | N/A | Enters tmux copy mode | Expected — no app to handle it |

## Configuring apps

### less

Enable mouse support so less handles scroll instead of tmux:

```bash
export LESS="--mouse"
```

Add to your shell profile. This also fixes `bat`, `git log`, `man`, and
anything else that uses less as a pager.

### bat

bat uses less internally. The `LESS="--mouse"` fix above covers it.
Alternatively: `export BAT_PAGER="less --mouse"`.

### vim/neovim

Works out of the box when `set mouse=a` is in your vim config (which is
the default in neovim). No action needed.

These are shell alias / env var tweaks, not tmux config changes.
