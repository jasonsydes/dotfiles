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

mkdir ~/.config

## initial symlinks
ln -s .dotfiles/bash/bash_profile .bash_profile 
ln -s .dotfiles/bash/bashrc .bashrc
ln -s .dotfiles/inputrc .inputrc
ln -s .dotfiles/tmux/tmux.conf .tmux.conf

## miniforge > mambaforge >> conda
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh
# Then
vim ~/.bashrc ~/.dotfiles/conda/setup
# and comment out or delete the auto-generated conda stuff from the bottom of ~/.bashrc, moving it over
# to ~/.dotfiles/conda/setup into the appropriate area if necessary.
# Finally:
ln -s .dotfiles/conda/condarc .condarc

## Starship prompt
# Just download a raw binary from https://github.com/starship/starship/releases, and install it in ~/bin/ 
ln -s ~/.dotfiles/starship/starship.toml .config/starship.toml

## vim & tmux
mamba install vim tmux
# neovim
See ~/.dotfiles/astronvim-v3/README.setup.txt
# tmux + tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## Alacritty teriminal
ln -s .dotfiles/terminal/alacritty.yml ~/.alacritty.yml

# Currently my symlinks look like this:

.bash_profile -> .dotfiles/bash/bash_profile
.bashrc -> .dotfiles/bash/bashrc
.inputrc -> /Users/sydes/.dotfiles/inputrc
.tmux.conf -> .dotfiles/tmux/tmux.conf
