-- General settings
vim.opt.scrolloff = 2
vim.opt.backup = false
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ruler = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim-tmp")
vim.opt.backspace = "indent,eol,start"
vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.hidden = true
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.visualbell = true
vim.opt.ttyfast = true
vim.opt.title = true
vim.opt.spelllang = "en_us"
vim.opt.autoread = true
vim.opt.lazyredraw = true
vim.opt.termguicolors = true
vim.opt.winwidth = 80   -- Minimum width of active window
vim.opt.winminwidth = 5 -- Minimum width of inactive windows

-- Disable automatic config reloading
vim.g.auto_reload_config = false

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hlsearch = true

-- Tab settings
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.formatoptions = "qrn1"
vim.opt.listchars = "tab:▸ ,eol:¬"

-- Status line
vim.opt.statusline = "%<%f (%{&ft}) %-4(%m%)%=%-19(%3l,%02c%03V%)"

-- Set cursor shape
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Create autocommands
local augroup = vim.api.nvim_create_augroup("UserSettings", { clear = true })

-- Filetype specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  command = "setlocal noexpandtab",
  group = augroup,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "haml", "eruby", "yaml", "html", "javascript", "sass", "cucumber" },
  command = "setlocal ai sw=2 sts=2 et",
  group = augroup,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "Dockerfile" },
  command = "setlocal ts=4 sw=4 sts=4 et",
  group = augroup,
})

-- Remember last position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 0 and line <= vim.fn.line("$") then
      vim.cmd("normal g`\"")
    end
  end,
  group = augroup,
})

-- Auto reload files
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
  group = augroup,
})
