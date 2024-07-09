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
  -- {'kevinhwang91/nvim-ufo', enabled = false },


  -- {
  --   "epwalsh/obsidian.nvim",
  --
  --   -- the obsidian vault in this default config  ~/obsidian-vault
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
  --   -- event = { "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
  --   event = { "BufReadPre  */obsidian-vault/*.md" },
  --   keys = {
  --     {
  --       "gf",
  --       function()
  --         if require("obsidian").util.cursor_on_markdown_link() then
  --           return "<cmd>ObsidianFollowLink<CR>"
  --         else
  --           return "gf"
  --         end
  --       end,
  --       noremap = false,
  --       expr = true,
  --     },
  --     {
  --       "<leader>;",
  --       function()
  --         return require("obsidian").util.toggle_checkbox()
  --       end,
  --       buffer = true,
  --     },
  --
  --   },
  --
  --   ui = {
  --     enable = true,  -- set to false to disable all additional syntax features
  --     update_debounce = 200,  -- update delay after a text change (in milliseconds)
  --     -- Define how various check-boxes are displayed
  --     checkboxes = {
  --       -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
  --       [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
  --       ["x"] = { char = "", hl_group = "ObsidianDone" },
  --       [">"] = { char = "", hl_group = "ObsidianRightArrow" },
  --       ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
  --       -- Replace the above with this if you don't have a patched font:
  --       -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
  --       -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
  --
  --       -- You can also add more custom ones...
  --     },
  --     -- Use bullet marks for non-checkbox lists.
  --     bullets = { char = "•", hl_group = "ObsidianBullet" },
  --     external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
  --     -- Replace the above with this if you don't have a patched font:
  --     -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
  --     reference_text = { hl_group = "ObsidianRefText" },
  --     highlight_text = { hl_group = "ObsidianHighlightText" },
  --     tags = { hl_group = "ObsidianTag" },
  --     hl_groups = {
  --       -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
  --       ObsidianTodo = { bold = true, fg = "#f78c6c" },
  --       ObsidianDone = { bold = true, fg = "#89ddff" },
  --       ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
  --       ObsidianTilde = { bold = true, fg = "#ff5370" },
  --       ObsidianBullet = { bold = true, fg = "#89ddff" },
  --       ObsidianRefText = { underline = true, fg = "#c792ea" },
  --       ObsidianExtLinkIcon = { fg = "#c792ea" },
  --       ObsidianTag = { italic = true, fg = "#89ddff" },
  --       ObsidianHighlightText = { bg = "#75662e" },
  --     },
  --   },
  --
  --
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   opts = {
  --     dir = vim.env.HOME .. "/obsidian-vault", -- specify the vault location. no need to call 'vim.fn.expand' here
  --     use_advanced_uri = true,
  --     finder = "telescope.nvim",
  --     mappings = {
  --
  --
  --     },
  --
  --     templates = {
  --       subdir = "templates",
  --       date_format = "%Y-%m-%d-%a",
  --       time_format = "%H:%M",
  --     },
  --
  --     -- turn on syntax highlighting...
  --     highlight = { enable = true, },
  --     opt = {
  --       conceallevel=2,
  --     },
  --
  --
  --     workspaces = {
  --       {
  --         name = "chefs-log",
  --         path = "~/ObsidianSync/v3/cooking/chefs-log",
  --       },
  --       {
  --         name = "bgmp",
  --         path = "~/ObsidianSync/v3/work/BGMP",
  --       },
  --     },
  --
  --     note_frontmatter_func = function(note)
  --       -- This is equivalent to the default frontmatter function.
  --       local out = { id = note.id, aliases = note.aliases, tags = note.tags }
  --       -- `note.metadata` contains any manually added fields in the frontmatter.
  --       -- So here we just make sure those fields are kept in the frontmatter.
  --       if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
  --         for k, v in pairs(note.metadata) do
  --           out[k] = v
  --         end
  --       end
  --       return out
  --     end,
  --
  --     -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
  --     -- URL it will be ignored but you can customize this behavior here.
  --     follow_url_func = vim.ui.open or require("astronvim.utils").system_open,
  --   },
  -- }


}
