-- Python on top of LazyVim's `lang.python` extra (pyright + ruff), tuned for
-- uv projects: every tool resolves through the project's `.venv` first, so the
-- editor enforces the same ruff version and sees the same packages as
-- `uv run` and pre-commit do.
local project = require("config.project")

local function ruff(ctx)
  return project.venv_bin(ctx.dirname, "ruff") or "ruff"
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- Without this pyright analyses against whatever `python3` is on PATH
          -- and reports every third-party and workspace import as unresolved.
          -- Mutated in place: the client already holds this settings table and
          -- answers pyright's workspace/configuration requests from it.
          before_init = function(_, config)
            local python = config.root_dir and project.venv_bin(config.root_dir, "python")
            if python and config.settings then
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = python
            end
          end,
        },
        ruff = {
          -- The project's pinned ruff, falling back to Mason's: a different
          -- version enables or drops rules under `select = ["ALL"]`.
          cmd = function(dispatchers, config)
            local bin = config and config.root_dir and project.venv_bin(config.root_dir, "ruff")
            return vim.lsp.rpc.start({ bin or "ruff", "server" }, dispatchers, {
              cwd = config and config.root_dir,
            })
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Same order as the pre-commit hooks: sort imports, then format.
        python = { "ruff_organize_imports", "ruff_format" },
      },
      formatters = {
        ruff_organize_imports = { command = ruff },
        ruff_format = { command = ruff },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "debugpy" } },
  },
  {
    -- LazyVim's own spec wires it; this only keeps the old <leader>p* keys.
    "linux-cultist/venv-selector.nvim",
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
      { "<leader>pc", "<cmd>VenvSelectCached<cr>", desc = "Activate Cached VirtualEnv", ft = "python" },
    },
  },
}
