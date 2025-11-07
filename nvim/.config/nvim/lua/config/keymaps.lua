-- =========================================
-- 🧠 Brain-Box | Neovim Keymaps (Final Refactor)
-- =========================================

-- Shorten function name
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key (space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Path to your Brain-Box
local brain_box_path = "/Users/yordan/Google Drive/My Drive/brain-box"

-- =========================================
-- 🚀 General
-- =========================================
keymap("n", "<leader>nh", ":nohlsearch<CR>", opts) -- clear search highlights
keymap("n", "<leader>w", ":w<CR>", opts) -- save file
keymap("n", "<leader>wq", ":wq<CR>", opts) -- save and quit
keymap("n", "<leader>q", ":qa<CR>", opts) -- quit all
keymap("i", "jj", "<Esc>", opts) -- exit insert mode
keymap("n", "<leader>so", ":source %<CR>", opts) -- source current file

-- =========================================
-- 🪟 Window / Split Management
-- =========================================
keymap("n", "<leader>ws", "<C-w>v", opts) -- split vertically
keymap("n", "<leader>wh", "<C-w>s", opts) -- split horizontally
keymap("n", "<leader>we", "<C-w>=", opts) -- equalize splits
keymap("n", "<leader>wx", ":close<CR>", opts) -- close current split

-- Move between splits (works with tmux navigator)
keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", opts)
keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", opts)
keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", opts)

-- =========================================
-- 📂 File Explorer & Telescope
-- =========================================
keymap("n", "<leader>e", ":Neotree toggle<CR>", opts) -- toggle file tree
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- =========================================
-- 🧱 Obsidian / Brain-Box Notes
-- =========================================
-- New Notes
keymap("n", "<leader>onn", ":ObsidianNew<CR>", opts) -- new note
keymap("n", "<leader>ond", ":ObsidianToday<CR>", opts) -- new daily note
keymap("n", "<leader>ony", ":ObsidianYesterday<CR>", opts) -- open yesterday's daily
-- keymap("n", "<leader>onl", ":e " .. brain_box_path .. "/learning<CR>", opts) -- open learning folder check the functions on bottom
-- keymap("n", "<leader>ons", ":e " .. brain_box_path .. "/slnotes<CR>", opts) -- open slnotes folder check the functions on bottom
keymap("n", "<leader>onL", ":e " .. brain_box_path .. "/llnotes<CR>", opts) -- open llnotes folder
-- keymap("n", "<leader>onc", ":e " .. brain_box_path .. "/cheatsheets<CR>", opts) -- open cheatsheets folder check the functions on bottom
keymap("n", "<leader>onp", ":e " .. brain_box_path .. "/projects<CR>", opts) -- open projects folder
keymap("n", "<leader>oni", ":e " .. brain_box_path .. "/index.md<CR>", opts) -- open index file

-- Obsidian utilities
keymap("n", "<leader>os", ":ObsidianSearch<CR>", opts) -- search in vault
keymap("n", "<leader>oo", ":e " .. brain_box_path .. "<CR>", opts) -- open brain-box root

-- Linking / Navigation inside notes
-- keymap("n", "<leader>olf", ":ObsidianFollowLink<CR>", opts) -- follow or create note from link check the functions on bottom
keymap("n", "<leader>oll", ":ObsidianLink<CR>", opts) -- create a link to another note

-- =========================================
-- ⚙️ Config & Dotfiles Shortcuts
-- =========================================
keymap("n", "<leader>vc", ":e ~/.config/nvim/init.lua<CR>", opts)
keymap("n", "<leader>vl", ":e ~/.config/nvim/lua/config/lazy.lua<CR>", opts)
keymap("n", "<leader>vk", ":e ~/.config/nvim/lua/config/keymaps.lua<CR>", opts)
keymap("n", "<leader>vt", ":e ~/.config/nvim/lua/plugins/treesitter.lua<CR>", opts)
keymap("n", "<leader>vz", ":e ~/.zshrc<CR>", opts)
keymap("n", "<leader>vtm", ":e ~/.tmux.conf<CR>", opts)
keymap("n", "<leader>vd", ":Neotree ~/.dotfiles reveal<CR>", opts) -- open dotfiles folder in Neo-tree

-- =========================================
-- 🧩 LSP & Completion
-- =========================================
keymap("n", "K", vim.lsp.buf.hover, opts)
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "gr", vim.lsp.buf.references, opts)
keymap("n", "gi", vim.lsp.buf.implementation, opts)
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
keymap("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, opts)

-- =========================================
-- 🧹 Buffer Management
-- =========================================
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- =========================================
-- 🪶 Misc Utilities
-- =========================================
keymap("n", "<leader>tt", ":ToggleTerm<CR>", opts) -- toggle terminal
keymap("t", "<Esc>", "<C-\\><C-n>", opts) -- exit terminal mode
keymap("n", "<leader>ss", ":StartupTime<CR>", opts) -- check startup time

-- =========================================
-- 🌲 Neo-tree Shortcuts
-- =========================================
keymap("n", "<leader>ef", ":Neotree reveal<CR>", opts) -- reveal current file
keymap("n", "<leader>er", ":Neotree refresh<CR>", opts) -- refresh tree

-- =========================================
-- 🧠 Brain-Box Templates
-- =========================================
keymap("n", "<leader>otd", ":e " .. brain_box_path .. "/_templates/daily.md<CR>", opts)
keymap("n", "<leader>ots", ":e " .. brain_box_path .. "/_templates/slnote.md<CR>", opts)
keymap("n", "<leader>otc", ":e " .. brain_box_path .. "/_templates/cheatsheet.md<CR>", opts)

-- =========================================
-- key map functions to automate tasks
-- =========================================
-- Create a new note from a template with dynamic placeholders
local function create_note(base_dir, template_path, subfolder_prompt, tag_label)
  local filename = vim.fn.input("New " .. subfolder_prompt .. " name (e.g. git/git_basics): ")
  if filename == "" then
    print("Cancelled.")
    return
  end

  local new_path = base_dir .. "/" .. filename .. ".md"
  local dir = vim.fn.fnamemodify(new_path, ":h")
  vim.fn.mkdir(dir, "p")

  if vim.fn.filereadable(template_path) == 0 then
    print("⚠️ Template not found at: " .. template_path)
    return
  end

  -- Read template
  local template = vim.fn.readfile(template_path)

  -- Get current date, time, and title from filename
  local date = os.date("%d-%m-%Y")
  local time = os.date("%H:%M:%S")
  local title = vim.fn.fnamemodify(filename, ":t") -- take only the last part (file name)

  -- Replace placeholders
  for i, line in ipairs(template) do
    line = line:gsub("{{date}}", date)
    line = line:gsub("{{time}}", time)
    line = line:gsub("{{title}}", title)
    line = line:gsub("{{tag}}", tag_label or "")

    -- Also support Obsidian-style date placeholders
    line = line:gsub("{{date:.-}}", date .. " " .. time)
    template[i] = line
  end
  -- Write new file
  vim.fn.writefile(template, new_path)

  -- Open in Neovim
  vim.cmd("edit " .. new_path)

  -- Reveal it in Neo-tree
  vim.cmd("Neotree reveal")
end

-- Create new Learning Note
local function create_learning_note()
  create_note(
    "/Users/yordan/Google Drive/My Drive/brain-box/learning",
    "/Users/yordan/Google Drive/My Drive/brain-box/_templates/learning.md",
    "Learning Note",
    "learning"
  )
end

vim.keymap.set("n", "<leader>onl", create_learning_note, {
  desc = "New Learning Note (auto template)",
  noremap = true,
  silent = true,
})
-- Create new Cheatsheet
local function create_cheatsheet()
  create_note(
    "/Users/yordan/Google Drive/My Drive/brain-box/cheatsheets",
    "/Users/yordan/Google Drive/My Drive/brain-box/_templates/cheatsheet.md",
    "Cheatsheet",
    "cheatsheet"
  )
end

vim.keymap.set("n", "<leader>onc", create_cheatsheet, {
  desc = "New Cheatsheet (auto template)",
  noremap = true,
  silent = true,
})

-- Create new Code Snippet
local function create_snippet()
  create_note(
    "/Users/yordan/Google Drive/My Drive/brain-box/snippets",
    "/Users/yordan/Google Drive/My Drive/brain-box/_templates/snippet.md",
    "Code Snippet",
    "snippet"
  )
end

vim.keymap.set("n", "<leader>ons", create_snippet, {
  desc = "New Code Snippet (auto template)",
  noremap = true,
  silent = true,
})

-- =========================================
-- 🧩 Smart Obsidian Link Follow or Create
-- =========================================
local function follow_or_create_obsidian_link_smart()
  -- Base paths
  local vault_path = "/Users/yordan/Google Drive/My Drive/brain-box"
  local templates_path = vault_path .. "/_templates"

  -- Get link name under cursor
  local link = vim.fn.expand("<cWORD>"):gsub("[%[%]]", ""):gsub("%.md", "")
  if link == "" then
    print("⚠️ No link under cursor.")
    return
  end

  -- Get all top-level folders inside the vault
  local handle = io.popen('ls -1 "' .. vault_path .. '"')
  if not handle then
    print("⚠️ Unable to read vault folders.")
    return
  end

  local folders = {}
  for line in handle:lines() do
    local path = vault_path .. "/" .. line
    if vim.fn.isdirectory(path) == 1 and not line:match("^_") then
      table.insert(folders, line)
    end
  end
  handle:close()

  -- Ask user for folder name
  local folder = vim.fn.input("📁 Folder for new note (default: slnotes): ")

  -- Validate folder
  while folder ~= "" and vim.fn.isdirectory(vault_path .. "/" .. folder) == 0 do
    print("⚠️ Folder '" .. folder .. "' does not exist.")
    print("Available folders: " .. table.concat(folders, ", "))
    folder = vim.fn.input("Please enter an existing folder name: ")
  end

  if folder == "" then
    folder = "slnotes"
  end

  local note_path = vault_path .. "/" .. folder .. "/" .. link .. ".md"

  -- If note already exists, just open it
  if vim.fn.filereadable(note_path) == 1 then
    vim.cmd("edit " .. note_path)
    return
  end

  -- 🧩 Template selection map (based on your _templates folder)
  local template_map = {
    cheatsheets = "cheatsheet.md",
    snippets = "code-snippet.md",
    dailies = "daily.md",
    learning = "learning.md",
    slnotes = "slnote.md",
    mnotes = "mnote.md",
  }

  -- Detect template name from folder
  local template_name = template_map[folder] or "slnote.md"
  local template_file = templates_path .. "/" .. template_name

  local content = {}

  -- Use template if exists, else fallback
  if vim.fn.filereadable(template_file) == 1 then
    content = vim.fn.readfile(template_file)
  else
    print("⚠️ No template found for '" .. folder .. "', using fallback.")
    content = {
      "---",
      "created: " .. os.date("%d-%m-%Y %H:%M:%S"),
      "title: " .. link,
      "tags: [" .. folder .. "]",
      "---",
      "",
      "# " .. link,
      "",
    }
  end

  -- Replace placeholders dynamically
  local date = os.date("%d-%m-%Y")
  local time = os.date("%H:%M:%S")
  for i, line in ipairs(content) do
    line = line:gsub("{{date}}", date)
    line = line:gsub("{{time}}", time)
    line = line:gsub("{{title}}", link)
    line = line:gsub("{{tag}}", folder)
    content[i] = line
  end

  -- Ensure folder exists
  vim.fn.mkdir(vault_path .. "/" .. folder, "p")

  -- Write and open the new note
  vim.fn.writefile(content, note_path)
  print("🧠 Created new note in '" .. folder .. "': " .. link)
  vim.cmd("edit " .. note_path)
  vim.cmd("Neotree reveal")
end

-- Keymap: Follow or Create Link (smart)
keymap("n", "<leader>olf", follow_or_create_obsidian_link_smart, {
  noremap = true,
  silent = true,
  desc = "Follow or Create Obsidian Link (smart)",
})

-- =========================================
-- 🌐 Open Link Under Cursor in Browser
-- =========================================
local function open_link_in_browser()
  local word = vim.fn.expand("<cWORD>")
  local url = word:match("(https?://[%w%-%._~:/%?#@!$&'()*+,;%%]+)")

  if not url then
    print("⚠️ No valid URL under cursor.")
    return
  end

  -- macOS command to open URLs in the default browser
  os.execute("open " .. url)
  print("🌐 Opening in browser: " .. url)
end

vim.keymap.set("n", "<leader>ob", open_link_in_browser, {
  noremap = true,
  silent = true,
  desc = "Open link under cursor in browser",
})
