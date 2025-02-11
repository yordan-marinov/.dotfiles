-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- keymaps.lua
local keymaps = {
  -- Virtual Environment commands
  ["<leader>pv"] = { ":VenvSelect<CR>", "Select Virtual Environment" },
  ["<leader>pc"] = { ":VenvSelectCached<CR>", "Use Cached Virtual Environment" },

  -- Terminal key mappings
  ["<leader>th"] = { ":split | terminal<CR>", "Open Horizontal Terminal" },
  ["<leader>tv"] = { ":vsplit | terminal<CR>", "Open Vertical Terminal" },

  -- Debugging key mappings
  ["<leader>db"] = {
    function()
      require("dap").toggle_breakpoint()
    end,
    "Toggle Breakpoint",
  },
  ["<leader>dc"] = {
    function()
      require("dap").continue()
    end,
    "Continue Debugging",
  },
  ["<leader>ds"] = {
    function()
      require("dap").step_into()
    end,
    "Step Into",
  },
  ["<leader>do"] = {
    function()
      require("dap").step_over()
    end,
    "Step Over",
  },
  ["<leader>dq"] = {
    function()
      require("dap").close()
    end,
    "Close Debugger",
  },

  -- Telekasten keymaps (Second Brain)
  ["<leader>zp"] = { ":Telekasten panel<CR>", "Open Telekasten panel" },
  ["<leader>zf"] = { ":Telekasten find_notes<CR>", "Find Notes" },
  ["<leader>zg"] = { ":Telekasten live_grep_notes<CR>", "Search Notes" },
  ["<leader>zn"] = { ":Telekasten new_note<CR>", "New Note" },
  ["<leader>zd"] = { ":Telekasten goto_today<CR>", "Today's Note" },
  ["<leader>zj"] = { ":Telekasten follow_link<CR>", "Follow Note Link" },
  ["<leader>zb"] = { ":Telekasten show_backlinks<CR>", "Show Backlinks" },
}

-- Apply the new keymap format
for key, mapping in pairs(keymaps) do
  vim.keymap.set("n", key, mapping[1], { desc = mapping[2] })
end
