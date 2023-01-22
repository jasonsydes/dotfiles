-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
  },
  g = {
    mapleader = " ", -- sets vim.g.mapleader
    maplocalleader = ",", -- Jason added here because nvim-R localleader '\' clashes with astronvim's '\' horizontal split.
  },
}
