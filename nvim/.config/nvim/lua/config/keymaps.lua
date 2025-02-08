-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

wk.register({
  p = {
    v = { ":VenvSelect<CR>", "Select Virtual Environment" },
    c = { ":VenvSelectCached<CR>", "Use Cached Virtual Environment" },
  },
}, { prefix = "<leader>" })
