-- Telescope configuration
require("telescope").setup {
    defaults = {
    file_ignore_patterns = { ".git/", ".hg/", ".svn/", "tmp/", "node_modules/", "*.gif", "*.jpg", "*.jpeg", "*.png", "*.pyc" },
  },
  extensions = {
    smart_open = {
      -- Prioritize current directory by default
      cwd = vim.fn.expand('%:p:h'),  -- Use current file's directory
      -- Optional: Fallback to pwd if no file is open
      cwd_fallback = vim.fn.getcwd(),
      match_algorithm = "fzf", -- Use fzf-style matching
    },
  },
}

-- Load extension
require("telescope").load_extension("smart_open")

-- Custom commands
vim.api.nvim_create_user_command("GoToCommand", function()
  require("telescope.builtin").commands()
end, { nargs = 0 })

vim.api.nvim_create_user_command("GoToFile", function()
  require("telescope").extensions.smart_open.smart_open()
end, { nargs = 0 })

vim.api.nvim_create_user_command("GoToSymbol", function()
  require("telescope.builtin").lsp_document_symbols()
end, { nargs = 0 })

vim.api.nvim_create_user_command("Grep", function()
  require("telescope.builtin").live_grep()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SmartGoTo", function()
  require("telescope.builtin").find_files() -- Replace with your intent
end, { nargs = 0 })
