-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "python",
    "bash",
    "markdown",
    "markdown_inline",
    "sql",
    "vimdoc",
    "javascript",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  sync_install = false,
  auto_install = true,
  ignore_install = { "haskell", "latex" },
  modules = {},
})
