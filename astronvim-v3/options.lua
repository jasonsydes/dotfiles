-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    spell = false, -- sets vim.opt.spell
    signcolumn = "auto", -- sets vim.opt.signcolumn to auto

    -- Number and relative number display on. 
    relativenumber = true,  -- sets vim.opt.relativenumber
    number = true,          -- sets vim.opt.number
    -- Wrap and better display of soft wrap
    wrap = true,            -- Yes please wrap lines (sets vim.opt.wrap)
                            -- These next two lines make it easier to "see" / "distinguish" between
                            -- the beginning/unwrapped portion of the line and the 'wrapped' portions
                            -- of the line.
    breakindent = true,     -- Make the wrapped part of lines display as indented.
    showbreak = "....",     -- Prefix the wrapped part of lines with '....', thank you very much.
    -- Keep cursor vertically centered always.
    -- (thank you https://vim.fandom.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen)
    scrolloff=999
  },
  g = {
    mapleader = " ", -- sets vim.g.mapleader
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_mode = 2, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    resession_enabled = false, -- enable experimental resession.nvim session management (will be default in AstroNvim v4)
  },
}
-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end
