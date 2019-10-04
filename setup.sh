#!/usr/bin/env bash

cd $HOME

# bash
ln -s .dotfiles/vim/bash_profile ~/.bash_profile
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

# Setup neovim
mkdir -p ~/.config
cd !$
ln -s ../.dotfiles/nvim

# Not sure what I'm doing here anymore....
# Ok!  Some Karabiner-Elements remapping of keys.
#   Inspired by https://stackoverflow.com/a/28526956 (which points to an older now/defunct version of Karabiner).
#       That post suggests (roughly) the following (Karabiner can now handle all changes:
#           Use Karabiner to:
#               Send Esc when you type Control by itself.
#                   You need to import from their web page the following:
#                       "Post escape if left_control is pressed alone."
#               Send Esc when you press Caps Lock alone:
#                   Import the following from webpage:
#                       "Change caps_lock to control if pressed with other keys, to escape if pressed alone."
#
# I might also love:
#       CAPS LOCK + hjkl to arrow keys
#
# Looks like you can't choose everything.  I think they following two conflict (it choose one, but not both):
#       CAPS LOCK + hjkl to arrow keys
#       Change caps_lock to control if pressed with other keys, to escape if pressed alone.
# Still, I got LOTS of options!
# Karabiner ROCKS.
#
# Woah: https://github.com/jasonrudolph/keyboard
