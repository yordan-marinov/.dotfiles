-- =========================================
-- 🧠 Brain-Box | Neovim Keymaps
-- =========================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Path to Brain-Box (portable)
local home = os.getenv("HOME")
local brain_box_path = home .. "/Google Drive/My Drive/brain-box"

-- =========================================
-- 🚀 General Keymaps
-- =========================================
local general = {
  { "n", "<leader>nh", ":nohlsearch<CR>", "Clear search highlights" },
  { "n", "<leader>w", ":w<CR>", "Save file" },
  { "n", "<leader>wq", ":wq<CR>", "Save & quit" },
  { "n", "<leader>q", ":qa<CR>", "Quit all" },
  { "i", "jj", "<Esc>", "Exit insert mode" },
  { "n", "<leader>so", ":source %<CR>", "Source current file" },
}

for _, map in ipairs(general) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- 🪟 Window / Split Management
-- =========================================
local window = {
  { "n", "<leader>ws", "<C-w>v", "Split vertically" },
  { "n", "<leader>wh", "<C-w>s", "Split horizontally" },
  { "n", "<leader>we", "<C-w>=", "Equalize splits" },
  { "n", "<leader>wx", ":close<CR>", "Close split" },
  { "n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", "Move left" },
  { "n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", "Move down" },
  { "n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", "Move up" },
  { "n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", "Move right" },
}

for _, map in ipairs(window) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- 📂 File Explorer & Telescope
-- =========================================
local files = {
  { "n", "<leader>e", ":Neotree toggle<CR>", "Toggle file tree" },
  { "n", "<leader>ff", "<cmd>Telescope find_files<CR>", "Find files" },
  { "n", "<leader>fg", "<cmd>Telescope live_grep<CR>", "Live grep" },
  { "n", "<leader>fb", "<cmd>Telescope buffers<CR>", "Buffers" },
  { "n", "<leader>fh", "<cmd>Telescope help_tags<CR>", "Help tags" },
}

for _, map in ipairs(files) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- ⚙️ Config & Dotfiles
-- =========================================
local config_files = {
  { "n", "<leader>vc", ":e ~/.config/nvim/init.lua<CR>", "Edit init.lua" },
  { "n", "<leader>vl", ":e ~/.config/nvim/lua/config/lazy.lua<CR>", "Edit lazy.lua" },
  { "n", "<leader>vk", ":e ~/.config/nvim/lua/config/keymaps.lua<CR>", "Edit keymaps.lua" },
  { "n", "<leader>vt", ":e ~/.config/nvim/lua/plugins/treesitter.lua<CR>", "Edit treesitter.lua" },
  { "n", "<leader>vz", ":e ~/.zshrc<CR>", "Edit zshrc" },
  { "n", "<leader>vtm", ":e ~/.tmux.conf<CR>", "Edit tmux.conf" },
  { "n", "<leader>vd", ":Neotree ~/.dotfiles reveal<CR>", "Open dotfiles" },
}

for _, map in ipairs(config_files) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- 🧩 LSP & Completion
-- =========================================
local lsp = {
  { "n", "K", vim.lsp.buf.hover, "Hover" },
  { "n", "gd", vim.lsp.buf.definition, "Go to definition" },
  { "n", "gr", vim.lsp.buf.references, "References" },
  { "n", "gi", vim.lsp.buf.implementation, "Implementation" },
  { "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol" },
  { "n", "<leader>ca", vim.lsp.buf.code_action, "Code action" },
  {
    "n",
    "<leader>cf",
    function()
      vim.lsp.buf.format({ async = true })
    end,
    "Format file",
  },
}

for _, map in ipairs(lsp) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- 🧹 Buffer Management
-- =========================================
local buffers = {
  { "n", "<leader>bn", ":bnext<CR>", "Next buffer" },
  { "n", "<leader>bp", ":bprevious<CR>", "Previous buffer" },
  { "n", "<leader>bd", ":bdelete<CR>", "Delete buffer" },
}

for _, map in ipairs(buffers) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- 🪶 Misc Utilities
-- =========================================
local misc = {
  { "n", "<leader>tt", ":ToggleTerm<CR>", "Toggle terminal" },
  { "t", "<Esc>", "<C-\\><C-n>", "Exit terminal mode" },
  { "n", "<leader>ss", ":StartupTime<CR>", "Startup time" },
}

