return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
  opts = {
    auto_refresh = true, -- Refresh the venv list automatically
  },
  config = function()
    require("venv-selector").setup()

    -- Automatically select venv from current project (if available)
    vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      callback = function()
        local venv = vim.fn.findfile("pyproject.toml", ".;") or vim.fn.findfile("requirements.txt", ".;")
        if venv ~= "" then
          require("venv-selector").retrieve_from_cache()
        end
      end,
    })

    -- Keymaps for managing venvs
    vim.api.nvim_set_keymap("n", "<leader>pv", ":VenvSelect<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>pc", ":VenvSelectCached<CR>", { noremap = true, silent = true })
  end,
}
