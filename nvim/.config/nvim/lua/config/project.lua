-- Per-project lookups shared by the language specs, plus filetype detection
-- Neovim gets wrong out of the box. Required from config/lazy.lua before
-- lazy.setup(), so filetypes are registered before the first buffer opens.
local M = {}

-- `<venv>/bin/<exe>` from the nearest `.venv` above `path` (what `uv sync`
-- creates), or nil. Lets tools run at the version the project pins instead of
-- Mason's.
function M.venv_bin(path, exe)
  local venv = vim.fs.find(".venv", { upward = true, path = path, type = "directory" })[1]
  local bin = venv and (venv .. "/bin/" .. exe)
  return bin and vim.fn.executable(bin) == 1 and bin or nil
end

-- `line-length` the formatter will use for files under `path`, found the way
-- ruff resolves its config: the nearest ruff.toml, or pyproject.toml that has
-- a [tool.ruff] (or [tool.black]) table. A workspace member's own
-- pyproject.toml without one defers to the root's. 88 (ruff's and black's
-- default) when nothing sets it.
function M.python_line_length(path)
  local configs = vim.fs.find(
    { "ruff.toml", ".ruff.toml", "pyproject.toml" },
    { upward = true, path = path, limit = math.huge }
  )
  for _, config in ipairs(configs) do
    local lines = vim.fn.readfile(config)
    local text = table.concat(lines, "\n")
    local is_ruff_toml = not vim.endswith(config, "pyproject.toml")
    if is_ruff_toml or text:find("%[tool%.ruff") or text:find("%[tool%.black") then
      for _, line in ipairs(lines) do
        local n = line:match("^%s*line%-length%s*=%s*(%d+)")
        if n then
          return tonumber(n)
        end
      end
      return 88
    end
  end
  return 88
end

vim.filetype.add({
  extension = {
    -- Neovim maps .tf to TinyFugue (`tf`), which no Terraform/OpenTofu server attaches to.
    tf = "terraform",
    tofu = "terraform",
    tfvars = "terraform-vars",
    excalidraw = "json",
    -- Jinja templates; the rendered language is injected by
    -- after/queries/jinja/injections.scm.
    j2 = "jinja",
  },
  filename = {
    [".reviewignore"] = "gitignore",
  },
  pattern = {
    ["Dockerfile%..+"] = "dockerfile",
  },
})

-- `foo.sql.j2` -> "sql": the treesitter language of the file a template renders
-- to, set as the injection language for the template's literal text.
vim.treesitter.query.add_directive("set-j2-host!", function(_, _, source, _, metadata)
  if type(source) ~= "number" then
    return
  end
  local rendered = vim.api.nvim_buf_get_name(source):gsub("%.j2$", "")
  local ft = vim.filetype.match({ filename = rendered })
  local lang = ft and vim.treesitter.language.get_lang(ft)
  if lang and lang ~= "jinja" then
    metadata["injection.language"] = lang
  end
end, { force = true })

return M
