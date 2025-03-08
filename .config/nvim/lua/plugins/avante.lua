return {
  -- Avante.nvim - AI assistant powered by Claude
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("avante").setup({
        -- Use Claude as the provider
        provider = "claude",
        debug = false,
        custom_tools = {},
        auto_suggestions_provider = "claude",


        -- Claude API configuration
        claude = {
          -- You'll need to set your API key in an environment variable
          -- or directly here (not recommended for security reasons)
          api_key = vim.env.ANTHROPIC_API_KEY,

          -- Default model to use
          model = "claude-3-5-sonnet-latest",
        },

        -- UI configuration
        ui = {
          -- Width of the Avante window (percentage or absolute)
          width = "40%",

          -- Height of the Avante window (percentage or absolute)
          height = "60%",

          -- Position of the Avante window
          position = "right", -- "right", "left", "top", "bottom"

          -- Border style
          border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"

          -- Highlight group for the window
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },

        -- Keymaps
        keymaps = {
          -- Toggle Avante window
          toggle = "<leader>a",

          -- Submit prompt
          submit = "<C-s>",

          -- Clear conversation
          clear = "<C-l>",

          -- Close window
          close = "q",

          -- Scroll up/down
          scroll_up = "<C-b>",
          scroll_down = "<C-f>",
        },

        -- Inline completion settings
        inline = {
          -- Enable inline completions
          enable = true,

          -- Auto-trigger inline completions
          auto_trigger = true,

          -- Debounce time in milliseconds
          debounce = 100,

          -- Keymaps for inline completions
          keymaps = {
            accept = "<M-l>",
            accept_word = "<M-w>",
            accept_line = "<M-o>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },

        -- Context settings
        context = {
          -- Include current buffer in context
          include_current_buffer = true,

          -- Include current line in context
          include_current_line = true,

          -- Include current selection in context
          include_current_selection = true,

          -- Include cursor position in context
          include_cursor_position = true,
        },

        -- Filetype-specific settings
        filetypes = {
          -- Disable for certain filetypes
          yaml = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      })

      -- Add a keybinding to toggle inline completions
      vim.keymap.set("n", "<leader>ti", function()
        local avante = require("avante")
        local current = avante.config.inline.auto_trigger
        avante.config.inline.auto_trigger = not current
        if avante.config.inline.auto_trigger then
          vim.notify("Avante inline completions enabled", vim.log.levels.INFO)
        else
          vim.notify("Avante inline completions disabled", vim.log.levels.INFO)
        end
      end, { desc = "Toggle Avante inline completions" })
    end,
  },
}
