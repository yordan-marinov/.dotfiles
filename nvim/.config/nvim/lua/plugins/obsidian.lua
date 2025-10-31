return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp", -- Optional for completion
    "nvim-treesitter/nvim-treesitter", -- Optional for syntax highlighting
  },
  config = function()
    require("obsidian").setup({
      -- Specify the root vault directory
      dir = "~/Google Drive/My Drive/brain-box", -- Path to your vault

      -- Folder where all notes will be saved
      notes_subdir = "slnotes", -- Ensure new notes are stored in 'slnotes/' folder

      -- Set how new notes should be stored
      new_notes_location = "slnotes", -- Store notes in 'slnotes/' folder

      -- Configure daily notes if needed
      daily_notes = {
        folder = "dailies", -- Store daily notes in 'dailies' folder
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "daily.md",
        default = "dailies",
      },

      -- Optional, for templates (see below).
      templates = {
        folder = "templates",
        default = "default",
        date_format = "%d-%m-%Y",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        nvim_cmp = true,
        min_chars = 2,
        default = "default",
      },

      -- Function for generating note IDs (file names)
      note_id_func = function(title)
        if not title or title == "" then
          return tostring(os.time()) -- Ensure it always returns a single value
        end

        local formatted_title = title
          :gsub("[^A-Za-z0-9%s]", "") -- Remove special characters except spaces
          :gsub("(%a)([%w]*)", function(first, rest)
            return first:upper() .. rest:lower() -- Capitalize each word
          end)
          :gsub("%s+", " ")

        return formatted_title
      end,

      -- Optional, customize frontmatter for the note
      note_frontmatter_func = function(note)
        local title = note.id
        local frontmatter = {
          title = title, -- Use the filename as the title
          created = os.date("%d-%m-%Y %H:%M:%S"), -- Timestamp
        }
        return frontmatter
      end,
    })
  end,
}
