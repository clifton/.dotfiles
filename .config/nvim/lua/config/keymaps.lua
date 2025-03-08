-- Set leader key
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Helper function for mappings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- General mappings
map("n", "<leader><leader>", "<c-^>")
map("n", "<leader>v", "`[v`]")
map("n", ";", ":")
map("n", "<leader>s", ":set spell!<CR>")
map("n", "<leader><space>", ":noh<cr>")
map("n", "<tab>", "%")
map("v", "<tab>", "%")
map("n", "<C-e>", "3<C-e>")
map("n", "<C-y>", "3<C-y>")
map("n", "<F5>", function()
  local save_cursor = vim.fn.getpos(".")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
end)

-- Window navigation
map("n", "<leader>w", "<C-w>v")
map("n", "<leader>W", "<C-w>s")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- File operations
map("c", "%%", function() return vim.fn.expand('%:h') .. '/' end, { expr = true })
map("n", "<leader>e", ":edit <C-R>=expand('%:h').'/'<CR>")
map("n", "<leader>rl", ":source $MYVIMRC<CR>")
map("n", "<leader>rv", "<C-w><C-v><C-l>:e $MYVIMRC<CR>")
map("n", "<leader>rm", function()
  local file = vim.fn.expand('%')
  vim.cmd('bdelete!')
  vim.fn.delete(file)
end)

-- Command aliases
vim.cmd([[
  command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>
  command! -bang Q quit<bang>
]])

-- System clipboard integration
local function get_os()
  if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    return 'Windows'
  elseif vim.fn.has('wsl') == 1 then
    return 'WSL'
  elseif vim.fn.has('macunix') == 1 then
    return 'macOS'
  else
    return 'Linux'
  end
end

local function copy_to_system_clipboard(lines)
  local os = get_os()
  local text = table.concat(lines, "\n")

  if os == 'Windows' then
    vim.fn.system('echo ' .. vim.fn.shellescape(text) .. '| clip.exe')
  elseif os == 'WSL' then
    vim.fn.system('echo ' .. vim.fn.shellescape(text) .. '| clip.exe')
  elseif os == 'macOS' then
    vim.fn.system('echo ' .. vim.fn.shellescape(text) .. '| pbcopy')
  else
    if vim.fn.executable('xclip') == 1 then
      vim.fn.system('echo ' .. vim.fn.shellescape(text) .. '| xclip -selection clipboard')
    elseif vim.fn.executable('xsel') == 1 then
      vim.fn.system('echo ' .. vim.fn.shellescape(text) .. '| xsel --clipboard --input')
    else
      print("No clipboard tool found. Please install xclip or xsel.")
    end
  end
end

local function paste_from_system_clipboard()
  local os = get_os()

  if os == 'Windows' then
    return vim.fn.system('powershell.exe Get-Clipboard')
  elseif os == 'WSL' then
    return vim.fn.system('powershell.exe Get-Clipboard')
  elseif os == 'macOS' then
    return vim.fn.system('pbpaste')
  else
    if vim.fn.executable('xclip') == 1 then
      return vim.fn.system('xclip -selection clipboard -o')
    elseif vim.fn.executable('xsel') == 1 then
      return vim.fn.system('xsel --clipboard --output')
    else
      print("No clipboard tool found. Please install xclip or xsel.")
      return ""
    end
  end
end

-- Clipboard mappings
vim.api.nvim_create_user_command('CopyToClipboard', function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  copy_to_system_clipboard(lines)
end, { range = true })

map("n", "<leader>p", function()
  local clipboard_content = paste_from_system_clipboard()
  local lines = vim.split(clipboard_content, "\n")
  local current_line = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
end)

map("v", "<leader>y", ":'<,'>CopyToClipboard<CR>")