return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle left<CR>", desc = "Toggle file explorer" },
    { "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal current file in explorer" },
  },
  opts = {
    close_if_last_window = true, -- Auto-close if it's the last open window
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false,

    default_component_configs = {
      indent = { padding = 1 },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "󰜌",
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "➜",
          untracked = "★",
          ignored = "◌",
          unstaged = "✗",
          staged = "✓",
          conflict = "",
        },
      },
    },

    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files (toggle with '.')
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true, -- Focus tree on the current file automatically
      },
      group_empty_dirs = true,
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true,
    },

    window = {
      position = "left",
      width = 35,
      mappings = {
        ["<space>"] = "none", -- disable space toggle
        ["<cr>"] = "open", -- open file
        ["l"] = "open",
        ["h"] = "close_node",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["a"] = { "add", config = { show_path = "none" } },
        ["d"] = "delete",
        ["r"] = "rename",
        ["c"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["."] = "toggle_hidden",
      },
    },
  },
}
