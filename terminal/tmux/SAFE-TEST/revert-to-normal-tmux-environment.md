# Revert to normal tmux environment

Undoes `setup-test-tmux-environment.md`. Copy/paste into shell:

```
# Kill test server if still running
tmux -L test kill-server 2>/dev/null

# Restore dotfiles symlink
ln -sfn ~/C/devops/dotfiles/hub ~/.dotfiles

# Remove test tmux.conf symlink
rm -f ~/.tmux.conf

# Restore plugins
rm -rf ~/.tmux/plugins
mv ~/.tmux/plugins.SAFE-TEST-BAK ~/.tmux/plugins
```
