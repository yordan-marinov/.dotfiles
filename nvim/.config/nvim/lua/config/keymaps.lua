-- =========================================
-- 🧠 Brain-Box | Personal Keymaps
-- Powered by YM neurons ⚡
-- =========================================

-- -----------------------------------------
-- Utility
-- -----------------------------------------
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local home = os.getenv("HOME")
local brain_box_path = home .. "/Google Drive/My Drive/brain-box"
local templates_path = brain_box_path .. "/_templates"

-- =========================================
-- 🪶 General Shortcuts
-- =========================================
keymap("n", "<leader>so", ":source %<CR>", opts) -- source current file
keymap("n", "<leader>nh", ":nohlsearch<CR>", opts)
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>wq", ":wq<CR>", opts)
keymap("n", "<leader>q", ":qa<CR>", opts)

-- jj escape (insert + visual) with pum check
keymap("i", "jj", function()
  if vim.fn.pumvisible() == 1 then
    return "j"
  end
  return "<Esc>"
end, { expr = true, noremap = true, silent = true })

-- =========================================
-- 🪟 Window / Split Management
-- =========================================
keymap("n", "<leader>ws", "<C-w>v", opts)
keymap("n", "<leader>wh", "<C-w>s", opts)
keymap("n", "<leader>we", "<C-w>=", opts)
keymap("n", "<leader>wx", "<cmd>close<CR>", opts)

-- Navigation between splits
keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", opts)
keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", opts)
keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", opts)

-- =========================================
-- 🔭 Telescope
-- =========================================
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- =========================================
-- 🧩 LSP
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
keymap("n", "<leader>bn", "<cmd>bnext<CR>", opts)
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", opts)
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", opts)

-- =========================================
-- 📁 Files Domain
-- =========================================
keymap("n", "<leader>f", "<Nop>", { desc = "+Files" })

keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help Tags" })
keymap("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save File" })
keymap("n", "<leader>fx", "<cmd>bdelete<CR>", { desc = "Close File" })
keymap("n", "<leader>fX", "<cmd>bdelete!<CR>", { desc = "Force Close File" })

