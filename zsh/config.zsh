#!/bin/zsh
export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

fpath=($DOTFILES/functions $fpath)

autoload -U "$DOTFILES"/functions/*(:t)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

HISTFILE=~/.zsh_history
HISTSIZE=10000000000
SAVEHIST=10000000000

# don't nice background tasks
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_BEEP
# allow functions to have local options
setopt LOCAL_OPTIONS
# allow functions to have local traps
setopt LOCAL_TRAPS
# share history between sessions ???
setopt SHARE_HISTORY
# add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
# adds history
setopt APPEND_HISTORY
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
# dont ask for confirmation in rm globs*
setopt RM_STAR_SILENT

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# emacs mode
# I always enter vi mode by mistake
bindkey -e

# Helpful Definitions
#     On ubuntu:
#     /etc/zsh/zshrc
#         typeset -A key
#         key=(
#             BackSpace  "${terminfo[kbs]}"
#             Home       "${terminfo[khome]}"
#             End        "${terminfo[kend]}"
#             Insert     "${terminfo[kich1]}"
#             Delete     "${terminfo[kdch1]}"
#             Up         "${terminfo[kcuu1]}"
#             Down       "${terminfo[kcud1]}"
#             Left       "${terminfo[kcub1]}"
#             Right      "${terminfo[kcuf1]}"
#             PageUp     "${terminfo[kpp]}"
#             PageDown   "${terminfo[knp]}"
#         )

# fuzzy find: start to type
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
bindkey "$terminfo[kcud1]" down-line-or-beginning-search
bindkey "$terminfo[cuu1]" up-line-or-beginning-search
bindkey "$terminfo[cud1]" down-line-or-beginning-search

# JASON
# Restore functionality of option-delete killing not the entire word but to 
# some common non-word characters such as / . -.
# backward-kill-word-with-option-delete () {
#     # Default is apparently:
#     #     ❯  echo ${WORDCHARS}
#     #     *?_-.[]~=/&;!#$%^(){}<>
#     # Let's allow killing to / - . and maybe others later.
#     local WORDCHARS=${WORDCHARS/\-./}
#     zle backward-kill-word
# }
# zle -N backward-kill-word-with-option-delete 
# bindkey '^[^?' backward-kill-word-with-option-delete 
backward-delete-word-with-option-delete () {
    # Default is apparently:
    #     ❯  echo ${WORDCHARS}
    #     *?_-.[]~=/&;!#$%^(){}<>
    # Let's allow killing to / - . and maybe others later.
    #local WORDCHARS=${WORDCHARS/\-./}
    local WORDCHARS=${WORDCHARS/\/}
    local WORDCHARS=${WORDCHARS/-}
    local WORDCHARS=${WORDCHARS/\.}
    zle backward-delete-word
}
zle -N backward-delete-word-with-option-delete 
bindkey '^[^?' backward-delete-word-with-option-delete 

# backward and forward word with option+left/right
bindkey '^[^[[D' backward-word
bindkey '^[b' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[f' forward-word

# to to the beggining/end of line with fn+left/right or home/end
bindkey "${terminfo[khome]}" beginning-of-line
bindkey '^[[H' beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey '^[[F' end-of-line

# delete char with backspaces and delete
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

# delete word with ctrl+backspace
bindkey '^[[3;5~' backward-delete-word
# bindkey '^[[3~' backward-delete-word

# search history with fzf if installed, default otherwise
if test -d /usr/local/opt/fzf/shell; then
	# shellcheck disable=SC1091
	. /usr/local/opt/fzf/shell/key-bindings.zsh
else
	bindkey '^R' history-incremental-search-backward
fi
