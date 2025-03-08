-- This file is disabled since mini.pick functionality is now integrated into mini.lua
return {
  -- mini.pick - Fuzzy picker with beautiful UI
  {
    "echasnovski/mini.nvim",
    dependencies = {},
    config = function()
      -- Configure mini.pick
      require("mini.pick").setup({
        options = {
          use_border = true,
          content_from_bottom = true,
          show_preview = true,
        },
        mappings = {
          preview_scroll_up = {
            char = '<C-b>',
            func = function(buf_id, state)
              local preview_winid = state.preview_winid
              if preview_winid ~= nil then
                local height = vim.api.nvim_win_get_height(preview_winid)
                local input = string.rep("<C-u>", math.max(1, math.floor(height / 4)))
                vim.api.nvim_win_call(preview_winid, function() vim.cmd("normal! " .. input) end)
              end
            end
          },
          preview_scroll_down = {
            char = '<C-f>',
            func = function(buf_id, state)
              local preview_winid = state.preview_winid
              if preview_winid ~= nil then
                local height = vim.api.nvim_win_get_height(preview_winid)
                local input = string.rep("<C-d>", math.max(1, math.floor(height / 4)))
                vim.api.nvim_win_call(preview_winid, function() vim.cmd("normal! " .. input) end)
              end
            end
          },
        },
        window = {
          config = function()
            local screen_width = vim.o.columns
            local screen_height = vim.o.lines
            local width = math.min(120, math.floor(screen_width * 0.8))
            local height = math.min(30, math.floor(screen_height * 0.7))
            local row = math.floor(screen_height * 0.5)
            local col = math.floor((screen_width - width) / 2)
            return {
              width = width,
              height = height,
              row = row,
              col = col,
            }
          end,
          border = { style = 'rounded' },
          preview = {
            height = function(picker_height)
              return math.floor(picker_height * 0.4)
            end,
          },
        },
        source = { show_hidden = true },
        file = {
          show_hidden = true,
          git_ignore = true,
          exclude_patterns = {
            '%.git/',
            'node_modules/',
            'target/',
            'build/',
            'dist/',
          },
        },
      })

      -- Create PickFiles command
      vim.api.nvim_create_user_command('PickFiles', function()
        require('mini.pick').builtin.files({
          show_hidden = true,
          window = {
            config = function()
              local screen_width = vim.o.columns
              local screen_height = vim.o.lines
              local width = math.min(120, math.floor(screen_width * 0.8))
              local height = math.min(30, math.floor(screen_height * 0.7))
              local row = math.floor(screen_height * 0.5)
              local col = math.floor((screen_width - width) / 2)
              return {
                width = width,
                height = height,
                row = row,
                col = col,
              }
            end,
            preview = {
              height = function(picker_height)
                return math.floor(picker_height * 0.4)
              end,
            },
          },
        })
      end, { desc = 'Open mini.pick file finder' })

      -- Setup +PickFiles handler
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local has_pick_files = false
          for _, arg in ipairs(vim.v.argv) do
            if arg == "+PickFiles" then
              has_pick_files = true
              break
            end
          end

          if has_pick_files and #vim.fn.expand('%') == 0 then
            vim.fn.timer_start(100, function()
              require('mini.pick').builtin.files({
                show_hidden = true,
                window = {
                  config = function()
                    local screen_width = vim.o.columns
                    local screen_height = vim.o.lines
                    local width = math.min(120, math.floor(screen_width * 0.8))
                    local height = math.min(30, math.floor(screen_height * 0.7))
                    local row = math.floor(screen_height * 0.5)
                    local col = math.floor((screen_width - width) / 2)
                    return {
                      width = width,
                      height = height,
                      row = row,
                      col = col,
                    }
                  end,
                  preview = {
                    height = function(picker_height)
                      return math.floor(picker_height * 0.4)
                    end,
                  },
                },
              })
            end)
          end
        end,
        once = true,
      })

      -- Register keymaps for mini.pick
      local function register_pick_keymaps()
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc })
        end

        -- Common window configuration for all pick commands
        local window_config = {
          config = function()
            local screen_width = vim.o.columns
            local screen_height = vim.o.lines
            local width = math.min(120, math.floor(screen_width * 0.8))
            local height = math.min(30, math.floor(screen_height * 0.7))
            local row = math.floor(screen_height * 0.5)
            local col = math.floor((screen_width - width) / 2)
            return {
              width = width,
              height = height,
              row = row,
              col = col,
            }
          end,
          preview = {
            height = function(picker_height)
              return math.floor(picker_height * 0.4)
            end,
          },
        }

        -- File finding
        map("n", "<C-p>", function()
          require('mini.pick').builtin.files({ show_hidden = true, window = window_config })
        end, "Find files (cwd)")

        map("n", "<leader>f", function()
          require('mini.pick').builtin.files({ show_hidden = true, window = window_config })
        end, "Find files")

        map("n", "<leader>.", function()
          require('mini.pick').builtin.files({
            show_hidden = true,
            filter = function(path) return vim.fn.filereadable(path) == 1 and vim.fn.getftime(path) > 0 end,
            window = window_config,
          })
        end, "Recent files")

        map("n", "<leader>fa", function()
          require('mini.pick').builtin.files({ show_hidden = true, git_ignore = false, window = window_config })
        end, "Find all files (including hidden)")

        -- Buffer and directory navigation
        map("n", "<leader>gb", function()
          require('mini.pick').builtin.buffers({ window = window_config })
        end, "Buffers")

        map("n", "<leader>gf", function()
          local current_file = vim.fn.expand('%:p:h')
          require('mini.pick').builtin.files({ show_hidden = true, cwd = current_file, window = window_config })
        end, "Find files (file dir)")

        -- Search
        map("n", "<leader>rg", function()
          require('mini.pick').builtin.grep_live({ show_hidden = true, window = window_config })
        end, "Live grep")

        map("n", "<leader>/", function()
          require('mini.pick').builtin.grep({
            show_hidden = true,
            pattern = vim.fn.input("Grep pattern: "),
            window = window_config,
          })
        end, "Grep")

        -- Help and commands
        map("n", "<leader>h", function()
          require('mini.pick').builtin.help({ window = window_config })
        end, "Help pages")

        map("n", "<leader>:", function()
          require('mini.pick').builtin.commands({ window = window_config })
        end, "Commands")

        map("n", "<leader>k", function()
          require('mini.pick').builtin.keymaps({ window = window_config })
        end, "Keymaps")

        map("n", "<leader>z", function()
          require('mini.pick').builtin.resume({ window = window_config })
        end, "Resume last picker")
      end

      -- Register keymaps
      register_pick_keymaps()
    end,
  },
}
