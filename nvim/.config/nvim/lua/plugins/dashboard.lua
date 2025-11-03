return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    --  Custom ASCII art header
    dashboard.section.header.val = {
      [[░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓███████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓██████████████▓▒░]],
      [[░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░]],
      [[░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░]],
      [[ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░]],
      [[   ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░]],
      [[   ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░]],
      [[   ░▒▓█▓▒░    ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░]],
      [[                                                                                                    ]],
      [[                                                                                                    ]],
      [[                                       Think. Learn. Build.                                         ]],
      [[                                                                                                    ]],
    }

    -- 📁 Base directory
    local brain_box = "/Users/yordan/Google Drive/My Drive/brain-box"

    -- helper: safely open a directory with Oil.nvim if available
    local function open_dir(dir)
      dir = vim.fn.fnameescape(dir)
      if pcall(require, "oil") then
        return string.format("<cmd>Oil %s<CR>", dir)
      else
        return string.format("<cmd>edit %s<CR>", dir)
      end
    end

    -- 🧭 Buttons
    dashboard.section.buttons.val = {
      dashboard.button("e", "  New File", "<cmd>ene <CR>"),
      dashboard.button("d", "📓  Dailies", open_dir(brain_box .. "/dailies")),
      dashboard.button("s", "⚡  Short Live Notes", open_dir(brain_box .. "/slnotes")),
      dashboard.button("l", "📘  Long Live Notes", open_dir(brain_box .. "/llnotes")),
      dashboard.button("n", "🧩  Learning", open_dir(brain_box .. "/learning")),
      dashboard.button("p", "💼  Projects", open_dir(brain_box .. "/projects")),
      dashboard.button("c", "🧾  Cheatsheets", open_dir(brain_box .. "/cheatsheets")),
      dashboard.button("m", "🧠  Media Notes", open_dir(brain_box .. "/mnotes")),
      dashboard.button("t", "🧰  Templates", open_dir(brain_box .. "/_templates")),
      dashboard.button("x", "✂️  Code Snippets", open_dir(brain_box .. "/snippets")),
      dashboard.button("v", "🔧  Neovim Config", "<cmd>edit ~/.config/nvim/init.lua<CR>"),
      dashboard.button("o", "🗂️  Obsidian Config", "<cmd>edit ~/.config/nvim/lua/plugins/obsidian.lua<CR>"),
      dashboard.button("f", "⚙️  Dotfiles", "<cmd>edit ~/.dotfiles<CR>"),
      dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
    }

    -- 🗨️ Footer fortune or fallback message
    local handle = io.popen("fortune 2>/dev/null")
    local fortune = handle and handle:read("*a") or "Welcome back, Commander Yordan 🧠"
    if handle then
      handle:close()
    end
    dashboard.section.footer.val = fortune

    -- setup
    alpha.setup(dashboard.config)
  end,
}
