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

## SETUP ##

## If on Mac, first, default to bash shell
chsh -s /bin/bash
# Close that terminal and open a new one.

## Install mamba/conda before anything else.
#     Accept the defaults for all the questions, which also means "no" to the following question:
#     Do you wish to update your shell profile to automatically initialize conda?
#     (Answering no is fine; our dotfiles handles it.
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
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
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/conda/condarc ~/.condarc
ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

TODO: starship.toml not in ~/.dotfiles??

## Insteall homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# No need to do the "Next steps", because that's already in:
#    ~/.dotfiles/host_laptop/misc
#    ~/.dotfiles/homebrew/setup
# Close terminal, open new one.

## Brew Installs

## Brew Install some basics (partially to make sure brew works)
brew install wget
brew install starship

## Brew Install some bigger stuff
brew install neovim tmux

## Brew Install some great tools
brew install ast-grep fd fzf ripgrep npm go wget lazygit

## Install cargo
curl https://sh.rustup.rs -sSf | sh
# So that the installed doesn't make a mess, choose the following:
#     2) Customize installation
#     Select defaults, except say "NO" to "Modify PATH variable?"
# (All the modified stuff is already in ~/.dotfiles/all/main-non-interactive)

## Install kanata and friends.
brew install kanata
#     For Mac this is not the easiest / documentation isn't exactly the best.
#     Wrote a note about it here;
#     https://github.com/jtroo/kanata/issues/1264#issuecomment-2763085239
#     See .dotfiles/kanata/setup-kanata.txt

## "Install" Lazy.vim
# NEWER (doesn't exist yet):
git clone https://github.com/jasonsydes/lazyvim-config ~/.config/nvim
nvim    # Be patient, takes a minute.
# OLDER:
    # see https://www.lazyvim.org/installation, but currently:
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    nvim    # Be patient, takes a minute.

## Setup

# tmux + tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install nerd fonts
See .dotfiles/nerd-fonts/

--
Older below
--

## Alacritty teriminal
ln -s .dotfiles/terminal/alacritty.yml ~/.alacritty.yml

# Currently my symlinks look like this:

.bash_profile - >.dotfiles/bash/bash_profile
.bashrc - >.dotfiles/bash/bashrc
.inputrc - >/Users/sydes/.dotfiles/inputrc
.tmux.conf - >.dotfiles/tmux/tmux.conf


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





