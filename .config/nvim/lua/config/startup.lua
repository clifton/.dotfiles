-- Module for handling startup commands
local M = {}

-- Handle the +PickFiles command
function M.handle_pick_files_command()
  -- Check if we were called with +PickFiles
  local args = vim.v.argv
  for i, arg in ipairs(args) do
    if arg == "+PickFiles" or arg:match("^%+PickFiles ") then
      -- Extract arguments
      local cmd_args = ""
      if arg:match("^%+PickFiles ") then
        cmd_args = arg:gsub("^%+PickFiles ", "")
      elseif i < #args and args[i+1] and not args[i+1]:match("^%+") and not args[i+1]:match("^%-") then
        cmd_args = args[i+1]
      end

      -- Set up VimEnter autocmd to run the command after Neovim is fully loaded
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Try to run the PickFiles command
          vim.defer_fn(function()
            if vim.fn.exists(":PickFiles") == 2 then
              vim.cmd("PickFiles " .. cmd_args)
            else
              -- Fallback to directly using mini.pick if available
              local ok, mini_pick = pcall(require, 'mini.pick')
              if ok then
                -- Parse arguments
                local pick_opts = { show_hidden = true }
                if cmd_args ~= "" then
                  for _, arg in ipairs(vim.split(cmd_args, " ")) do
                    if arg:match("^cwd=") then
                      pick_opts.cwd = arg:gsub("^cwd=", "")
                    elseif arg == "no_ignore=true" or arg == "no_ignore" then
                      pick_opts.git_ignore = false
                    end
                  end
                end
                mini_pick.builtin.files(pick_opts)
              else
                vim.notify("mini.pick is not available. Make sure the plugin is installed.", vim.log.levels.ERROR)
              end
            end
          end, 100)
        end,
        once = true,
      })

      break
    end
  end
end

-- Initialize all startup command handlers
function M.setup()
  M.handle_pick_files_command()
end

return M