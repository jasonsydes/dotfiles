------ Overview of the workflow to get things setup with Neovim and AstroNvim ------

# Install Neovim.
# Disable existing AstroNvim install (if exists)
~/.dotfiles/nvim/scripts/disable-nvim-config.sh
# Install AstroNvim (see below).
# Start nvim (AstroNvim will launch a bunch of installs, let them finish).
# Probably do other initial plugin/tree-sitter/etc installs (:LspInstall pyright, :TSInstall python, etc)
# Quit AstroNvim.
# "Store" (i.e., name) the newly (just now) created nvim/AstroNvim install&config:
~/.dotfiles/nvim/scripts/store-existing-nvim-config.sh my-fancy-astronvim-v3
# The above command rearranges things to look like this (the following represent symlinks):
        ~/.cache/nvim/       -> ~/.cache/nvim--my-fancy-astronvim-v3/
        ~/.config/nvim/      -> ~/.config/nvim--my-fancy-astronvim-v3/
        ~/.local/share/nvim/ -> ~/.local/share/nvim--my-fancy-astronvim-v3/
        ~/.local/state/nvim/ -> ~/.local/state/nvim--my-fancy-astronvim-v3/

------------------------------------------------------------------------------------

# Install neovim (MacOS version shown)
cd ~/src/
rm -f nvim
wget https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz
mv nvim-macos nvim-macos-v0.9.4
ln -s nvim-macos-v0.9.4 nvim

# Disable existing AstroNvim install (if exists)
~/.dotfiles/nvim/scripts/disable-nvim-config.sh

 
# Install AstroNvim
#       (roughly based off of this guide: https://docs.astronvim.com/#%EF%B8%8F-installation)
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Start nvim
nvim
# It will install a bunch of stuff. Maybe some errors. 
# Stop and restart nvim.

# Open Mason and install stuff.
<leader>pm
I installed pyright.

# Install tree-sitter for things
:TSInstall python

# Quit nvim.

# "Store" (i.e., name) the newly (just now) created nvim/AstroNvim install&config:
~/.dotfiles/nvim/scripts/store-existing-nvim-config.sh my-fancy-astronvim-v3

# Setup custom user configuration.
# The template for this originally came from https://github.com/AstroNvim/user_example
# But now it is stored here: ~/.dotfiles/astronvim-v3 
# Set it up by creating a single symlink:
cd ~/.config/nvim/lua/
ln -s ~/.dotfiles/astronvim-v3 user

# Start nvim.















###############
#### OLDER ####
###############

# Stash away or delete existing configs.
# More info here:
#   ~/.dotfiles/nvim/scripts
# In short, the workflow will look like this:
    # Install Neovim.
    # Disable existing AstroNvim install (if exists)
    ~/.dotfiles/nvim/scripts/disable-nvim-config.sh
    # Install AstroNvim (see below).
    # Start nvim (AstroNvim will launch a bunch of installs, let them finish).
    # Probably do other initial plugin/tree-sitter/etc installs (:LspInstall pyright, :TSInstall python, etc)
    # Quit AstroNvim.
    # "Store" (i.e., name) the newly (just now) created nvim/AstroNvim install&config:
    ~/.dotfiles/nvim/scripts/store-existing-nvim-config.sh my-fancy-astronvim-v3
    # The above command rearranges things to look like this (the following represent symlinks):
            ~/.cache/nvim/       -> ~/.cache/nvim--my-fancy-astronvim-v3/
            ~/.config/nvim/      -> ~/.config/nvim--my-fancy-astronvim-v3/
            ~/.local/share/nvim/ -> ~/.local/share/nvim--my-fancy-astronvim-v3/
            ~/.local/state/nvim/ -> ~/.local/state/nvim--my-fancy-astronvim-v3/
# Or just rename them manually:
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
    mv ~/.cache/nvim ~/.cache/nvim.bak
# Delete 

# Download AstroNVim initial config:
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Install single file init.lua jason-specific configs.
# No longer used (single file config method): # # Setup your "customizations" config:
# No longer used (single file config method): # cd ~/.config/nvim/lua
# No longer used (single file config method): # ln -s ~/.dotfiles/astronvim/user_customizations user

# Install multiple file jason-specific configs.
mkdir -p ~/.config/astronvim/lua/
cd ~/.config/astronvim/lua/
ln -s ~/.dotfiles/astronvim user


########
# Info #
########

# I'm using the multiple file configuration approach.

# Examples (originally listed here: https://astronvim.github.io/Recipes/black_belt)
https://code.mehalter.com/AstroNvim_user
https://github.com/kabinspace/AstroNvim_user
https://github.com/datamonsterr/astronvim_config
https://github.com/hunger/AstroVim/tree/my_config/lua/user
https://github.com/thieung/dotfiles/tree/main/config/nvim

# AstroNvim mutliple file config approach described here.
https://astronvim.github.io/configuration/splitting_up
# AstroNvim configuration mechanism explained.
https://astronvim.github.io/Configuration/config_mechanism
