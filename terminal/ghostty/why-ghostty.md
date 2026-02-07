# Why Ghostty

Features I like about Ghostty (switched from iTerm2, Feb 2026).

## Cmd+Triple-Click: Select Command Output

Cmd+Triple-Click on any line of a command's **output** to select the entire
output block. Great for copying multi-line results without grabbing the prompt
or neighboring commands. Requires shell integration (automatic for bash/zsh/fish).
Docs: https://ghostty.org/docs/features/shell-integration

## Opt/Alt+Click+Drag: Rectangular Selection

Hold Opt (Alt) while clicking and dragging to select a rectangular region
instead of line-by-line. Useful for grabbing a single column from tabular output.

## Shift+Double-Click: Trimmed Selection

Double-click with Shift held to select text excluding leading/trailing
whitespace. Particularly nice with Claude Code, which indents most of its
responses by two spaces.

## Ctrl+Shift+Up/Down: Jump to Prompt

Jump between prompts without scrolling. Ctrl+Shift+Up goes to the previous
prompt, Ctrl+Shift+Down to the next. Uses the `jump_to_prompt` action powered
by shell integration's prompt marking.
Docs: https://ghostty.org/docs/features/shell-integration

## GPU-Accelerated Rendering

Native GPU rendering via Metal (macOS). In theory faster and smoother than
CPU-rendered terminals, though the difference is hard to notice in practice.
Docs: https://ghostty.org/docs/features/graphics

## Plays Well with tmux

Ghostty's `terminal-features` config lets tmux know about RGB color and
extended key support. The `xterm-ghostty` terminfo entry is purpose-built
for correct behavior inside and outside tmux.

The `ssh-terminfo` shell integration feature auto-installs the xterm-ghostty
terminfo on remote hosts (needs testing — discovered after setting up a manual
approach, but appears to be working).

The `ssh-env` feature propagates env vars (TERM_PROGRAM, COLORTERM, etc.) to
remote hosts, but most servers won't accept them — `sshd_config` requires
explicit `AcceptEnv` directives for each variable, and the default is to accept
none (only TERM is always accepted per the SSH protocol).
Docs: https://ghostty.org/docs/features/shell-integration

## Known Quirks

- **No Cmd+F search** (yet): Coming in Ghostty 1.3 (March 2026). Workaround:
  use tmux copy mode (`Ctrl-A [` then `/` to search).
  Tracking: https://github.com/ghostty-org/ghostty/discussions/3656
- **Cmd+Triple-Click on command input zones** (not output) behaves oddly when
  starship prompt is active — selects too much. Not a real issue since the
  intended use is clicking on command *output*. Low priority.
