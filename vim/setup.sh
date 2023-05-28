# --- vim version ---

# After installing your dotfiles, you need to initialize vim plugins, like so:
# (per https://github.com/junegunn/vim-plug)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Then, launch vim, and run:
:PlugInstall
# Quit vim, and you're good to go.

# Note that nvim (neovim) has a different setup.
# See ~/.dotfiles/nvim/setup.sh
