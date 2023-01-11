# Get a Neovim release (or build it yourself).
# But whatever you do, do NOT move the nvim executable out of 
# installation folder (see my "bug" report here: https://github.com/LunarVim/LunarVim/issues/3705)
wget https://github.com/neovim/neovim/releases/
cd ~/src
wget https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz
tar xf nvim-macos.tar.gz
# make a symlink (for setting PATH only once, in a moment)
ln -s nvim-macos nvim
# Update $PATH so that it points at nvim bin folder (added something like this to ~/.dotfiles/bash/path)
export PATH=$HOME/src/nvim/bin:$PATH

# Then, perform the LunarVim setup here: ~/.dotfiles/lvim/setup.sh
# Also perform the "common" setup here: ~/.dotfiles/nvim-lvim-common/setup.sh
