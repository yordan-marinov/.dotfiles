-- Extends LazyVim's nvim-treesitter (`main` branch) spec. Never set `config` here:
-- it replaces LazyVim's setup, which is what installs parsers and starts
-- highlighting, and the old `nvim-treesitter.configs` module no longer exists.
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    -- Appended to LazyVim's list (`opts_extend`), not replacing it.
    ensure_installed = {
      "sql",
      "terraform",
      "hcl",
      "dockerfile",
      "make",
      "jinja",
      "jinja_inline",
      "gitignore",
      "ini",
    },
  },
}