-- =========================================
-- 🪶 Misc Utilities
-- =========================================
keymap("n", "<leader>tt", "<cmd>ToggleTerm<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)
keymap("n", "<leader>ss", "<cmd>StartupTime<CR>", opts)

-- =========================================
-- 🌲 Neo-tree
-- =========================================
keymap("n", "<leader>e", "<cmd>Neotree toggle<CR>", opts)
keymap("n", "<leader>ef", "<cmd>Neotree reveal<CR>", opts)
keymap("n", "<leader>er", "<cmd>Neotree refresh<CR>", opts)

-- =========================================
-- ⚙️ Config & Dotfiles
-- =========================================
keymap("n", "<leader>vc", "<cmd>e ~/.config/nvim/init.lua<CR>", opts)
keymap("n", "<leader>vl", "<cmd>e ~/.config/nvim/lua/config/lazy.lua<CR>", opts)
keymap("n", "<leader>vk", "<cmd>e ~/.config/nvim/lua/config/keymaps.lua<CR>", opts)
keymap("n", "<leader>vt", "<cmd>e ~/.config/nvim/lua/plugins/treesitter.lua<CR>", opts)
keymap("n", "<leader>vz", "<cmd>e ~/.zshrc<CR>", opts)
keymap("n", "<leader>vtm", "<cmd>e ~/.tmux.conf<CR>", opts)
keymap("n", "<leader>vd", "<cmd>Neotree ~/.dotfiles reveal<CR>", opts)

-- =========================================
-- 🧠 Brain-Box Automation Functions
-- =========================================

-- Generic note creator
local function create_note(base_dir, template_path, prompt, tag)
  local filename = vim.fn.input("New " .. prompt .. " name: ")
  if filename == "" then
    return
  end

  local new_path = base_dir .. "/" .. filename .. ".md"
  vim.fn.mkdir(vim.fn.fnamemodify(new_path, ":h"), "p")

  local template = vim.fn.filereadable(template_path) and vim.fn.readfile(template_path) or {}

  local date, time = os.date("%d-%m-%Y"), os.date("%H:%M:%S")
  local title = vim.fn.fnamemodify(filename, ":t")

  for i, line in ipairs(template) do
    line = line:gsub("{{date}}", date):gsub("{{time}}", time):gsub("{{title}}", title):gsub("{{tag}}", tag or "")
    template[i] = line
  end

  vim.fn.writefile(template, new_path)
  vim.cmd("edit " .. new_path)
  vim.cmd("Neotree reveal")
end

local function create_learning_note()
  create_note(brain_box_path .. "/learning", templates_path .. "/learning.md", "Learning Note", "learning")
end

local function create_cheatsheet()
  create_note(brain_box_path .. "/cheatsheets", templates_path .. "/cheatsheet.md", "Cheatsheet", "cheatsheet")
end

local function create_snippet()
  create_note(brain_box_path .. "/snippets", templates_path .. "/snippet.md", "Code Snippet", "snippet")
end

-- Smart Obsidian link
local function follow_or_create_obsidian_link_smart()
  local vault = brain_box_path
  local templates = vault .. "/_templates"
  local link = vim.fn.expand("<cWORD>"):gsub("[%[%]]", ""):gsub("%.md", "")
  if link == "" then
    return
  end

  local folder = vim.fn.input("Folder for new note (default: slnotes): ")
  folder = folder ~= "" and folder or "slnotes"

  local note_path = vault .. "/" .. folder .. "/" .. link .. ".md"
  if vim.fn.filereadable(note_path) == 1 then
    return vim.cmd("edit " .. note_path)
  end

  local template_map = {
    cheatsheets = "cheatsheet.md",
    snippets = "snippet.md",
    dailies = "daily.md",
    learning = "learning.md",
    slnotes = "slnote.md",
    mnotes = "mnote.md",
  }

  local tmpl = template_map[folder] or "slnote.md"
  local tmpl_path = templates .. "/" .. tmpl

  local content = vim.fn.filereadable(tmpl_path) and vim.fn.readfile(tmpl_path)
    or {
      "---",
      "created: " .. os.date("%d-%m-%Y %H:%M:%S"),
      "title: " .. link,
      "tags: [" .. folder .. "]",
      "---",
      "",
      "# " .. link,
    }

  vim.fn.mkdir(vault .. "/" .. folder, "p")
  vim.fn.writefile(content, note_path)
  vim.cmd("edit " .. note_path)
  vim.cmd("Neotree reveal")
end

-- Open URL under cursor
local function open_link_in_browser()
  local word = vim.fn.expand("<cWORD>")
  local url = word:match("(https?://[%w%-%._~:/%?#@!$&'()*+,;%%]+)")
  if url then
    os.execute("open " .. url)
  end
end

-- Project scaffold
local function create_new_project_scaffold()
  local vault = brain_box_path .. "/projects"
  local date, time = os.date("%d-%m-%Y"), os.date("%H:%M:%S")
  local name = vim.fn.input("🆕 Project name: ")
  if name == "" then
    return
  end
  local path = vault .. "/" .. name

  if vim.fn.isdirectory(path) == 1 then
    print("⚠️ Project exists")
    vim.cmd("Neotree reveal " .. path)
    return
  end

  local folders = {
    "01-overview",
    "02-decisions",
    "03-infrastructure",
    "04-platform",
    "05-software",
    "06-network",
    "07-storage",
    "08-operations",
    "09-docs",
    "10-architecture",
  }

  for _, d in ipairs(folders) do
    vim.fn.mkdir(path .. "/" .. d, "p")
  end

  local function fm(title, type)
    return {
      "---",
      "title: " .. title,
      "project: " .. name,
      "type: " .. type,
      "created: " .. date .. " " .. time,
      "status: active",
      "tags: [project, " .. name .. "]",
      "---",
      "",
    }
  end

  vim.fn.writefile(fm("README", "readme"), path .. "/README.md")
  local index = fm("Project Index", "index")
  vim.list_extend(index, {
    "# 🧭 Project Index",
    "",
    "## 📌 Overview",
    "- [[01-overview]]",
    "",
    "## 🧱 Infrastructure",
    "- [[03-infrastructure]]",
    "- [[06-network]]",
    "- [[07-storage]]",
    "",
    "## 🛠 Platform",
    "- [[04-platform]]",
    "- [[05-software]]",
    "",
    "## 📘 Documentation",
    "- [[09-docs]]",
    "",
    "## 🔖 Tasks",
    "- [[tasks]]",
    "",
  })
  vim.fn.writefile(index, path .. "/index.md")
  vim.cmd("edit " .. path .. "/index.md")
  vim.cmd("Neotree reveal")
end

-- Add project task
local function list_projects()
  local vault = brain_box_path .. "/projects"
  local result = {}
  local cmd = io.popen('ls -1 "' .. vault .. '"')
  if cmd then
    for n in cmd:lines() do
      if vim.fn.isdirectory(vault .. "/" .. n) == 1 then
        table.insert(result, n)
      end
    end
    cmd:close()
  end
  return result
end

local function add_project_task(project, desc, status)
  status = status or "[ ]"
  local vault = brain_box_path .. "/projects"
  local proj_path = vault .. "/" .. project
  if vim.fn.isdirectory(proj_path) == 0 then
    print("❌ Project '" .. project .. "' does not exist.")
    return
  end
  local tasks_path = proj_path .. "/tasks.md"
  if vim.fn.filereadable(tasks_path) == 0 then
    vim.fn.writefile({ "# 📌 Project Task Log", "", "## Entries", "" }, tasks_path)
  end
  local timestamp = os.date("%Y-%m-%d %H:%M")
  local line = string.format("- %s %s %s", timestamp, status, desc)
  vim.fn.writefile({ line }, tasks_path, "a")
  vim.cmd("edit " .. tasks_path)
end

function _G.add_project_task_prompt()
  local projects = list_projects()
  print("📁 Projects:")
  for _, p in ipairs(projects) do
    print("  - " .. p)
  end
  local proj = vim.fn.input("Project: ")
  if proj == "" then
    return
  end
  local ok = false
  for _, p in ipairs(projects) do
    if p == proj then
      ok = true
    end
  end
  if not ok then
    print("❌ Invalid project: " .. proj)
    return
  end
  local task = vim.fn.input("Task: ")
  if task == "" then
    return
  end
  add_project_task(proj, task)
end

-- =========================================
-- 🗂 Keymaps: Obsidian / Notes Domain
-- =========================================
keymap("n", "<leader>o", "<Nop>", { desc = "+Brain-Box / Obsidian" })

-- New notes
keymap("n", "<leader>onn", "<cmd>ObsidianNew<CR>", { desc = "New Note" })
keymap("n", "<leader>ond", "<cmd>ObsidianToday<CR>", { desc = "Daily Note" })
keymap("n", "<leader>ony", "<cmd>ObsidianYesterday<CR>", { desc = "Yesterday Note" })
keymap("n", "<leader>onL", "<cmd>e " .. brain_box_path .. "/llnotes<CR>", { desc = "Open llnotes" })
keymap("n", "<leader>onP", create_new_project_scaffold, { desc = "New Project Scaffold" })
keymap("n", "<leader>ont", create_learning_note, { desc = "New Learning Note" })
keymap("n", "<leader>onc", create_cheatsheet, { desc = "New Cheatsheet" })
keymap("n", "<leader>ons", create_snippet, { desc = "New Code Snippet" })

-- Add tasks
keymap("n", "<leader>oa", "<Nop>", { desc = "Add" })
keymap("n", "<leader>oat", _G.add_project_task_prompt, { desc = "Add Project Task" })

-- Linking
keymap("n", "<leader>ol", "<Nop>", { desc = "Linking" })
keymap("n", "<leader>olf", follow_or_create_obsidian_link_smart, { desc = "Smart Follow/Create Link" })
keymap("n", "<leader>oll", "<cmd>ObsidianLink<CR>", { desc = "Create Link" })

-- Search
keymap("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Vault" })

