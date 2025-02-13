-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatically set the title to the file name when creating a new markdown file
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    -- Set the title to the file name
    local file_name = vim.fn.expand("%:t:r") -- Get the file name without the extension
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# " .. file_name }) -- Set the first line to # filename

    -- Insert the current date at the bottom of the file
    local date = os.date("%d-%m-%Y") -- Get the current date in DD-MM-YYYY format
    local date_line = "Created on: " .. date
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { date_line }) -- Add the date at the end
  end,
})
