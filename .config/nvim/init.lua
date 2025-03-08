-- Load the configuration
require("config.lazy")

-- Print a message to confirm init.lua is being loaded
print("Loading init.lua...")

-- Check if mini.nvim modules are properly loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      require("config.mini_check").check_modules()
    end, 1000) -- Increased delay to ensure everything is loaded
  end,
  once = true,
})
