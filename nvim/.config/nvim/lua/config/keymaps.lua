-- =========================================
-- 🧠 Neovim Keymaps | Brain-Box (Final Version)
-- =========================================

-- Shorten function names
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =========================================
-- 🌍 Base Paths
-- =========================================
local home = os.getenv("HOME")
local brain_box_path = home .. "/Google Drive/My Drive/brain-box"
local templates_path = brain_box_path .. "/_templates"

-- =========================================
-- 🪶 General Shortcuts
-- =========================================
keymap("n", "<leader>so", ":source %<CR>", opts) -- source current file

-- jj to escape (insert + visual) with zero delay
vim.keymap.set({ "i", "v" }, "jj", function()
  -- In completion menu? then insert literal 'j'
  if vim.fn.pumvisible() == 1 then
    return "j"
  end
  return "<Esc>"
end, { expr = true, noremap = true, silent = true })

vim.keymap.set("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save File" })

-- =========================================
-- 🌲 Window / plit Management (w)
-- =========================================
keymap("n", "<leader>ws", "<C-w>v", opts) -- vertical split
keymap("n", "<leader>wh", "<C-w>s", opts) -- horizontal split
keymap("n", "<leader>we", "<C-w>=", opts) -- equalize splits
keymap("n", "<leader>wx", ":close<CR>", opts) -- close current split

-- =========================================
-- 🚪 Navigation Between Splits (Ctrl + hjkl)
-- =========================================
keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", opts)
keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", opts)
keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", opts)

-- =========================================
-- 📂 Keymaps: Which-Key Domains
-- =========================================
local wk_ok, which_key = pcall(require, "which-key")
if not wk_ok then
  return
end

-- =========================
-- Helper Functions
-- =========================
-- Create new note from template
local function create_note(base_dir, template_file, tag)
  local filename = vim.fn.input("New note name: ")
  if filename == "" then
    return print("Cancelled")
  end

  local path = base_dir .. "/" .. filename .. ".md"
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

  local content = {}
  if vim.fn.filereadable(template_file) == 1 then
    content = vim.fn.readfile(template_file)
  else
    content = { "# " .. filename, "Created on: " .. os.date("%d-%m-%Y") }
  end

  -- Replace placeholders
  local date, time = os.date("%d-%m-%Y"), os.date("%H:%M:%S")
  for i, line in ipairs(content) do
    line = line:gsub("{{date}}", date)
    line = line:gsub("{{time}}", time)
    line = line:gsub("{{title}}", filename)
    line = line:gsub("{{tag}}", tag or "")
    content[i] = line
  end

  vim.fn.writefile(content, path)
  vim.cmd("edit " .. path)
  vim.cmd("Neotree reveal")
end

-- Specific creators
local function create_learning_note()
  create_note(brain_box_path .. "/learning", templates_path .. "/learning.md", "learning")
end
local function create_cheatsheet()
  create_note(brain_box_path .. "/cheatsheets", templates_path .. "/cheatsheet.md", "cheatsheet")
end
local function create_snippet()
  create_note(brain_box_path .. "/snippets", templates_path .. "/snippet.md", "snippet")
end

-- Follow or create smart Obsidian link
local function follow_or_create_obsidian_link_smart()
  local vault = brain_box_path
  local link = vim.fn.expand("<cWORD>"):gsub("[%[%]]", ""):gsub("%.md", "")
  if link == "" then
    return print("⚠️ No link under cursor")
  end

  local folder = vim.fn.input("Folder (default: slnotes): ")
  folder = folder ~= "" and folder or "slnotes"
  while vim.fn.isdirectory(vault .. "/" .. folder) == 0 do
    print("⚠️ Folder does not exist")
    folder = vim.fn.input("Enter existing folder: ")
  end

  local note_path = vault .. "/" .. folder .. "/" .. link .. ".md"
  if vim.fn.filereadable(note_path) == 1 then
    return vim.cmd("edit " .. note_path)
  end

  local template_map = {
    cheatsheets = "cheatsheet.md",
    snippets = "snippet.md",
    learning = "learning.md",
    slnotes = "slnote.md",
    mnotes = "mnote.md",
    llnotes = "learning.md",
  }
  local template_file = templates_path .. "/" .. (template_map[folder] or "slnote.md")
  create_note(vault .. "/" .. folder, template_file, folder)
end

-- Open URL under cursor in browser
local function open_link_in_browser()
  local word = vim.fn.expand("<cWORD>")
  local url = word:match("(https?://[%w%-%._~:/%?#@!$&'()*+,;%%]+)")
  if not url then
    return print("⚠️ No valid URL under cursor")
  end
  os.execute("open " .. url)
end

