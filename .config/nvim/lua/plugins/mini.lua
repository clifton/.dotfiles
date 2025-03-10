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

      -- Configure each mini module directly

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
              return require('mini.hipatterns').compute_hex_color_group(match, 'bg')
            end,
          },
        },
      })

      -- mini.comment - Code commenting
      require("mini.comment").setup({
        options = {
          ignore_blank_line = false,
          start_of_line = false,
          pad_comment_parts = true,
        },
        mappings = {
          comment = 'gc',
          comment_line = 'gcc',
          comment_visual = 'gc',
          textobject = 'gc',
        },
      })

      -- mini.surround - Surround text objects
      require("mini.surround").setup({
        custom_surroundings = {
          s = {
            input = { '%b()', '^%((.*)%)$' },
            output = { left = 'function(', right = ')' },
          },
        },
        highlight_duration = 500,
        mappings = {
          add = 'sa',
          delete = 'sd',
          find = 'sf',
          find_left = 'sF',
          highlight = 'sh',
          replace = 'sr',
          update_n_lines = 'sn',
          suffix_last = 'l',
          suffix_next = 'n',
        },
        n_lines = 20,
        respect_selection_type = false,
        search_method = 'cover',
      })

      -- mini.splitjoin - Split and join arguments, arrays, etc.
      require("mini.splitjoin").setup({
        mappings = {
          toggle = 'gS',
          split = '<leader>k',
          join = '<leader>j',
        },
        detect = {
          brackets = { '%b()', '%b[]', '%b{}' },
          separators = {
            { '%(%s*(.-)%s*%)' },
            { '%[%s*(.-)%s*%]' },
            { '{%s*(.-)%s*}' },
          },
        },
        split = {
          first_on_new_line = false,
          indent_pattern = nil,
        },
        join = {
          space = ' ',
        },
      })

      -- mini.trailspace - Highlight and remove trailing whitespace
      require("mini.trailspace").setup({
        only_in_normal_buffers = true,
      })

      -- mini.align - Align text interactively
      require("mini.align").setup({
        mappings = {
          start = 'ga',
          start_with_preview = 'gA',
        },
        options = {
          split_pattern = '',
          justify_side = 'left',
          merge_delimiter = '',
        },
        steps = {
          pre_split = {},
          split = nil,
          pre_justify = {},
          justify = nil,
          pre_merge = {},
          merge = nil,
        },
        silent = false,
      })
    end,
  },
}
