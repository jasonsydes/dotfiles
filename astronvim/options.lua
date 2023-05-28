-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    foldmethod = 'indent',    -- temporarily turn this on everywhere; eventually, just turn it on for python


    -- Wrapping
    wrap = true,
    -- Better display of softwrap
    showbreak = '....',                 -- Show '....' at the beginning of wrapped lines.
    breakindent = true,                 -- Make the any wrapped lines be indented.


  },
  g = {
    mapleader = " ", -- sets vim.g.mapleader
    maplocalleader = ",", -- Jason added here because nvim-R localleader '\' clashes with astronvim's '\' horizontal split.
  },
}
