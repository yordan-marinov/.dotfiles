return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    -- Python Debugger Setup (ensure debugpy is installed)
    dap.adapters.python = {
      type = "executable",
      command = "/usr/local/bin/python3", -- Ensure this points to your Python 3 executable
      args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch Python File",
        program = "${file}", -- Launch the current file
      },
    }

    -- Add more configurations for other languages if needed
  end,
}
