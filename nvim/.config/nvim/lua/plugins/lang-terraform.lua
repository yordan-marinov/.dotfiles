-- OpenTofu-first Terraform on top of the `lang.terraform` extra.
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- First available wins: `tofu fmt` where OpenTofu is installed.
        terraform = { "tofu_fmt", "terraform_fmt", stop_after_first = true },
        ["terraform-vars"] = { "tofu_fmt", "terraform_fmt", stop_after_first = true },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- `validate` needs an initialised working directory (providers, modules)
      -- and reports one error per file until `init` has run; terraform-ls
      -- already reports the same syntax and reference errors without it.
      linters_by_ft = { terraform = {}, tf = {} },
    },
  },
}