for _, map in ipairs(misc) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- 🌲 Neo-tree Shortcuts
-- =========================================
local neo_tree = {
  { "n", "<leader>ef", ":Neotree reveal<CR>", "Reveal current file" },
  { "n", "<leader>er", ":Neotree refresh<CR>", "Refresh tree" },
}

for _, map in ipairs(neo_tree) do
  keymap(map[1], map[2], map[3], opts)
end

-- =========================================
-- 🧠 Brain-Box / Obsidian Notes Functions
-- =========================================
-- Reusable create_note function
local function create_note(base_dir, template_file, prompt_name, tag)
  local filename = vim.fn.input("New " .. prompt_name .. " name: ")
  if filename == "" then
    return print("Cancelled.")
  end

  local path = base_dir .. "/" .. filename .. ".md"
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

  if vim.fn.filereadable(template_file) == 0 then
    return print("Template not found: " .. template_file)
  end

  local template = vim.fn.readfile(template_file)
  local date = os.date("%d-%m-%Y")
  local time = os.date("%H:%M:%S")
  local title = vim.fn.fnamemodify(filename, ":t")

  for i, line in ipairs(template) do
    line = line:gsub("{{date}}", date)
    line = line:gsub("{{time}}", time)
    line = line:gsub("{{title}}", title)
    line = line:gsub("{{tag}}", tag or "")
    line = line:gsub("{{date:.-}}", date .. " " .. time)
    template[i] = line
  end

  vim.fn.writefile(template, path)
  vim.cmd("edit " .. path)
  vim.cmd("Neotree reveal")
end

-- Specific templates
local function create_learning_note()
  create_note(brain_box_path .. "/learning", brain_box_path .. "/_templates/learning.md", "Learning Note", "learning")
end

local function create_cheatsheet()
  create_note(
    brain_box_path .. "/cheatsheets",
    brain_box_path .. "/_templates/cheatsheet.md",
    "Cheatsheet",
    "cheatsheet"
  )
end

local function create_snippet()
  create_note(brain_box_path .. "/snippets", brain_box_path .. "/_templates/snippet.md", "Code Snippet", "snippet")
end

-- =========================================
-- 📦 Project Management Functions
-- =========================================
local function create_new_project_scaffold()
  local projects_path = brain_box_path .. "/projects"
  local project_name = vim.fn.input("Project name: ")
  if project_name == "" then
    return print("Cancelled")
  end

  local project_path = projects_path .. "/" .. project_name
  if vim.fn.isdirectory(project_path) == 1 then
    print("Project already exists: " .. project_name)
    vim.cmd("Neotree reveal " .. project_path)
    return
  end

  local structure = {
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

  for _, folder in ipairs(structure) do
    vim.fn.mkdir(project_path .. "/" .. folder, "p")
  end

  local date = os.date("%d-%m-%Y")
  local time = os.date("%H:%M:%S")
  local function frontmatter(title, type)
    return {
      "---",
      "title: " .. title,
      "project: " .. project_name,
      "type: " .. type,
      "created: " .. date .. " " .. time,
      "status: active",
      "tags: [project," .. project_name .. "]",
      "---",
      "",
    }
  end

  -- README.md
  local readme_path = project_path .. "/README.md"
  local readme = frontmatter("README", "readme")
  table.insert(readme, "# " .. project_name)
  table.insert(readme, "")
  table.insert(readme, "> Auto-generated scaffold.")
  vim.fn.writefile(readme, readme_path)

  -- index.md
  local index_path = project_path .. "/index.md"
  local index = frontmatter("Project Index", "index")
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
    "## 🧠 Learning Notes",
    "- [[brain-box/learning]]",
    "",
    "## 🔖 Tasks",
    "- [[tasks]]",
    "",
  })
  vim.fn.writefile(index, index_path)
  vim.cmd("edit " .. index_path)
  vim.cmd("Neotree reveal")
  print("Project scaffold created: " .. project_name)
end

