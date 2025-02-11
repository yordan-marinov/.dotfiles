-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- keymaps.lua
local wk = require("which-key")

wk.register({
  -- Virtual Environment commands
  p = {
    v = { ":VenvSelect<CR>", "Select Virtual Environment" },
    c = { ":VenvSelectCached<CR>", "Use Cached Virtual Environment" },
  },

  -- Terminal key mappings
  t = {
    h = { ":split | terminal<CR>", "Open Horizontal Terminal" },
    v = { ":vsplit | terminal<CR>", "Open Vertical Terminal" },
  },

  -- Debugging key mappings
  d = {
    b = { ":lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint" },
    c = { ":lua require'dap'.continue()<CR>", "Continue Debugging" },
    s = { ":lua require'dap'.step_into()<CR>", "Step Into" },
    o = { ":lua require'dap'.step_over()<CR>", "Step Over" },
    q = { ":lua require'dap'.close()<CR>", "Close Debugger" },
  },
}, {
  prefix = "<leader>", -- The leader key (space)
  mode = "n", -- Normal mode (you can adjust this for other modes as well)
})
