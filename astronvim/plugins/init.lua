-- Plugins via Packer. Use commands :PackerInstall, :PackerSync, etc.
return {
  { 'jalvesaq/Nvim-R' },                              -- RStudio replacement in nvim. Gotta start with ,rf to get things going. See https://github.com/jamespeapen/Nvim-R/wiki/Use
  { 'ThePrimeagen/vim-be-good' },                     -- Get better at vim by playing a fun game. Start with :VimBeGood .
  { 'karb94/neoscroll.nvim' },
  ["nvim-treesitter/playground"] = {
    cmd = "TSHighlightCapturesUnderCursor",
  },

  -- Telescope Plugins
  ["nvim-telescope/telescope-project.nvim"] = {         -- browse/switch projects in telescope
    after = "telescope.nvim",
    config = function() require "user.plugins.telescope-project" end,
  },

  -- tagbar
  --    First, install universal-ctags
  --    mamba install universal-ctags
  { 'preservim/tagbar' },

  -- Default AstroNvim plugins to disable.
  ["goolord/alpha-nvim"] = { disable = true },        -- Nice idea, but I don't really use it. This is the greeter / splash page when you first open astronvim.

  -- Plugins to check out --
  --    https://github.com/danymat/neogen         -- easily make annotations
  --    https://github.com/preservim/tagbar
}
