-- markdownlint-cli2 from the `lang.markdown` extra, with a default rule set
-- (global.markdownlint-cli2.yaml) for repos that have none. A repo's own
-- config, found upward from the file, always wins.
local PROJECT_CONFIGS = {
  ".markdownlint-cli2.yaml",
  ".markdownlint-cli2.jsonc",
  ".markdownlint-cli2.cjs",
  ".markdownlint-cli2.mjs",
  ".markdownlint.yaml",
  ".markdownlint.yml",
  ".markdownlint.jsonc",
  ".markdownlint.json",
}

local function config_for(dir)
  return vim.fs.find(PROJECT_CONFIGS, { upward = true, path = dir })[1]
    or (vim.fn.stdpath("config") .. "/global.markdownlint-cli2.yaml")
end

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            function()
              return config_for(vim.fn.expand("%:p:h"))
            end,
            "-",
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          args = function(_, ctx)
            return { "--fix", "--config", config_for(ctx.dirname), "$FILENAME" }
          end,
        },
      },
    },
  },
}
