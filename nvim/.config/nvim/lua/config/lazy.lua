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

    -- Optionally import specific groups
    -- { import = "plugins.ui" },
    -- { import = "plugins.coding" },
    -- { import = "plugins.obsidian" },
  },

  defaults = {
    lazy = false, -- load your custom plugins immediately (set true to lazy-load)
    version = false, -- always use latest git commit
  },

  install = {
    -- choose default colorschemes
    colorscheme = { "tokyonight", "catppuccin", "habamax" },
  },

  ui = {
    border = "rounded",
    size = { width = 0.9, height = 0.9 },
    wrap = true,
  },

  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- disable annoying notifications
    frequency = 3600, -- check every hour
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
-- Optional: Start Alpha Dashboard if no file
-- ============================================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      local ok, alpha = pcall(require, "alpha")
      if ok then
        alpha.start(true)
      else
        vim.notify("Alpha not found – skipping dashboard", vim.log.levels.WARN)
      end
    end
  end,
})

-- ============================================
-- Friendly Startup Message
-- ============================================
vim.schedule(function()
  vim.notify("🚀 Brain Box ready, YordanM!", vim.log.levels.INFO, { title = "LazyVim" })
end)
