return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("obsidian").setup({
      dir = "~/Google Drive/My Drive/brain-box",
      notes_subdir = "slnotes",
      new_notes_location = "slnotes",
      daily_notes = {
        folder = "dailies",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "daily.md",
      },
      templates = {
        folder = "_templates",
        date_format = "%d-%m-%Y",
        time_format = "%H:%M",
      },
      completion = { nvim_cmp = true, min_chars = 2 },
      note_id_func = function(title)
        if not title or title == "" then
          return tostring(os.time())
        end
        return (title:gsub("[^A-Za-z0-9%s]", ""):gsub("%s+", " "))
      end,
      note_frontmatter_func = function(note)
        return {
          title = note.id,
          created = os.date("%d-%m-%Y %H:%M:%S"),
        }
      end,
    })
  end,
}
