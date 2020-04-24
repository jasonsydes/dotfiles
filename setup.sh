# DO NOT RUN OR EXECUTE THIS FILE!
# DO NOT RUN OR EXECUTE THIS FILE!
# DO NOT RUN OR EXECUTE THIS FILE!
#
# If you run it, it'll probably break things for you.
#
# This file is just my rough notes on how I setup my dotfiles from this repository.
# In short, I effectively did this:
        cd $HOME
        git clone https://github.com/jasonsydes/dotfiles .dotfiles
# Then I made a bunch of symlinks into ~/.dotfiles/, like so:
        cd $HOME
        ln -s .dotfiles/bash/bash_profile .bash_profile
        ln -s .dotfiles/bash/bashrc .bashrc
        ln -s .dotfiles/vim/vimrc .vimrc

# Rough notes below.
# Likely incredibly incomplete.

cd $HOME

# bash
ln -s .dotfiles/bash/bash_profile ~/.bash_profile
ln -s .dotfiles/bash/bashrc ~/.bashrc
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

# Currently (Apr 2020) my symlinks look like this:

.bash_profile -> .dotfiles/bash/bash_profile
.bashrc -> .dotfiles/bash/bashrc
.nvimrc -> .vimrc
.tmux.conf -> .dotfiles/tmux/tmux.conf
.vimrc -> .dotfiles/vim/vimrc
