-- Plugins via Packer. Use commands :PackerInstall, :PackerSync, etc.
return {
  -- ["goolord/alpha-nvim"] = { disable = true },     -- Might want to disable alpha-nvim at some point.
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


  -- Plugins to check out --
  --    https://github.com/danymat/neogen         -- easily make annotations
}
