return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
      {
        "<F3>",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        python = { "ruff_format" }, -- Using ruff for Python formatting
        sh = { "shfmt" },
        bash = { "shfmt" },
        rust = { "rustfmt" },
        toml = { "taplo" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    init = function()
      -- Create a toggle command for format on save
      vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
        local conform = require("conform")
        if conform.format_on_save.enabled then
          conform.format_on_save.enabled = false
          vim.notify("Format on save disabled", vim.log.levels.INFO)
        else
          conform.format_on_save.enabled = true
          vim.notify("Format on save enabled", vim.log.levels.INFO)
        end
      end, { desc = "Toggle format on save" })

      -- Add a keybinding to toggle format on save
      vim.keymap.set("n", "<leader>tf", ":ToggleFormatOnSave<CR>", { desc = "Toggle format on save" })
    end,
  },
}

