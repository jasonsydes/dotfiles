#!/bin/sh

# Dynamic loading of plugins:
# 	source <(antibody init)
#	antibody bundle < ~/.zsh_plugins.txt
# Static loading of plugins
# 	antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
# 	source ~/.zsh_plugins.sh

antibody bundle < "$DOTFILES/antibody/bundles.txt" > ~/.zsh_plugins.sh
antibody update
