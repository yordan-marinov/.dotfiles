-- =========================================
-- 🧠 Brain-Box | Neovim Keymaps (Google Drive Synced)
-- =========================================

-- Shorten function name
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key (space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =========================================
-- 🚀 General
-- =========================================
keymap("n", "<leader>nh", ":nohlsearch<CR>", opts) -- clear search highlights
keymap("n", "<leader>q", ":qa<CR>", opts) -- quit all
keymap("n", "<leader>wf", ":w<CR>", opts) -- save file
keymap("i", "jj", "<Esc>", opts) -- exit insert mode
keymap("n", "<leader>so", ":source %<CR>", opts) -- source current file

-- =========================================
-- 🪟 Window / Split Management
-- =========================================
keymap("n", "<leader>sv", "<C-w>v", opts) -- split vertically
keymap("n", "<leader>sh", "<C-w>s", opts) -- split horizontally
keymap("n", "<leader>se", "<C-w>=", opts) -- equalize splits
keymap("n", "<leader>sx", ":close<CR>", opts) -- close current split

-- Move between splits (works with tmux navigator)
keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", opts)
keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", opts)
keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", opts)

-- =========================================
-- 📁 File Explorer & Telescope
-- =========================================
keymap("n", "<leader>e", ":Neotree toggle<CR>", opts) -- toggle Neo-tree
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- =========================================
-- 🧱 Obsidian / Brain-Box Notes
-- =========================================
keymap("n", "<leader>on", ":ObsidianNew<CR>", opts) -- new note
keymap("n", "<leader>ot", ":ObsidianToday<CR>", opts) -- daily note (today)
keymap("n", "<leader>oy", ":ObsidianYesterday<CR>", opts) -- daily note (yesterday)
keymap("n", "<leader>os", ":ObsidianSearch<CR>", opts) -- search in vault
keymap("n", "<leader>ol", ":ObsidianLink<CR>", opts) -- link current note

-- =========================================
-- 🗂️ Brain-Box | Folder Access (Neo-tree)
-- =========================================
-- Opens Neo-tree directly inside Brain-Box folders synced with Google Drive
local brain_box_path = "/Users/yordan/Google Drive/My Drive/brain-box"

keymap("n", "<leader>nb", ":Neotree " .. brain_box_path .. " reveal<CR>", opts) -- open main brain-box
keymap("n", "<leader>nn", ":Neotree " .. brain_box_path .. "/notes reveal<CR>", opts) -- general notes
keymap("n", "<leader>nd", ":Neotree " .. brain_box_path .. "/dailies reveal<CR>", opts) -- daily notes
keymap("n", "<leader>nl", ":Neotree " .. brain_box_path .. "/learning reveal<CR>", opts) -- learning notes
keymap("n", "<leader>ns", ":Neotree " .. brain_box_path .. "/slnotes reveal<CR>", opts) -- study/lab notes
keymap("n", "<leader>nc", ":Neotree " .. brain_box_path .. "/cheatsheets reveal<CR>", opts) -- cheatsheets folder

-- =========================================
-- ⚙️ Config & Dotfiles Shortcuts
-- =========================================
keymap("n", "<leader>vc", ":e ~/.config/nvim/init.lua<CR>", opts)
keymap("n", "<leader>vl", ":e ~/.config/nvim/lua/config/lazy.lua<CR>", opts)
keymap("n", "<leader>vk", ":e ~/.config/nvim/lua/config/keymaps.lua<CR>", opts)
keymap("n", "<leader>vt", ":e ~/.config/nvim/lua/plugins/treesitter.lua<CR>", opts)
keymap("n", "<leader>vz", ":e ~/.zshrc<CR>", opts)
keymap("n", "<leader>tm", ":e ~/.tmux.conf<CR>", opts)

-- =========================================
-- 🧩 LSP & Completion
-- =========================================
keymap("n", "K", vim.lsp.buf.hover, opts)
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "gr", vim.lsp.buf.references, opts)
keymap("n", "gi", vim.lsp.buf.implementation, opts)
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)

-- =========================================
-- 🪶 Misc Utilities
-- =========================================
keymap("n", "<leader>tt", ":ToggleTerm<CR>", opts) -- toggle terminal
keymap("t", "<Esc>", "<C-\\><C-n>", opts) -- exit terminal mode
keymap("n", "<leader>ss", ":StartupTime<CR>", opts) -- check startup time

-- =========================================
-- 🧹 Buffer Management
-- =========================================
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)
