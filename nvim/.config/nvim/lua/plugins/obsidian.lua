local function brainbox_path()
  if os.getenv("BRAINBOX_PATH") then
    return os.getenv("BRAINBOX_PATH")
  end
  if vim.loop.os_uname().sysname == "Darwin" then
    return "/Volumes/brainbox/vault"
  end
  return vim.fn.expand("$HOME/Google Drive/My Drive/brain-box")
end

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  -- setup() raises FileNotFoundError on every start when the vault isn't
  -- mounted, e.g. on a work laptop.
  cond = function()
    return vim.fn.isdirectory(brainbox_path()) == 1
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("obsidian").setup({
      dir = brainbox_path(),

      notes_subdir = "slnotes",
      new_notes_location = "slnotes",

      daily_notes = {
        folder = "dailies",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily" },
        template = "daily.md",
      },

      templates = {
        folder = "_templates",
        date_format = "%d-%m-%Y",
        time_format = "%H:%M",
      },

      -- LazyVim completes with blink.cmp; pulling nvim-cmp back in for this
      -- (archived) plugin made the `lang.git` extra's nvim-cmp spec crash at startup.
      completion = { nvim_cmp = false },

      note_id_func = function(title)
        if not title or title == "" then
          return tostring(os.time())
        end
        local safe_title = title:gsub("%s+", "_"):gsub("[^A-Za-z0-9_%-]", "")
        return safe_title
      end,

      note_frontmatter_func = function(note)
        return {
          title = note.id,
          created = os.date("%d-%m-%Y %H:%M:%S"),
          tags = note.tags or { "note" },
        }
      end,

      open_notes_in = "current",
      disable_frontmatter = false,
    })
  end,
}
