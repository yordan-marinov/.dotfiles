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

  -- Follow Internal Note Link (Improved)
  ["<leader>zl"] = {
    function()
      -- Get the current line and extract the [[internal_link]]
      local line = vim.api.nvim_get_current_line()
      local link = line:match("%[%[(.-)%]%]")

      if not link then
        print("No valid internal link found!")
        return
      end

      -- Define paths
      local base_path = vim.fn.expand("~/Google Drive/My Drive/brain-box")
      local llnotes_path = base_path .. "/llnotes/" -- Path to llnotes
      local slnotes_path = base_path .. "/slnotes/" -- Path to slnotes

      -- Optimized find command: Search in both llnotes and slnotes folders
      local search_cmd = string.format(
        "find %s %s -type f -name '%s.md' -print -quit 2>/dev/null",
        vim.fn.shellescape(base_path),
        vim.fn.shellescape(llnotes_path),
        vim.fn.shellescape(link)
      )
      local existing_file = vim.trim(vim.fn.system(search_cmd)) -- Get first valid match

      if vim.fn.filereadable(existing_file) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(existing_file)) -- Open existing note
      else
        -- If not found, create in slnotes
        local new_note_path = slnotes_path .. link .. ".md"
        vim.cmd("edit " .. vim.fn.fnameescape(new_note_path))
        print("Created new note in slnotes: " .. link)
      end
    end,
    "Follow Internal Note Link",
  },
  -- Open all markdown notes as buffers (Refactored)
  ["<leader>zr"] = {
    function()
      local notes_dir = vim.fn.expand("~/Google Drive/My Drive/brain-box/slnotes")

      -- Change **only the current window's directory** (avoids global `cd`)
      vim.cmd("lcd " .. vim.fn.fnameescape(notes_dir))

      -- Get markdown files
      local files = vim.fn.glob(notes_dir .. "/*.md", true, true)

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
  ["<leader>ml"] = { ":!mv '%:p' ~/Google\\ Drive/My\\ Drive/brain-box/llnotes/ && bd<CR>", "Move Note to LLNotes" },

  -- Move current note to MNotes
  ["<leader>mm"] = { ":!mv '%:p' ~/Google\\ Drive/My\\ Drive/brain-box/mnotes/ && bd<CR>", "Move Note to MNotes" },

  -- Delete current note
  ["<leader>md"] = { ":!rm '%:p' && bd<CR>", "Delete Current Note" },
}

-- Apply keymaps
for key, mapping in pairs(keymaps) do
  vim.keymap.set("n", key, mapping[1], { desc = mapping[2] })
end