-- Open root
keymap("n", "<leader>oo", "<cmd>e " .. brain_box_path .. "<CR>", { desc = "Open Vault Root" })

-- Browser link
keymap("n", "<leader>ob", open_link_in_browser, { desc = "Open URL Under Cursor" })

-- Templates
keymap("n", "<leader>ot", "<Nop>", { desc = "Templates" })
keymap("n", "<leader>otd", "<cmd>e " .. templates_path .. "/daily.md<CR>", { desc = "Daily Template" })
keymap("n", "<leader>ots", "<cmd>e " .. templates_path .. "/slnote.md<CR>", { desc = "SL Note Template" })
keymap("n", "<leader>otc", "<cmd>e " .. templates_path .. "/cheatsheet.md<CR>", { desc = "Cheatsheet Template" })

-- =========================================
-- 🗂 Which-key group labels
-- =========================================
local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<leader>o", group = "Brain-Box / Obsidian" },
    { "<leader>on", group = "New" },
    { "<leader>oa", group = "Add" },
    { "<leader>ol", group = "Link" },
    { "<leader>ot", group = "Templates" },

    { "<leader>f", group = "Files" },
    { "<leader>w", group = "Windows" },
    { "<leader>b", group = "Buffers" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Tools" },
    { "<leader>c", group = "Config" },
    { "<leader>q", group = "Quit" },
    { "<leader>m", group = "Misc" },
    { "<leader>h", group = "Help" },
  })
end
