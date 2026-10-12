-- bash-language-server and shellcheck come from the `util.dot` extra; bashls
-- runs shellcheck itself, so no separate nvim-lint linter (it would double
-- every warning).
return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      -- Indent width comes from the buffer's shiftwidth (2 for shell, see
      -- config/options.lua): conform passes `-i <shiftwidth>` itself, after
      -- these. `-ci` indents `case` arms, the style these scripts are in.
      shfmt = { prepend_args = { "-ci" } },
    },
  },
}
