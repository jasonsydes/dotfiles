return {
  -- Normal mode
  n = {
    -- Does astronvim read in my mappings.lua custom file? Test by ctrl-y in Normal mode.
    ["<C-y>"] = {
      function()
        vim.notify("Testing time!", "warn", { title = "Change your habit" })
      end,
    },

    -- mappings seen under group name "Buffer"
    ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tabbbb" },
    ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
    ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
    ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },

  },
  -- Insert mode
  i = {},
}
