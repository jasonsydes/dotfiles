# Stash away or delete existing configs.
# Either see:
#   ~/.dotfiles/nvim/scripts
#   ~/.dotfiles/lvim/scripts
# or just rename them manually:
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
    mv ~/.cache/nvim ~/.cache/nvim.bak

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
