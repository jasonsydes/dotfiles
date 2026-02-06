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
extended key support. The `ssh-env` and `ssh-terminfo` shell integration
features propagate terminal info to remote hosts. The `xterm-ghostty` terminfo
entry is purpose-built for correct behavior inside and outside tmux.
