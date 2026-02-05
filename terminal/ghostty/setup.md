# DO NOT RUN OR EXECUTE THIS FILE!
# Rough notes on ghostty setup.

## Local config symlink
mkdir -p ~/.config/ghostty
ln -s ~/.dotfiles/terminal/ghostty/config ~/.config/ghostty/config

## Remote terminfo setup
# Ghostty sets TERM=xterm-ghostty, which remotes don't recognize.
# You'll get "can't find terminfo database" from tmux, vim, etc.
# Fix: copy terminfo to each remote.

# From local:
infocmp -x > /tmp/ghostty.terminfo
scp /tmp/ghostty.terminfo REMOTE:/tmp/

# Then ssh in and run directly (piped one-liners silently fail):
ssh REMOTE
tic -x /tmp/ghostty.terminfo -o ~/.terminfo/
# Creates ~/.terminfo/x/xterm-ghostty (and g/ghostty symlink)
# Existing tmux sessions don't need to be restarted.

# Done for: lr (longreads), l4 (talapas login4)

# Note: talapas also needs TERMINFO set in .bashrc:
#   export TERMINFO=$HOME/.terminfo
# Without this, readline can't find the terminfo (broken backspace,
# arrow keys, etc). Talapas compiles to 78/ (hex) instead of x/.
