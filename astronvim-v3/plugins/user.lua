return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },

  -- Provide :Bdelete
  { "famiu/bufdelete.nvim",
    -- load no matter what (otherwise, doesn't seem to work...)
    lazy = false,
  },

  -- Nextflow 
  { "Mxrcon/nextflow-vim",
    -- load no matter what (otherwise, doesn't seem to work...)
    lazy = false,
  },
  -- Doesn't seem to work?
  -- { 'karb94/neoscroll.nvim', lazy = false}

  -- Disable these plugins that AstroNvim includes by default.
  {'goolord/alpha-nvim', enabled = false}
}
