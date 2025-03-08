return {
  -- Collection of minimal, independent, and fast Lua modules
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      -- mini.ai - Better text objects
      require("mini.ai").setup({
        n_lines = 500,
      })

      -- mini.pairs - Auto pairs
      require("mini.pairs").setup()

      -- mini.statusline - Minimal status line
      require("mini.statusline").setup({
        use_icons = true,
      })

      -- mini.bufremove - Better buffer removal
      require("mini.bufremove").setup()

      -- mini.move - Move lines and selections
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

      -- mini.indentscope - Show scope based on indentation
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
      })

      -- mini.files - File explorer
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

      -- mini.cursorword - Highlight word under cursor
      require("mini.cursorword").setup()

      -- mini.jump - Better f/t motions
      require("mini.jump").setup({
        mappings = {
          forward = 'f',
          backward = 'F',
          forward_till = 't',
          backward_till = 'T',
          repeat_jump = ';',
        },
      })

      -- mini.hipatterns - Highlight patterns in text
      require("mini.hipatterns").setup({
        highlighters = {
          -- Highlight hex color strings (#rrggbb)
          hex_color = {
            pattern = '#%x%x%x%x%x%x',
            group = function(_, match)
              return MiniHipatterns.compute_hex_color_group(match, 'bg')
            end,
          },
        },
      })

      -- mini.comment - Code commenting
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

        -- Hook functions to be executed at certain stage of commenting
        hooks = {
          -- Before successful commenting. Called before any change is made
          pre = function() end,

          -- After successful commenting. Called after all changes are made
          post = function() end,
        },
      })

      -- mini.surround - Surround text objects
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
          add = 'sa', -- Add surrounding in Normal and Visual modes
          delete = 'sd', -- Delete surrounding
          find = 'sf', -- Find surrounding (to the right)
          find_left = 'sF', -- Find surrounding (to the left)
          highlight = 'sh', -- Highlight surrounding
          replace = 'sr', -- Replace surrounding
          update_n_lines = 'sn', -- Update `n_lines`

          suffix_last = 'l', -- Suffix to search with "prev" method
          suffix_next = 'n', -- Suffix to search with "next" method
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

      -- mini.pick - Fuzzy picker with beautiful UI
      require("mini.pick").setup({
        -- Enhanced UI configuration
        options = {
          -- Use border for picker window
          use_border = true,
          -- Content shown in the top line
          content_from_bottom = false,
          -- Show preview of file content
          show_preview = true,
        },
        -- Custom mappings
        mappings = {
          -- Scroll preview up/down
          preview_scroll_up = '<C-b>',
          preview_scroll_down = '<C-f>',
        },
        -- Window configuration
        window = {
          -- Window config for main picker window
          config = {
            width = 0.7,
            height = 0.7,
            row = 0.15,
            col = 0.15,
          },
          -- Border characters
          border = {
            style = 'rounded',
          },
          -- Preview window config
          preview = {
            height = 0.4,
          },
        },
      })

      -- mini.splitjoin - Split and join arguments, arrays, etc.
      require("mini.splitjoin").setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          toggle = 'gS', -- Toggle split/join
          split = '',    -- Split arguments/items
          join = '',     -- Join arguments/items
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

      -- mini.trailspace - Highlight and remove trailing whitespace
      require("mini.trailspace").setup({
        -- Highlight only in normal buffers (not in readonly and special ones)
        only_in_normal_buffers = true,
      })

      -- mini.align - Align text interactively
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

      -- mini.animate - Animate common Neovim actions
      require("mini.animate").setup({
        -- Cursor path during move or scroll in window
        cursor = {
          -- Whether to enable this animation
          enable = true,

          -- Timing of animation (how steps will progress in time)
          timing = function(_, s) return 0.3 * math.sqrt(s) end,

          -- Path generator for visualized cursor movement
          path = function(dest, data)
            return require('mini.animate').gen_path.line(dest, data)
          end,
        },

        -- Window resize animation
        resize = {
          -- Whether to enable this animation
          enable = true,

          -- Timing of animation (how steps will progress in time)
          timing = function(_, s) return 0.3 * math.sqrt(s) end,

          -- Subroutine for force-equal distribution of step sizes
          subroutine = function(data)
            return require('mini.animate').gen_subroutine.equal_steps(data)
          end,
        },

        -- Window open animation
        open = {
          -- Whether to enable this animation
          enable = true,

          -- Timing of animation (how steps will progress in time)
          timing = function(_, s) return 0.3 * math.sqrt(s) end,

          -- Floating window config generator
          winconfig = function(win_id, data)
            return require('mini.animate').gen_winconfig.wipe(win_id, data)
          end,

          -- Floating window options generator
          winopts = function()
            return { winblend = 0 }
          end,
        },

        -- Window close animation
        close = {
          -- Whether to enable this animation
          enable = true,

          -- Timing of animation (how steps will progress in time)
          timing = function(_, s) return 0.3 * math.sqrt(s) end,

          -- Floating window config generator
          winconfig = function(win_id, data)
            return require('mini.animate').gen_winconfig.wipe(win_id, data)
          end,

          -- Floating window options generator
          winopts = function()
            return { winblend = 0 }
          end,
        },

        -- Window scroll animation
        scroll = {
          -- Whether to enable this animation
          enable = true,

          -- Timing of animation (how steps will progress in time)
          timing = function(_, s) return 0.3 * math.sqrt(s) end,

          -- Subroutine for force-equal distribution of step sizes
          subroutine = function(data)
            return require('mini.animate').gen_subroutine.equal_steps(data)
          end,
        },
      })
    end,
  },
}