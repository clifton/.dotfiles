-- fzf-lua - Fast fuzzy finder
return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local fzf = require("fzf-lua")

      -- Configure fzf-lua
      fzf.setup({
        winopts = {
          -- Window layout
          height = 0.85,
          width = 0.80,
          row = 0.5, -- Center vertically
          col = 0.50,
          border = "rounded",
          backdrop = 60,
          preview = {
            border = "border",
            wrap = "nowrap",
            hidden = "nohidden",
            vertical = "up:60%", -- Preview above the results
            horizontal = "right:60%",
            layout = "vertical", -- Force vertical layout with preview on top
            flip_columns = 120,
            title = true,
            scrollbar = "float",
            winopts = {
              number = true,
              relativenumber = false,
              cursorline = true,
              cursorlineopt = "both",
              cursorcolumn = false,
              signcolumn = "no",
              list = false,
              foldenable = false,
              foldmethod = "manual",
            },
          },
          on_create = function()
            vim.keymap.set("t", "<C-j>", "<Down>", { buffer = true })
            vim.keymap.set("t", "<C-k>", "<Up>", { buffer = true })
          end,
        },
        keymap = {
          -- Mappings inside the fzf window
          builtin = {
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
          },
        },
        fzf_opts = {
          -- Options passed to fzf
          ["--layout"] = "reverse-list", -- Input at the bottom, results flow bottom-to-top
          ["--info"] = "inline",
          ["--height"] = "100%",
          ["--reverse"] = true, -- Ensure reverse mode is enabled (bottom-to-top)
          ["--border"] = "none", -- No border within fzf itself (we use nvim's border)
          ["--prompt"] = "> ", -- Simple prompt
          ["--pointer"] = "➜", -- Pointer to the current line
          ["--marker"] = "✓", -- Multi-select marker
        },
        files = {
          -- File finder options
          prompt = "Files❯ ",
          cmd = nil, -- Use default command based on git/fd/find
          git_icons = true,
          file_icons = true,
          color_icons = true,
          find_opts =
          [[-type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/target/*" -not -path "*/build/*" -not -path "*/dist/*"]],
          fd_opts = "--color=never --type f --hidden --follow --exclude .git",
          git_ignore = true, -- Respect .gitignore
          hidden = true,     -- Show hidden files
        },
        grep = {
          -- Grep options
          prompt = "Grep❯ ",
          input_prompt = "Grep For❯ ",
          git_icons = true,
          file_icons = true,
          color_icons = true,
          grep_opts = "--binary-files=without-match --line-number --recursive --color=always --extended-regexp",
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --glob=!.git/ --glob=!node_modules/ --glob=!target/ --glob=!build/ --glob=!dist/",
          no_header = false,
          no_header_i = false,
          hidden = true, -- Search hidden files
          follow = true, -- Follow symlinks
        },
      })

      -- Create PickFiles command
      vim.api.nvim_create_user_command('PickFiles', function()
        fzf.files({
          cwd = vim.fn.getcwd(),
          hidden = true,
          git_ignore = true,
        })
      end, { desc = 'Open fzf-lua file finder' })

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
              fzf.files({
                cwd = vim.fn.getcwd(),
                hidden = true,
                git_ignore = true,
              })
            end)
          end
        end,
        once = true,
      })

      -- Register keymaps for fzf-lua
      local function register_fzf_keymaps()
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc })
        end

        -- File finding
        map("n", "<C-p>", function()
          fzf.files({
            cwd = vim.fn.getcwd(),
            hidden = true,
            git_ignore = true,
          })
        end, "Find files (cwd)")

        map("n", "<leader>f", function()
          fzf.files({
            cwd = vim.fn.getcwd(),
            hidden = true,
            git_ignore = true,
          })
        end, "Find files")

        map("n", "<leader>.", function()
          fzf.oldfiles({
            cwd = vim.fn.getcwd(),
            include_current_session = true,
          })
        end, "Recent files")

        map("n", "<leader>fa", function()
          fzf.files({
            cwd = vim.fn.getcwd(),
            hidden = true,
            git_ignore = false, -- Don't respect gitignore
            fd_opts = "--color=never --type f --hidden --no-ignore --follow --exclude .git",
          })
        end, "Find all files (including hidden and ignored)")

        -- Buffer and directory navigation
        map("n", "<leader>gb", function()
          fzf.buffers()
        end, "Buffers")

        map("n", "<leader>gf", function()
          local current_file = vim.fn.expand('%:p:h')
          fzf.files({
            cwd = current_file,
            hidden = true,
            git_ignore = true,
          })
        end, "Find files (file dir)")

        -- Search
        map("n", "<leader>rg", function()
          fzf.live_grep({
            cwd = vim.fn.getcwd(),
            hidden = true,
            glob_flag = "--glob=!.git/", -- Explicitly exclude .git directory
            rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --glob=!.git/ --glob=!node_modules/ --glob=!target/ --glob=!build/ --glob=!dist/",
          })
        end, "Live grep")

        map("n", "<leader>/", function()
          fzf.grep({
            cwd = vim.fn.getcwd(),
            search = "",
            hidden = true,
            glob_flag = "--glob=!.git/", -- Explicitly exclude .git directory
            rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --glob=!.git/ --glob=!node_modules/ --glob=!target/ --glob=!build/ --glob=!dist/",
          })
        end, "Grep")

        -- Help and commands
        map("n", "<leader>h", function()
          fzf.help_tags()
        end, "Help pages")

        map("n", "<leader>:", function()
          fzf.commands()
        end, "Commands")

        map("n", "<leader>k", function()
          fzf.keymaps()
        end, "Keymaps")

        map("n", "<leader>z", function()
          fzf.resume()
        end, "Resume last picker")

        -- Additional fzf-lua specific commands
        map("n", "<leader>gc", function()
          fzf.git_commits()
        end, "Git commits")

        map("n", "<leader>gs", function()
          fzf.git_status()
        end, "Git status")
      end

      -- Register keymaps
      register_fzf_keymaps()
    end,
  },
}
