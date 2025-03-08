return {
  -- mini.pick for file finding and other functionality
  {
    "echasnovski/mini.nvim",
    lazy = false,  -- Ensure this plugin loads immediately
    priority = 50, -- Give it a higher priority to load early
    keys = {
      {
        "<C-p>",
        function()
          require('mini.pick').builtin.files({
            show_hidden = true,
          })
        end,
        desc = "Find files (cwd)"
      },

      {
        "<leader>f",
        function()
          require('mini.pick').builtin.files({
            show_hidden = true,
          })
        end,
        desc = "Find files"
      },

      {
        "<leader>.",
        function()
          require('mini.pick').builtin.files({
            show_hidden = true,
            filter = function(path)
              return vim.fn.filereadable(path) == 1 and vim.fn.getftime(path) > 0
            end
          })
        end,
        desc = "Recent files"
      },

      {
        "<leader>gb",
        function()
          require('mini.pick').builtin.buffers()
        end,
        desc = "Buffers"
      },

      {
        "<leader>gf",
        function()
          local current_file = vim.fn.expand('%:p:h')
          require('mini.pick').builtin.files({
            show_hidden = true,
            cwd = current_file
          })
        end,
        desc = "Find files (file dir)"
      },

      {
        "<leader>gv",
        function()
          local views_dir = vim.fn.getcwd() .. "/app/views"
          if vim.fn.isdirectory(views_dir) == 1 then
            require('mini.pick').builtin.files({
              show_hidden = true,
              cwd = views_dir
            })
          else
            vim.notify("Views directory not found", vim.log.levels.WARN)
          end
        end,
        desc = "Find views"
      },

      {
        "<leader>rg",
        function()
          require('mini.pick').builtin.grep_live({
            show_hidden = true,
          })
        end,
        desc = "Live grep"
      },

      -- Additional useful mini.pick mappings
      {
        "<leader>h",
        function()
          require('mini.pick').builtin.help()
        end,
        desc = "Help pages"
      },

      {
        "<leader>/",
        function()
          require('mini.pick').builtin.grep({
            show_hidden = true,
            pattern = vim.fn.input("Grep pattern: ")
          })
        end,
        desc = "Grep"
      },

      {
        "<leader>:",
        function()
          require('mini.pick').builtin.commands()
        end,
        desc = "Commands"
      },

      {
        "<leader>k",
        function()
          require('mini.pick').builtin.keymaps()
        end,
        desc = "Keymaps"
      },

      {
        "<leader>z",
        function()
          require('mini.pick').builtin.resume()
        end,
        desc = "Resume last picker"
      },

      -- Add a specific mapping for showing all files including hidden ones
      {
        "<leader>fa",
        function()
          require('mini.pick').builtin.files({
            show_hidden = true,
            git_ignore = false,
          })
        end,
        desc = "Find all files (including hidden)"
      },
    },
    config = function()
      -- Ensure mini.pick shows hidden files by default
      local pick_builtin = require('mini.pick').builtin
      local original_files = pick_builtin.files

      pick_builtin.files = function(opts)
        opts = opts or {}
        if opts.show_hidden == nil then
          opts.show_hidden = true
        end
        return original_files(opts)
      end

      -- Create a simple PickFiles command
      vim.api.nvim_create_user_command('PickFiles', function()
        require('mini.pick').builtin.files({ show_hidden = true })
      end, { desc = 'Open mini.pick file finder' })

      -- Simple startup handler for +PickFiles
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Check if we were called with +PickFiles
          for _, arg in ipairs(vim.v.argv) do
            if arg == "+PickFiles" then
              -- Use a timer to ensure this runs after everything is loaded
              vim.fn.timer_start(100, function()
                require('mini.pick').builtin.files({ show_hidden = true })
              end)
              break
            end
          end
        end,
        once = true,
      })
    end,
  },
}
