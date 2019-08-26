#!/usr/bin/env bash

cd $HOME

# vim
ln -s .dotfiles/vim/vimrc ~/.vimrc
# tmux + tmux plugin manager
ln -s .dotfiles/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Alacritty teriminal
ln -s .dotfiles/terminal/alacritty.yml ~/.alacritty.yml
# inputrc
ln -s .dotfiles/inputrc ~/.inputrc
