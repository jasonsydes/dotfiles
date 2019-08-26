#!/usr/bin/env bash

cd $HOME

# bash
ln -s .dotfiles/vim/bash_profile ~/.base_profile
ln -s .dotfiles/vim/bashrc ~/.bashrc
# vim
ln -s .dotfiles/vim/vimrc ~/.vimrc
# tmux + tmux plugin manager
ln -s .dotfiles/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Alacritty teriminal
ln -s .dotfiles/terminal/alacritty.yml ~/.alacritty.yml
# inputrc
ln -s .dotfiles/inputrc ~/.inputrc