-- =========================
-- 🗂 Leader Key Domains (A1 Nested)
-- =========================
which_key.add({
  ["<leader>"] = {

    -- =================
    -- Obsidian / Notes (o)
    -- =================
    o = {
      name = "Obsidian",

      -- New notes
      n = {
        name = "New",
        n = { "<cmd>ObsidianNew<CR>", "New Note" },
        d = { "<cmd>ObsidianToday<CR>", "Daily Note" },
        y = { "<cmd>ObsidianYesterday<CR>", "Yesterday Note" },
        L = { "<cmd>e " .. brain_box_path .. "/llnotes<CR>", "Open llnotes" },
        P = { create_learning_note, "New Learning Note" },
        t = { create_learning_note, "New Learning Note" },
        c = { create_cheatsheet, "New Cheatsheet" },
        s = { create_snippet, "New Code Snippet" },
      },

      -- Linking
      l = {
        name = "Links",
        f = { follow_or_create_obsidian_link_smart, "Follow/Create Link (smart)" },
        b = { open_link_in_browser, "Open Link in Browser" },
        l = { "<cmd>ObsidianLink<CR>", "Link Note" },
      },

      -- Search & open
      s = { "<cmd>ObsidianSearch<CR>", "Search Vault" },
      o = { "<cmd>e " .. brain_box_path .. "<CR>", "Open Brain-Box Root" },
    },

    -- =================
    -- Files (f)
    -- =================
    f = {
      name = "Files",
      f = { "<cmd>Telescope find_files<CR>", "Find Files" },
      g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
      b = { "<cmd>Telescope buffers<CR>", "Buffers" },
      h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
      s = { "<cmd>w<CR>", "Save File" },
    },

    -- =================
    -- Windows / Splits (w)
    -- =================
    w = {
      name = "Windows",
      s = { "<C-w>v", "Split Vertical" },
      h = { "<C-w>s", "Split Horizontal" },
      e = { "<C-w>=", "Equalize Splits" },
      x = { ":close<CR>", "Close Split" },
    },

    -- =================
    -- Buffers (b)
    -- =================
    b = {
      name = "Buffers",
      n = { ":bnext<CR>", "Next Buffer" },
      p = { ":bprevious<CR>", "Previous Buffer" },
      d = { ":bdelete<CR>", "Delete Buffer" },
    },

    -- =================
    -- Telescope / Search (s)
    -- =================
    s = {
      name = "Search",
      f = { "<cmd>Telescope find_files<CR>", "Find Files" },
      g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
      b = { "<cmd>Telescope buffers<CR>", "Buffers" },
      h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
    },

    -- =================
    -- Git (g) - placeholder
    -- =================
    g = {
      name = "Git",
      s = { "<cmd>echo 'No git plugin installed'<CR>", "Status" },
      d = { "<cmd>echo 'No git plugin installed'<CR>", "Diff" },
    },

    -- =================
    -- Templates / Tools (t)
    -- =================
    t = {
      name = "Templates",
      d = { "<cmd>e " .. templates_path .. "/daily.md<CR>", "Daily Template" },
      s = { "<cmd>e " .. templates_path .. "/slnote.md<CR>", "SLNote Template" },
      c = { "<cmd>e " .. templates_path .. "/cheatsheet.md<CR>", "Cheatsheet Template" },
    },

    -- =================
    -- Config / Dotfiles (c)
    -- =================
    c = {
      name = "Config",
      v = { "<cmd>e ~/.config/nvim/init.lua<CR>", "Init.lua" },
      l = { "<cmd>e ~/.config/nvim/lua/config/lazy.lua<CR>", "Lazy config" },
      k = { "<cmd>e ~/.config/nvim/lua/config/keymaps.lua<CR>", "Keymaps" },
      t = { "<cmd>e ~/.config/nvim/lua/plugins/treesitter.lua<CR>", "Treesitter" },
      z = { "<cmd>e ~/.zshrc<CR>", "Zsh config" },
      tm = { "<cmd>e ~/.tmux.conf<CR>", "Tmux config" },
      d = { "<cmd>Neotree ~/.dotfiles reveal<CR>", "Dotfiles folder" },
    },

    -- =================
    -- Quit / Session (q)
    -- =================
    q = {
      name = "Quit",
      q = { ":qa<CR>", "Quit all" },
      wq = { ":wq<CR>", "Write & Quit" },
    },

    -- =================
    -- Misc / Terminal (m)
    -- =================
    m = {
      name = "Misc",
      tt = { ":ToggleTerm<CR>", "Toggle Terminal" },
    },

    -- =================
    -- Help / Info (h)
    -- =================
    h = {
      name = "Help",
      ss = { ":StartupTime<CR>", "Startup Time" },
    },
  },
})
