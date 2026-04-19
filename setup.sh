# DO NOT RUN OR EXECUTE THIS FILE!
# DO NOT RUN OR EXECUTE THIS FILE!
# DO NOT RUN OR EXECUTE THIS FILE!
#
# If you run it, it'll probably break things for you.
#
# This file is just my rough notes on how I setup my dotfiles from this repository.
# In short, I effectively did this:
# cd $HOME
# git clone https://github.com/jasonsydes/dotfiles .dotfiles
# Then I made a bunch of symlinks into ~/.dotfiles/.

# Rough notes below.
# Likely incredibly incomplete.

# ── Preliminaries ─────────────────────────────────────────────────────────────────────────

# Make ~/.config
cd $HOME
mkdir ~/.config

## If on Mac, first, default to bash shell
chsh -s /bin/bash
# Close that terminal and open a new one.
# Update 260205 - MacOS bash is from 2007! Below, we switch to a newer (2025+) version of Bash (via pixi or homebrew) .

# ── Install Pixi and Homebrew ───────────────────────────────────────────────────────────

# UPDATE 260416
# We're using pixi everywhere now. Where possible, we're using pixi to replace both mamba *and* homebrew. 
# For now, continue to INSTALL homebrew, even if you don't use it much.
# (Probably will just stop installing mamba entirely???)

# ── Pixi (package manager — install first) ──────────────────────────────────────────────

# Pixi replaces brew/conda for most CLI tool installs. Works cross-platform.
# https://pixi.sh
# OPTIONAL: Install without updating PATH in ~/.bashrc
export PIXI_NO_PATH_UPDATE=1
curl -fsSL https://pixi.sh/install.sh | bash
# POSSIBLY NOT NEEDED? - Close terminal, open new one (pixi adds itself to PATH).

## Install homebrew
# We only use this for a few things (kanata, backup of newer version of Bash, 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# No need to do the "Next steps", because that's already in:
#    ~/.dotfiles/host_laptop/misc
#    ~/.dotfiles/homebrew/setup
# Close terminal, open new one.

# ── Clone and setup .dotifiles ───────────────────────────────────────────────────────────

## Grab the .dotfiles repo:
git clone https://github.com/jasonsydes/dotfiles ~/.dotfiles

## initial symlinks
cd $HOME
ln -s ~/.dotfiles/bash/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/bash/bashrc ~/.bashrc
ln -s ~/.dotfiles/inputrc ~/.inputrc
ln -s ~/.dotfiles/terminal/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/conda/condarc ~/.condarc
ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

TODO: starship.toml not in ~/.dotfiles??

# Currently my symlinks look like this:
cd ~
.dotfiles     -> ~/C/devops/dotfiles/hub
.bash_profile -> .dotfiles/bash/bash_profile
.bashrc       -> .dotfiles/bash/bashrc
.condarc      -> .dotfiles/conda/condarc
.gitconfig    -> .dotfiles/git/.gitconfig
.inputrc      -> .dotfiles/inputrc
.tmux.conf    -> .dotfiles/terminal/tmux/tmux.conf

Possibly restart shell now.

# ── Bash ───────────────────────────────────────────────────────────────────────────
#
# macOS ships bash 3.2 (2007) — Apple won't update past GPLv2.
# Linux distros ship modern bash but version varies.
# Pixi provides a consistent modern bash across all platforms.
#
# Versions as of 260415:
#   macOS built-in:  3.2.57  (ancient, missing associative arrays, etc.)
#   pixi:            5.2.37
#   brew:            5.3.9
#   Differences between 5.2 and 5.3 not yet evaluated.
#
# Strategy: pixi bash as login shell everywhere.
# On Mac, optionally keep brew bash installed as fallback.

## All platforms
pixi global install bash
sudo sh -c "echo $HOME/.pixi/bin/bash >> /etc/shells"
chsh -s "$HOME/.pixi/bin/bash"

## Mac-only (optional fallback)
brew install bash
sudo sh -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
# Don't chsh to brew bash — pixi is the primary.

## bash-preexec — required by bashrc (starship + atuin + ghostty shell integration)
# Provides precmd/preexec hook arrays so starship, atuin, and ghostty can all
# register PROMPT_COMMAND hooks without stomping on each other.
# See: https://github.com/rcaloras/bash-preexec
curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh

# ── HomeBrew (brew) Installs ────────────────────────────────────────────────────

# Right now, homebrew for just macfuse and kanata?

# MacFUSE is useful, but requires reboot(s) to activate. Install on setup, then TEST to ensure working. Requires reboots.
# The first commented out command will tell you to use the second uncommented command.
# brew install macfuse
brew install --cask macfuse

