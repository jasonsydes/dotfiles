" These three lines make it so that neovim shares the same setup as vim. {{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
" }}} ------------------------------------------------------------------------
" True colors {{{
set termguicolors
" }}} ------------------------------------------------------------------------

" vim:set expandtab tabstop=4 softtabstop=4 shiftwidth=4 foldenable foldmethod=marker foldlevel=0:
