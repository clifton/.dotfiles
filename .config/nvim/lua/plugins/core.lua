return {
  -- Colorscheme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = false,
        theme = "wave",
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  -- Better UI components
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  -- Useful lua functions used by many plugins
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Icons used by many plugins
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Detect tabstop and shiftwidth automatically
  {
    "tpope/vim-sleuth",
    event = "VeryLazy",
  },

  -- Useful plugin to show you pending keybinds
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
    end,
  },

  -- Adds git related signs to the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Tmux integration
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },

  -- Scratch buffer
  {
    "mtth/scratch.vim",
    cmd = "Scratch",
    keys = {
      { "<leader><tab>", "<cmd>Scratch<cr>", desc = "Open Scratch Buffer" },
    },
  },
}
