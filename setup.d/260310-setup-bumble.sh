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
# Then I made a bunch of symlinks into ~/.dotfiles/.

# Rough notes below.
# Likely incredibly incomplete.

# ============================================================================
# 260310 - Setup log for "bumble" (N100, Ubuntu 24.04 Server)
#
# Based on setup.sh. Changes:
#   - conda/mamba → DISABLED (experimenting with pixi-only)
#   - homebrew → DISABLED (not applicable on Ubuntu; CLI tools via pixi)
#   - Mac-only sections → DISABLED
#   - pixi replaces both conda and brew for package management
# ============================================================================

## SETUP ##

## If on Mac, first, default to bash shell
# DISABLED (Mac-only) - Ubuntu 24.04 ships bash 5.2, pixi will provide latest
# chsh -s /bin/bash
# Close that terminal and open a new one.
# Update 260205 - MacOS bash is from 2007! Switch to another shell, or use homebrew bash (latest from 2025). See homebrew section below.

## Install pixi (replaces conda/mamba and homebrew for CLI tools)
curl -fsSL https://pixi.sh/install.sh | bash
# Close terminal, open new one (so ~/.pixi/bin is on PATH).

## Install mamba/conda before anything else.
# DISABLED (260310) - Replaced by pixi. Experimenting with fully removing conda/mamba.
#     Accept the defaults for all the questions, which also means "no" to the following question:
#     Do you wish to update your shell profile to automatically initialize conda?
#     (Answering no is fine; our dotfiles handles it.
# curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# bash Miniforge3-$(uname)-$(uname -m).sh
# Close terminal, open new one.

## More setup stuff.

cd $HOME
mkdir ~/.config

## Grab the .dotfiles repo:
git clone https://github.com/jasonsydes/dotfiles ~/.dotfiles

## initial symlinks
cd $HOME
ln -s ~/.dotfiles/bash/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/bash/bashrc ~/.bashrc
ln -s ~/.dotfiles/inputrc ~/.inputrc
ln -s ~/.dotfiles/terminal/tmux/tmux.conf ~/.tmux.conf
# DISABLED (260310) - No conda, no condarc needed
# ln -s ~/.dotfiles/conda/condarc ~/.condarc
ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

TODO: starship.toml not in ~/.dotfiles??


## Conda Installs

# DISABLED (260310) - Replaced by pixi global installs below.
# Always use conda for neovim and tmux
#  NOTE: Aliases are added to ensure availablity when leaving 'base' environment.
#  NOTE: See: ~/.dotfiles/nvim-common/aliases ~/.dotfiles/terminal/tmux/aliases
# mamba activate base
# mamba install nvim tmux vim

## Pixi global installs (replaces conda installs above)
# NOTE (260311): pixi's tmux is broken on Linux — static trampoline binary uses
# hex-encoded terminfo paths (78/ instead of x/), and even after fixing that,
# the server crashes. Use system tmux instead: sudo apt install tmux
pixi global install neovim vim
sudo apt install tmux

## Insteall homebrew
# DISABLED (260310) - Not applicable on Ubuntu. CLI tools installed via pixi.
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# No need to do the "Next steps", because that's already in:
#    ~/.dotfiles/host_laptop/misc
#    ~/.dotfiles/homebrew/setup
# Close terminal, open new one.


## Brew Installs


# DISABLED (Mac-only) - Ubuntu 24.04 already has bash 5.2
# Update 260205 - MacOS bash is from 2007! Switch to another shell, or use homebrew bash (latest from 2025).
# install, allow, change shell to homebrew bash.
# brew install bash
# sudo sh -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
# chsh -s /opt/homebrew/bin/bash

## Pixi global installs (replaces brew installs above)
pixi global install bash

## Brew Install some basics (partially to make sure brew works)
# DISABLED (260310) - Replaced by pixi.
# brew install wget
# brew install starship
pixi global install wget starship

# To enable flock with safe bash_history appending. (built-in on linux)
# brew install flock
# SKIPPED - flock is built-in on Linux

# GitHub CLI — repo creation, PRs, issues from the command line
# brew install gh
pixi global install gh

# MacFUSE is useful, but requires reboot(s) to activate. Install on setup, then TEST to ensure working. Requires reboots.
# The first commented out command will tell you to use the second uncommented command.
# DISABLED (Mac-only)
# brew install macfuse
# brew install --cask macfuse

## Brew Install some bigger stuff - ACTUALLY, let's start using conda again (see ~/.dotfiles/nvim-common/aliases ~/.dotfiles/terminal/tmux/aliases)
### DISABLED - brew install neovim tmux

## Brew Install some great tools
#      QUESTION FOR FUTURE:
#      Do we want to start using conda everywhere again for these softwares, and just add aliases?
#      (Like we are trying for tmux and nvim?)
# brew install ast-grep fd fzf ripgrep npm go wget lazygit choose-rust dust tree procs bat
pixi global install ast-grep fd fzf ripgrep npm go wget lazygit dust tree procs bat
# NOTE: choose-rust may not be available on conda-forge — check and install via cargo if needed

# Trying out git-delta and difftastic (see changes to ~/.dotfiles/git/, to start with)
# brew install git-delta difftastic
pixi global install git-delta difftastic

## Install cargo
curl https://sh.rustup.rs -sSf | sh
# So that the installed doesn't make a mess, choose the following:
#     2) Customize installation
#     Select defaults, except say "NO" to "Modify PATH variable?"
# (All the modified stuff is already in ~/.dotfiles/all/main-non-interactive)

## Install kanata and friends.
# DISABLED (Mac-only) - For Linux, kanata install is different. See kanata GitHub releases.
# brew install kanata
#     For Mac this is not the easiest / documentation isn't exactly the best.
#     Wrote a note about it here;
#     https://github.com/jtroo/kanata/issues/1264#issuecomment-2763085239
#     See .dotfiles/kanata/setup-kanata.txt

## Install kickstart vim
# Confirm NOTHING exists at ~/.config/nvim first:
ls -ald ~/.config/nvim
# See also: ~/.dotfiles/nvim/scripts/*.sh
git clone https://github.com/jasonsydes/kickstart.nvim ~/.config/nvim
# Start nvim, give it a minute or so to install stuff.
nvim
# Quit, restart.
# Optionally, do this to make sure your plugin versions are identical across machines:
:Lazy restore
# Store existing config, if needed:
~/.dotfiles/nvim/scripts/store-existing-nvim-config.sh kickstart-251102

## Setup

# tmux + tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Run tmux and install/update tmux plubins
tmux
# Inside of tmux:
    # install plugins
    <prefix> + I
    # update plugins
    <prefix> + U
    type 'all'

# Install nerd fonts
See .dotfiles/nerd-fonts/
