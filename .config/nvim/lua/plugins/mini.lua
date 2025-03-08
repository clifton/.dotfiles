return {
  -- Collection of minimal, independent, and fast Lua modules
  {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    priority = 1000, -- Extremely high priority to ensure it loads first
    config = function()
      -- Print a message to confirm the plugin is being configured
      print("Configuring mini.nvim modules...")

      -- Load each module in a pcall to catch and report errors
      local function setup_module(name, setup_fn)
        local ok, err = pcall(function()
          setup_fn()
        end)

        if not ok then
          vim.notify("Failed to load " .. name .. ": " .. tostring(err), vim.log.levels.ERROR)
        else
          vim.notify(name .. " loaded successfully", vim.log.levels.INFO)
        end
      end

      -- mini.ai - Better text objects
      setup_module("mini.ai", function()
        require("mini.ai").setup({
          n_lines = 500,
        })
      end)

      -- mini.pairs - Auto pairs
      setup_module("mini.pairs", function()
        require("mini.pairs").setup()
      end)

      -- mini.statusline - Minimal status line
      setup_module("mini.statusline", function()
        require("mini.statusline").setup({
          use_icons = true,
        })
      end)

      -- mini.bufremove - Better buffer removal
      setup_module("mini.bufremove", function()
        require("mini.bufremove").setup()
      end)

      -- mini.move - Move lines and selections
      setup_module("mini.move", function()
        require("mini.move").setup({
          mappings = {
            -- Move visual selection in Visual mode
            left = '<M-h>',
            right = '<M-l>',
            down = '<M-j>',
            up = '<M-k>',

            -- Move current line in Normal mode
            line_left = '<M-h>',
            line_right = '<M-l>',
            line_down = '<M-j>',
            line_up = '<M-k>',
          },
        })
      end)

      -- mini.indentscope - Show scope based on indentation
      setup_module("mini.indentscope", function()
        require("mini.indentscope").setup({
          -- Disable the module completely
          symbol = "",  -- Empty symbol effectively disables the visual indicator
          options = {
            try_as_border = false,
            -- Disable drawing completely
            draw = {
              delay = 1000000,  -- Very long delay effectively disables it
              animation = function() return 0 end,
            },
          },
        })
      end)

      -- mini.files - File explorer
      setup_module("mini.files", function()
        require("mini.files").setup({
          windows = {
            preview = true,
            width_focus = 30,
            width_preview = 30,
          },
          options = {
            use_as_default_explorer = true,
          },
        })
      end)

      -- mini.cursorword - Highlight word under cursor
      setup_module("mini.cursorword", function()
        require("mini.cursorword").setup()
      end)

      -- mini.jump - Better f/t motions
      setup_module("mini.jump", function()
        require("mini.jump").setup({
          mappings = {
            forward = 'f',
            backward = 'F',
            forward_till = 't',
            backward_till = 'T',
            repeat_jump = ';',
          },
        })
      end)

      -- mini.hipatterns - Highlight patterns in text
      setup_module("mini.hipatterns", function()
        require("mini.hipatterns").setup({
          highlighters = {
            -- Highlight hex color strings (#rrggbb)
            hex_color = {
              pattern = '#%x%x%x%x%x%x',
              group = function(_, match)
                return require('mini.hipatterns').compute_hex_color_group(match, 'bg')
              end,
            },
          },
        })
      end)

      -- mini.comment - Code commenting
      setup_module("mini.comment", function()
        require("mini.comment").setup({
          -- Options which control module behavior
          options = {
            -- Whether to ignore blank lines
            ignore_blank_line = false,

            -- Whether to recognize as comment only lines that start with comment string
            start_of_line = false,

            -- Whether to ensure single space pad for comment parts
            pad_comment_parts = true,
          },

          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            -- Toggle comment (like `gcip` - comment inner paragraph) for both
            -- Normal and Visual modes
            comment = 'gc',

            -- Toggle comment on current line
            comment_line = 'gcc',

            -- Toggle comment on visual selection
            comment_visual = 'gc',

            -- Define 'comment' textobject (like `dgc` - delete whole comment block)
            textobject = 'gc',
          },
        })
      end)

      -- mini.surround - Surround text objects
      setup_module("mini.surround", function()
        require("mini.surround").setup({
          -- Add custom surroundings to be used on top of builtin ones
          custom_surroundings = {
            -- Use 's' for function call surrounding (i.e. 'something' -> 'function(something)')
            s = {
              input = { '%b()', '^%((.*)%)$' },
              output = { left = 'function(', right = ')' },
            },
          },

          -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
          highlight_duration = 500,

          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            add = 'sa',            -- Add surrounding in Normal and Visual modes
            delete = 'sd',         -- Delete surrounding
            find = 'sf',           -- Find surrounding (to the right)
            find_left = 'sF',      -- Find surrounding (to the left)
            highlight = 'sh',      -- Highlight surrounding
            replace = 'sr',        -- Replace surrounding
            update_n_lines = 'sn', -- Update `n_lines`

            suffix_last = 'l',     -- Suffix to search with "prev" method
            suffix_next = 'n',     -- Suffix to search with "next" method
          },

          -- Number of lines within which surrounding is searched
          n_lines = 20,

          -- Whether to respect selection type (charwise, linewise, blockwise)
          respect_selection_type = false,

          -- How to search for surrounding (first inside current line, then inside
          -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
          -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
          -- see `:h MiniSurround.config`.
          search_method = 'cover',
        })
      end)

      -- mini.pick - Fuzzy picker with beautiful UI
      setup_module("mini.pick", function()
        require("mini.pick").setup({
          -- Enhanced UI configuration
          options = {
            -- Use border for picker window
            use_border = true,
            -- Content shown in the top line
            content_from_bottom = true,
            -- Show preview of file content
            show_preview = true,
          },
          -- Custom mappings
          mappings = {
            -- Correct format for custom mappings with char and func
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
          -- Window configuration
          window = {
            -- Window config for main picker window
            config = function()
              -- Get screen dimensions
              local screen_width = vim.o.columns
              local screen_height = vim.o.lines

              -- Calculate dimensions (adaptive to screen size)
              local width = math.min(120, math.floor(screen_width * 0.8))
              local height = math.min(30, math.floor(screen_height * 0.7))

              -- Position the window in the middle of the screen
              -- Use a fixed row position that's approximately in the middle
              local row = math.floor(screen_height * 0.5) -- Position at 50% from the top
              local col = math.floor((screen_width - width) / 2)

              return {
                width = width,
                height = height,
                row = row,
                col = col,
              }
            end,
            -- Border characters
            border = {
              style = 'rounded',
            },
            -- Preview window config
            preview = {
              height = function(picker_height)
                return math.floor(picker_height * 0.4)
              end,
            },
          },
          -- File picker configuration
          source = {
            show_hidden = true,
          },
          -- File picker configuration
          file = {
            -- Show hidden files (starting with dot)
            show_hidden = true,
            -- Use .gitignore for filtering
            git_ignore = true,
            -- Explicitly ignore these patterns
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
          -- Use the same window configuration as in the setup
          require('mini.pick').builtin.files({
            show_hidden = true,
            window = {
              config = function()
                -- Get screen dimensions
                local screen_width = vim.o.columns
                local screen_height = vim.o.lines

                -- Calculate dimensions (adaptive to screen size)
                local width = math.min(120, math.floor(screen_width * 0.8))
                local height = math.min(30, math.floor(screen_height * 0.7))

                -- Position the window in the middle of the screen
                -- Use a fixed row position that's approximately in the middle
                local row = math.floor(screen_height * 0.5) -- Position at 50% from the top
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
            -- Check if +PickFiles was in the arguments
            local has_pick_files = false
            for _, arg in ipairs(vim.v.argv) do
              if arg == "+PickFiles" then
                has_pick_files = true
                break
              end
            end

            -- Only open picker if +PickFiles was in arguments and we're not opening a specific file
            if has_pick_files and #vim.fn.expand('%') == 0 then
              vim.fn.timer_start(100, function()
                -- Use the same window configuration as in the setup
                require('mini.pick').builtin.files({
                  show_hidden = true,
                  window = {
                    config = function()
                      -- Get screen dimensions
                      local screen_width = vim.o.columns
                      local screen_height = vim.o.lines

                      -- Calculate dimensions (adaptive to screen size)
                      local width = math.min(120, math.floor(screen_width * 0.8))
                      local height = math.min(30, math.floor(screen_height * 0.7))

                      -- Position the window in the middle of the screen
                      -- Use a fixed row position that's approximately in the middle
                      local row = math.floor(screen_height * 0.5) -- Position at 50% from the top
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
      end)

      -- mini.splitjoin - Split and join arguments, arrays, etc.
      setup_module("mini.splitjoin", function()
        require("mini.splitjoin").setup({
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            toggle = 'gS',
            split = '<leader>k',    -- Split arguments/items
            join = '<leader>j',     -- Join arguments/items
          },

          -- Detection options: what to split/join
          detect = {
            -- Array of Lua patterns to detect region with arguments/items
            brackets = { '%b()', '%b[]', '%b{}' },

            -- Array of Lua patterns to detect start and end of target region
            -- First captures become start, second - end
            separators = {
              -- Function call arguments
              { '%(%s*(.-)%s*%)' },
              -- Array/table constructor
              { '%[%s*(.-)%s*%]' },
              { '{%s*(.-)%s*}' },
            },
          },

          -- Split options
          split = {
            -- Whether to place first item on its own line
            first_on_new_line = false,

            -- String to use as indent for created lines
            indent_pattern = nil,
          },

          -- Join options
          join = {
            -- String to use as space between joined items
            space = ' ',
          },
        })
      end)

      -- mini.trailspace - Highlight and remove trailing whitespace
      setup_module("mini.trailspace", function()
        require("mini.trailspace").setup({
          -- Highlight only in normal buffers (not in readonly and special ones)
          only_in_normal_buffers = true,
        })
      end)

      -- mini.align - Align text interactively
      setup_module("mini.align", function()
        require("mini.align").setup({
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            start = 'ga',
            start_with_preview = 'gA',
          },

          -- Default options controlling alignment process
          options = {
            split_pattern = '',
            justify_side = 'left',
            merge_delimiter = '',
          },

          -- Default steps performing alignment (if `nil`, default is used)
          steps = {
            pre_split = {},
            split = nil,
            pre_justify = {},
            justify = nil,
            pre_merge = {},
            merge = nil,
          },

          -- Whether to disable showing non-error feedback
          silent = false,
        })
      end)

      -- mini.animate - Animate common Neovim actions
      setup_module("mini.animate", function()
        require("mini.animate").setup({
          -- Disable all animations
          cursor = { enable = false },
          resize = { enable = false },
          open = { enable = false },
          close = { enable = false },
          scroll = { enable = false },
        })
      end)

      -- Register keymaps for mini.pick
      local function register_pick_keymaps()
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc })
        end

        -- Common window configuration for all pick commands
        local window_config = {
          config = function()
            -- Get screen dimensions
            local screen_width = vim.o.columns
            local screen_height = vim.o.lines

            -- Calculate dimensions (adaptive to screen size)
            local width = math.min(120, math.floor(screen_width * 0.8))
            local height = math.min(30, math.floor(screen_height * 0.7))

            -- Position the window in the middle of the screen
            -- Use a fixed row position that's approximately in the middle
            local row = math.floor(screen_height * 0.5) -- Position at 50% from the top
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

        map("n", "<C-p>", function()
          require('mini.pick').builtin.files({
            show_hidden = true,
            window = window_config,
          })
        end, "Find files (cwd)")

        map("n", "<leader>f", function()
          require('mini.pick').builtin.files({
            show_hidden = true,
            window = window_config,
          })
        end, "Find files")

        map("n", "<leader>.", function()
          require('mini.pick').builtin.files({
            show_hidden = true,
            filter = function(path)
              return vim.fn.filereadable(path) == 1 and vim.fn.getftime(path) > 0
            end,
            window = window_config,
          })
        end, "Recent files")

        map("n", "<leader>gb", function()
          require('mini.pick').builtin.buffers({
            window = window_config,
          })
        end, "Buffers")

        map("n", "<leader>gf", function()
          local current_file = vim.fn.expand('%:p:h')
          require('mini.pick').builtin.files({
            show_hidden = true,
            cwd = current_file,
            window = window_config,
          })
        end, "Find files (file dir)")

        map("n", "<leader>rg", function()
          require('mini.pick').builtin.grep_live({
            show_hidden = true,
            window = window_config,
          })
        end, "Live grep")

        map("n", "<leader>h", function()
          require('mini.pick').builtin.help({
            window = window_config,
          })
        end, "Help pages")

        map("n", "<leader>/", function()
          require('mini.pick').builtin.grep({
            show_hidden = true,
            pattern = vim.fn.input("Grep pattern: "),
            window = window_config,
          })
        end, "Grep")

        map("n", "<leader>:", function()
          require('mini.pick').builtin.commands({
            window = window_config,
          })
        end, "Commands")

        map("n", "<leader>k", function()
          require('mini.pick').builtin.keymaps({
            window = window_config,
          })
        end, "Keymaps")

        map("n", "<leader>z", function()
          require('mini.pick').builtin.resume({
            window = window_config,
          })
        end, "Resume last picker")

        map("n", "<leader>fa", function()
          require('mini.pick').builtin.files({
            show_hidden = true,
            git_ignore = false,
            window = window_config,
          })
        end, "Find all files (including hidden)")
      end

      -- Try to register keymaps
      pcall(register_pick_keymaps)

      -- Final notification
      vim.notify("mini.nvim configuration complete", vim.log.levels.INFO)
    end,
  },
}
