-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`

-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- =========================================
-- 🛠 Neovim Autocmds | Brain-Box / Obsidian (Final)
-- =========================================
-- Base paths
local home = os.getenv("HOME")
local brain_box_path = home .. "/Google Drive/My Drive/brain-box"
local templates_path = brain_box_path .. "/_templates"

-- =========================================
-- Helper Function: Load Template into Buffer
-- =========================================
local function load_template(template_file, title, tag)
  if vim.fn.filereadable(template_file) == 0 then
    return { "# " .. (title or "New Note"), "", "Created on: " .. os.date("%d-%m-%Y") }
  end

  local template = vim.fn.readfile(template_file)
  local date, time = os.date("%d-%m-%Y"), os.date("%H:%M:%S")

  for i, line in ipairs(template) do
    line = line:gsub("{{title}}", title or "")
    line = line:gsub("{{date}}", date)
    line = line:gsub("{{time}}", time)
    line = line:gsub("{{tag}}", tag or "")
    template[i] = line
  end

  return template
end

-- =========================================
-- Autocmd: Auto-fill new Markdown files
-- =========================================
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    local buf_name = vim.fn.expand("%:t:r") -- filename without extension
    local folder = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":t")

    -- Map folder names to templates
    local template_map = {
      learning = "learning.md",
      cheatsheets = "cheatsheet.md",
      snippets = "snippet.md",
      llnotes = "learning.md",
      slnotes = "slnote.md",
      mnotes = "mnote.md",
    }

    local template_file = templates_path .. "/" .. (template_map[folder] or "slnote.md")
    local content = load_template(template_file, buf_name, folder)

    -- Set buffer lines
    vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
  end,
})
