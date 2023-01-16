

### LSP: Python ###
# Install LSP for python:
lvim
:LspInstall pyright

# Install Pandas stubs so that pyright can understand Pandas.
#   From https://github.com/pandas-dev/pandas-stubs#differences-between-type-declarations-in-pandas-and-pandas-stubs
#   "The https://github.com/pandas-dev/pandas-stubs/ project provides type declarations for the pandas public API."
# See also 
#   https://www.reddit.com/r/neovim/comments/sazbw6/comment/htxhvnx/
conda activate base
mamba install pandas-stubs
