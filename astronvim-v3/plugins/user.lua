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
  -- { 'karb94/neoscroll.nvim', lazy = false},

  -- cue syntax highlighting, maybe. (seems to work?)
  -- { 'jjo/vim-cue', lazy = false},
  { 'jjo/vim-cue', lazy = true },
  -- -- cue treesitter grammer, maybe
  -- { 'nvim-treesitter/nvim-treesitter', lazy = false},

  -- --------------------------------------------------------------------------------------------------------
  -- Let's try Black
  --    Install:
  --        # Install the python neovim client (https://github.com/neovim/pynvim) like so:
  --        conda install neovim
  --        # I *think* I had to install Black on the command line as well?
  --        conda install black
  --
  --    Usage:
  --        :Black (takes a moment or two...)
  --    Note:
  --        20240106
  --        I tried a BUNCH of different ways to make Black work with AstroNvim.
  --        There probably is some perfect way, I just wasn't able to uncover it 
  --        in about oh say 30 minutes of digging.
  --
  --        Here's a few of the ways I tried (that didn't work):
  --            - Mason installed the 'black' and 'blackd-client' (these show up as "Formatters")
  --                - This causes 'black' to show up at bottom right corner, but doesn't seem to do anything.
  --            - Added the "astrocommunity.pack.python" pack to community.lua
  --                - Why? Because it had "black" in it.
  --                - Didn't seem to work.
  --            - Someone suggested the ruff-lsp
  --                - Didn't seem to work (can't type ":Black", can't find neovim docs)
  --            - Tried all of the above after doing conda install black.
  --            - Probably other approached I'm forgetting about. 
  --        
  --        Here's what I tried that DID work:
  --            - I installed the official psf/black plugin (see below).
  --                - This is DISTINCT from all the other approaches above.
  --                - It worked!
  --    Usage:
  --        Type ":Black" and wait a few seconds.
  { 'psf/black',
    ft = "python", -- NOTE: ft: lazy-load on filetype
  },
  -- --------------------------------------------------------------------------------------------------------

  -- Disable these plugins that AstroNvim includes by default.
  {'goolord/alpha-nvim', enabled = false },
}