## Install kanata and friends.
brew install kanata
#     For Mac this is not the easiest / documentation isn't exactly the best.
#     Wrote a note about it here;
#     https://github.com/jtroo/kanata/issues/1264#issuecomment-2763085239
#     See .dotfiles/kanata/setup-kanata.txt

# ── Pixi Installs ────────────────────────────────────────────────────────

# TMUX and neovim
pixi global install nvim tmux vim

## pixi global install some basics
pixi global install wget starship

# To enable flock with safe bash_history appending. (built-in on linux)
pixi global install flock

# GitHub CLI — repo creation, PRs, issues from the command line
pixi global install gh

# Some nice tools
pixi global install ast-grep fd fzf ripgrep npm go wget lazygit choose-rust dust tree procs bat
# Trying out git-delta and difftastic (see changes to ~/.dotfiles/git/, to start with)
pixi global install git-delta difftastic

# ── Cargo - Do we still need this? ────────────────────────────────────────────────────────

## Install cargo
curl https://sh.rustup.rs -sSf | sh
# So that the installed doesn't make a mess, choose the following:
#     2) Customize installation
#     Select defaults, except say "NO" to "Modify PATH variable?"
# (All the modified stuff is already in ~/.dotfiles/all/main-non-interactive)


# ── Kickstart vim, install & setup ──────────────────────────────────────────────────

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

# ── tmux setup ──────────────────────────────────────────────────────────────────────

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

# ── mamba (conda) install ────────────────────────────────────────────────────────

# Install mamba/conda last??? Or not at all??
### #     Accept the defaults for all the questions, which also means "no" to the following question:
### #     Do you wish to update your shell profile to automatically initialize conda?
### #     (Answering no is fine; our dotfiles handles it.
### curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
### bash Miniforge3-$(uname)-$(uname -m).sh
### # Close terminal, open new one.


# ── Older stuff below ──────────────────────────────────────────────────────────────────────
# ── Older stuff below ──────────────────────────────────────────────────────────────────────
# ── Older stuff below ──────────────────────────────────────────────────────────────────────

---
Apr 2025 Lazyvim install:

            Installed (31)
              ○ blink.cmp  InsertEnter
              ● bufferline.nvim 3.25ms  VeryLazy     ■ already up to date
              ○ catppuccin      ■ already up to date
              ○ conform.nvim  <leader>cF  <leader>cF (v)  ConformInfo      ■ already up
              ● flash.nvim 1.37ms  VeryLazy     ■ already up to date
              ○ friendly-snippets  blink.cmp      ■ already up to date
              ○ gitsigns.nvim  LazyFile      ■ already up to date
              ○ grug-far.nvim  <leader>sr  <leader>sr (v)  GrugFar      ■ already up to
              ○ lazydev.nvim  lua  LazyDev      ■ already up to date
              ● LazyVim 4.15ms  start     ■ already up to date
              ● lualine.nvim 17.49ms  VeryLazy     ■ already up to date
              ○ mason-lspconfig.nvim  nvim-lspconfig      ■ already up to date
              ● mason.nvim 8.92ms ✔ build     ■ already up to date
              ● mini.ai 1.11ms  VeryLazy     ■ already up to date
              ○ mini.icons      ■ already up to date
              ● mini.pairs 1.31ms  VeryLazy     ■ already up to date
              ● noice.nvim 1.16ms  VeryLazy     ■ already up to date
              ● nui.nvim 0.06ms 󰢱 nui.object  noice.nvim     ■ already up to date
              ○ nvim-lint  LazyFile      ■ already up to date
              ○ nvim-lspconfig  LazyFile      ■ already up to date
              ● nvim-treesitter 314.63ms ✔ build     ■ already up to date
              ● nvim-treesitter-textobjects 2.42ms  VeryLazy     ■ already up to date
              ○ nvim-ts-autotag  LazyFile      ■ already up to date
              ○ persistence.nvim  <leader>ql  <leader>qd  <leader>qs  <leader>qS 
              BufReadPre      ■ already up to date
              ○ plenary.nvim      ■ already up to date
              ● snacks.nvim 1.15ms  start     ■ already up to date
              ○ todo-comments.nvim  [t  <leader>sT  <leader>xt  <leader>xT 
              <leader>st  ]t  LazyFile  TodoTelescope  TodoTrouble      ■ already up t
              ● tokyonight.nvim 0.39ms 󰢱 tokyonight  LazyVim     ■ already up to date
              ● trouble.nvim 1.88ms 󰢱 trouble  lualine.nvim     ■ already up to date
              ● ts-comments.nvim 1.5ms  VeryLazy     ■ already up to date
              ● which-key.nvim 1.04ms  VeryLazy     ■ already up to date
