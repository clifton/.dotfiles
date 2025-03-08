return {
  -- mini.pick for file finding and other functionality
  {
    "echasnovski/mini.nvim",
    keys = {
      { "<C-p>", function() require('mini.pick').builtin.files({ include_hidden = false }) end, desc = "Find files (cwd)" },
      { "<leader>f", function() require('mini.pick').builtin.files({ include_hidden = true }) end, desc = "Find files" },
      { "<leader>.", function() require('mini.pick').builtin.files({ filter = function(path) return vim.fn.filereadable(path) == 1 and vim.fn.getftime(path) > 0 end }) end, desc = "Recent files" },
      { "<leader>gb", function() require('mini.pick').builtin.buffers() end, desc = "Buffers" },
      { "<leader>gf", function()
        local current_file = vim.fn.expand('%:p:h')
        require('mini.pick').builtin.files({ cwd = current_file })
      end, desc = "Find files (file dir)" },
      { "<leader>gv", function()
        local views_dir = vim.fn.getcwd() .. "/app/views"
        if vim.fn.isdirectory(views_dir) == 1 then
          require('mini.pick').builtin.files({ cwd = views_dir })
        else
          vim.notify("Views directory not found", vim.log.levels.WARN)
        end
      end, desc = "Find views" },
      { "<leader>rg", function() require('mini.pick').builtin.grep_live() end, desc = "Live grep" },

      -- Additional useful mini.pick mappings
      { "<leader>h", function() require('mini.pick').builtin.help() end, desc = "Help pages" },
      { "<leader>/", function() require('mini.pick').builtin.grep({ pattern = vim.fn.input("Grep pattern: ") }) end, desc = "Grep" },
      { "<leader>:", function() require('mini.pick').builtin.commands() end, desc = "Commands" },
      { "<leader>k", function() require('mini.pick').builtin.keymaps() end, desc = "Keymaps" },
      { "<leader>z", function() require('mini.pick').builtin.resume() end, desc = "Resume last picker" },
    },
    config = function()
      -- mini.pick configuration is in mini.lua
    end,
  },
}