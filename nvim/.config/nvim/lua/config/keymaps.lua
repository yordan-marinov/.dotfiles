-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymap configuration
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

  -- Telekasten keymaps (Brain-Box)
  ["<leader>zp"] = { ":Telekasten panel<CR>", "Open Telekasten panel" },
  ["<leader>zf"] = { ":Telekasten find_notes<CR>", "Find Notes" },
  ["<leader>zg"] = { ":Telekasten live_grep_notes<CR>", "Search Notes" },
  ["<leader>zd"] = { ":Telekasten goto_today<CR>", "Today's Note" },
  ["<leader>zj"] = { ":Telekasten follow_link<CR>", "Follow Note Link" },
  ["<leader>zb"] = { ":Telekasten show_backlinks<CR>", "Show Backlinks" },

  -- SLNotes: Open all markdown notes as buffers
  ["<leader>zr"] = {
    function()
      -- Define the SLNotes directory and expand the path
      local notes_dir = vim.fn.expand("~/Google Drive/My Drive/brain-box/slnotes")

      -- Change the working directory to SLNotes
      vim.cmd("cd " .. vim.fn.fnameescape(notes_dir))

      -- Get the list of markdown files in the directory
      local files = vim.fn.glob(notes_dir .. "/*.md", true, true)

      -- Check if any files were found
      if #files == 0 then
        print("No markdown notes found in SLNotes.")
        return
      end

      -- Open each markdown file in a new buffer
      for _, file in ipairs(files) do
        vim.cmd("edit " .. vim.fn.fnameescape(file))
      end
    end,
    "Open all SLNotes in buffers",
  },
  -- Move current note to LLNotes
  ["<leader>ml"] = { ":!mv '%:p' ~/Google\\ Drive/My\\ Drive/brain-box/llnotes/<cr>:bd<cr>", "Move Note to LLNotes" },

  -- Move current note to MNotes
  ["<leader>mm"] = { ":!mv '%:p' ~/Google\\ Drive/My\\ Drive/brain-box/mnotes/<cr>:bd<cr>", "Move Note to MNotes" },

  -- Delete current note
  ["<leader>md"] = { ":!rm '%:p'<cr>:bd<cr>", "Delete Current Note" },
}

-- Apply the new keymap format
for key, mapping in pairs(keymaps) do
  vim.keymap.set("n", key, mapping[1], { desc = mapping[2] })
end