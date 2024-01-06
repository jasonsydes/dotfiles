return {
  -- Add the community repository of plugin specifications
  -- Jason Note: This next line makes ALL of the AstroNvim community plugin *specifications*
  --             available to you to use here. Find a list of the community plugins here:
  --             https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity
  -- { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  --
  -- Jason Note: If you want to further configure the community plugin, follow this
  --             guide on the README page here:
  --             https://github.com/AstroNvim/astrocommunity#userpluginscommunitylua-example 

  -- Harpoon
  --    Usage:
  --        https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/motion/harpoon/init.lua
  --        https://github.com/ThePrimeagen/harpoon
  --        Basic Examples:
  --            <leader><leader>        - Show the help menu
  --            <leader><leader>a       - Toggle the quick menu (this is the main interface; use it to jump around)
  --            <leader><leader>e       - Toggle the quick menu (this is the main interface; use it to jump around)
  --                j and k to move around within the quick menu (like other telescope interfaces) 
  --                <enter> to jump to the selected file.
  --            In Normal mode (huh, this community plugin is pretty opinionated to bind these keys):
  --            <C-x>                   - Harpoon mark index (I think you enter integers here, and it jumps you) 
  --            <C-p>                   - Goto previous (harpoon?) mark
  --            <C-n>                   - Goto next (harpoon?) mark
  --                          
  { import = "astrocommunity.motion.harpoon" },

  -- ------------------------------------------------------------
  -- JUST TRYING TO GET BLACK TO WORK EASILY HERE...
  -- Didn't work here. 
  -- But I DID get it to work over in plugins/user.lus. Go there.
  --
  -- Python Pack 
  --    I'm trying this out for the "Black" formatter. 
  -- { import = "astrocommunity.pack.python" },
  -- didn't seem to work...
  --
  -- python-ruff pack
  --    I'm trying this out for the "Black" formatter. 
  -- { import = "astrocommunity.pack.python-ruff" },
  -- gave up trying to make this work.
  -- ------------------------------------------------------------

}
