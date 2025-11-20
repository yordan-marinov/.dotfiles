-- ============================================
-- Lazy.nvim Bootstrap & Setup
-- Author: YordanM 🧠 "Brain Box"
-- ============================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "❌ Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { "Press any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================
-- Lazy Setup Configuration
-- ============================================
require("lazy").setup({
  spec = {
    -- 🧩 Base LazyVim plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 🧠 Your personal plugin collection
    { import = "plugins" },
  },

  defaults = {
    lazy = false,
    version = false,
  },

  install = {
    colorscheme = { "tokyonight", "catppuccin", "habamax" },
  },

  ui = {
    border = "rounded",
    size = { width = 0.9, height = 0.9 },
    wrap = true,
  },

  checker = {
    enabled = true,
    notify = false,
    frequency = 3600,
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
        "netrwPlugin",
        "tutor",
      },
    },
  },
})

-- ============================================
-- Load Custom Configs (autocmds, keymaps, options)
-- ============================================
local ok, _ = pcall(function()
  require("config.autocmds")
  require("config.keymaps")
  require("config.options")
end)

if not ok then
  vim.notify("⚠️ Failed to load some config modules", vim.log.levels.WARN)
end

-- ============================================
-- Friendly Startup Message
-- ============================================
vim.schedule(function()
  vim.notify("🚀 Brain Box ready, YordanM!", vim.log.levels.INFO, { title = "LazyVim" })
end)