local function add_project_task(project_name, task_desc, status)
  status = status or "[ ]"
  local project_path = brain_box_path .. "/projects/" .. project_name
  if vim.fn.isdirectory(project_path) == 0 then
    return print("❌ Project '" .. project_name .. "' does NOT exist.")
  end
  local tasks_path = project_path .. "/tasks.md"
  if vim.fn.filereadable(tasks_path) == 0 then
    vim.fn.writefile({ "# 📌 Project Task Log", "", "## Entries", "" }, tasks_path)
  end
  local timestamp = os.date("%Y-%m-%d %H:%M")
  vim.fn.writefile({ string.format("- %s %s %s", timestamp, status, task_desc) }, tasks_path, "a")
  vim.cmd("edit " .. tasks_path)
end

function _G.add_project_task_prompt()
  local projects_path = brain_box_path .. "/projects"
  local projects = {}
  for name in io.popen('ls -1 "' .. projects_path .. '"'):lines() do
    if vim.fn.isdirectory(projects_path .. "/" .. name) == 1 then
      table.insert(projects, name)
    end
  end

  print("Available projects:")
  for _, p in ipairs(projects) do
    print(" - " .. p)
  end
  local project = vim.fn.input("Project name: ")
  local valid = false
  for _, p in ipairs(projects) do
    if p == project then
      valid = true
    end
  end
  if not valid then
    return print("❌ Invalid project")
  end

  local task = vim.fn.input("Task description: ")
  if task == "" then
    return print("❌ No task entered")
  end
  add_project_task(project, task)
end

-- =========================================
-- 🌐 Browser Utility
-- =========================================
local function open_link_in_browser()
  local word = vim.fn.expand("<cWORD>")
  local url = word:match("(https?://[%w%-%._~:/%?#@!$&'()*+,;%%]+)")
  if not url then
    return print("⚠️ No valid URL under cursor.")
  end
  os.execute("open " .. url)
  print("🌐 Opening in browser: " .. url)
end

-- =========================================
-- 🗂 Leader-o / Which-Key Subdomains
-- =========================================
local wk_ok, which_key = pcall(require, "which-key")
if wk_ok then
  which_key.add({
    -- Main Brain-Box
    { "<leader>o", group = "Brain-Box / Obsidian", mode = "n" },

    -- NEW (n)
    { "<leader>on", group = "New", mode = "n" },
    { "<leader>onn", "<cmd>ObsidianNew<CR>", desc = "New Note" },
    { "<leader>ond", "<cmd>ObsidianToday<CR>", desc = "Daily Note" },
    { "<leader>ony", "<cmd>ObsidianYesterday<CR>", desc = "Yesterday Note" },
    { "<leader>onL", "<cmd>e " .. brain_box_path .. "/llnotes<CR>", desc = "Open llnotes" },
    { "<leader>onP", create_new_project_scaffold, desc = "New Project Scaffold" },
    { "<leader>ont", create_learning_note, desc = "New Learning Note" },
    { "<leader>onc", create_cheatsheet, desc = "New Cheatsheet" },
    { "<leader>ons", create_snippet, desc = "New Code Snippet" },

    -- ADD (a)
    { "<leader>oa", group = "Add", mode = "n" },
    { "<leader>oat", _G.add_project_task_prompt, desc = "Add Project Task" },

    -- LINKING (l)
    { "<leader>ol", group = "Linking", mode = "n" },
    { "<leader>oll", "<cmd>ObsidianLink<CR>", desc = "Link Note" },

    -- TEMPLATES (t)
    { "<leader>ot", group = "Templates", mode = "n" },
    { "<leader>otd", "<cmd>e " .. brain_box_path .. "/_templates/daily.md<CR>", desc = "Open daily template" },
    { "<leader>ots", "<cmd>e " .. brain_box_path .. "/_templates/slnote.md<CR>", desc = "Open slnote template" },
    {
      "<leader>otc",
      "<cmd>e " .. brain_box_path .. "/_templates/cheatsheet.md<CR>",
      desc = "Open cheatsheet template",
    },

    -- SEARCH (s)
    { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Search Vault", mode = "n" },

    -- OPEN ROOT (o)
    { "<leader>oo", "<cmd>e " .. brain_box_path .. "<CR>", desc = "Open Brain-Box Root", mode = "n" },

    -- BROWSER (b)
    { "<leader>ob", open_link_in_browser, desc = "Open Link in Browser", mode = "n" },
  })
end
