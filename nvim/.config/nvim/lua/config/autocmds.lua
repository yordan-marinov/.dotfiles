-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    local file_name = vim.fn.expand("%:t:r") -- Get the filename without extension
    local date = os.date("%d-%m-%Y") -- Get the current date
    local template = {
      "# " .. file_name,
      "",
      "## Overview",
      "",
      "Write a brief summary of your note here.",
      "",
      "## Details",
      "---",
      "",
      "## References",
      "- [Link to a resource](#)",
      "- [[Another note]]",
      "---",
      "",
      "## Ideas / Thoughts",
      "---",
      "",
      "Created on: " .. date,
    }

    -- Set the whole buffer content
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
  end,
})
