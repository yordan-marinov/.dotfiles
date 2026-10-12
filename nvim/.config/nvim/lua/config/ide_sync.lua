-- :IdeSync installs every Mason package (LSP servers, linters, formatters, DAP
-- adapters) and treesitter parser this config asks for, and blocks until done.
-- Normally they install lazily, in the background, the first time a matching
-- file opens; this lets bootstrap.sh provision a machine up front:
--
--   nvim --headless "+Lazy! restore" +IdeSync +qa
--
-- Lists are read from the merged plugin specs, so a language added under
-- lua/plugins/ needs no change here.

local TIMEOUT_MS = 15 * 60 * 1000

local function mason_packages()
  -- tree-sitter-cli builds the parsers below; nvim-treesitter `main` needs it.
  local wanted = { ["tree-sitter-cli"] = true }
  for _, name in ipairs(LazyVim.opts("mason.nvim").ensure_installed or {}) do
    wanted[name] = true
  end
  -- Servers are listed by lspconfig name; Mason knows them by package name.
  local to_package = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
  for server, sopts in pairs(LazyVim.opts("nvim-lspconfig").servers or {}) do
    local enabled = sopts == true or (type(sopts) == "table" and sopts.enabled ~= false and sopts.mason ~= false)
    if enabled and to_package[server] then
      wanted[to_package[server]] = true
    end
  end
  local names = vim.tbl_keys(wanted)
  table.sort(names)
  return names
end

local function install_mason(names)
  local registry = require("mason-registry")
  local refreshed = false
  registry.refresh(function()
    refreshed = true
  end)
  vim.wait(TIMEOUT_MS, function()
    return refreshed
  end, 200)

  local pkgs, failed = {}, {}
  for _, name in ipairs(names) do
    local ok, pkg = pcall(registry.get_package, name)
    if not ok then
      table.insert(failed, name .. " (not in registry)")
    else
      table.insert(pkgs, pkg)
      -- LazyVim's mason.nvim config may already be installing it in the
      -- background; a second install() on the same package throws.
      if not pkg:is_installed() and not pkg:is_installing() then
        print("mason: installing " .. name)
        pkg:install()
      end
    end
  end
  vim.wait(TIMEOUT_MS, function()
    return not vim.iter(pkgs):any(function(pkg)
      return pkg:is_installing()
    end)
  end, 500)
  for _, pkg in ipairs(pkgs) do
    if not pkg:is_installed() then
      table.insert(failed, pkg.name)
    end
  end
  return failed
end

local function install_parsers()
  local langs = LazyVim.opts("nvim-treesitter").ensure_installed or {}
  local cli_ready, cli_err = nil, nil
  LazyVim.treesitter.ensure_treesitter_cli(function(ok, err)
    cli_ready, cli_err = ok, err
  end)
  vim.wait(TIMEOUT_MS, function()
    return cli_ready ~= nil
  end, 200)
  if not cli_ready then
    return { "treesitter (" .. (cli_err or "tree-sitter CLI unavailable") .. ")" }
  end
  local ok, err = require("nvim-treesitter").install(langs, { summary = true }):wait(TIMEOUT_MS)
  return ok == false and { "treesitter (" .. tostring(err) .. ")" } or {}
end

vim.api.nvim_create_user_command("IdeSync", function()
  require("lazy").load({ plugins = { "mason.nvim", "mason-lspconfig.nvim", "nvim-treesitter" } })
  local failed = install_mason(mason_packages())
  vim.list_extend(failed, install_parsers())
  if #failed > 0 then
    -- Non-zero exit, so a bootstrap run can tell a partial install from a clean one.
    vim.api.nvim_echo({ { "IdeSync failed: " .. table.concat(failed, ", ") .. "\n" } }, true, { err = true })
    if #vim.api.nvim_list_uis() == 0 then
      vim.cmd("cquit 1")
    end
  else
    print("IdeSync: all Mason packages and treesitter parsers installed")
  end
end, { desc = "Install all Mason packages and treesitter parsers, blocking" })
