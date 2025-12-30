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
-- keys now bound by vim-tmux-navigator
-- map("n", "<C-h>", "<C-w>h")
-- map("n", "<C-j>", "<C-w>j")
-- map("n", "<C-k>", "<C-w>k")
-- map("n", "<C-l>", "<C-w>l")

-- File operations
map("c", "%%", function() return vim.fn.expand('%:h') .. '/' end, { expr = true })
map("n", "<leader>e", ":edit <C-R>=expand('%:h').'/'<CR>")

-- Manually reload Neovim configuration
map("n", "<leader>rc", function()
  -- Source init.lua
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init.lua')
  vim.notify("Neovim configuration reloaded", vim.log.levels.INFO)
end, { desc = "Reload Neovim configuration" })

map("n", "<leader>rl", ":source $MYVIMRC<CR>")
map("n", "<leader>rv", "<C-w><C-v><C-l>:e $MYVIMRC<CR>")
map("n", "<leader>rm", function()
  local file = vim.fn.expand('%')
  vim.cmd('bdelete!')
  vim.fn.delete(file)
end)

map("n", "<leader>ff", function()
  MiniFiles.open(nil, false)
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
  local os_name = get_os()
  local text = table.concat(lines, "\n")

  -- Try OSC 52 escape sequence first (works in tmux and most modern terminals)
  local osc52 = string.format("\027]52;c;%s\027\\", vim.fn.system({'base64'}, text):gsub('\n', ''))
  io.write(osc52)

  -- Also copy using native clipboard tool as fallback
  if os_name == 'Windows' then
    vim.fn.system({'clip.exe'}, text)
  elseif os_name == 'WSL' then
    vim.fn.system({'/mnt/c/Windows/System32/clip.exe'}, text)
  elseif os_name == 'macOS' then
    vim.fn.system({'pbcopy'}, text)
  else
    if vim.fn.executable('xclip') == 1 then
      vim.fn.system({'xclip', '-selection', 'clipboard'}, text)
    elseif vim.fn.executable('xsel') == 1 then
      vim.fn.system({'xsel', '--clipboard', '--input'}, text)
    elseif vim.fn.executable('wl-copy') == 1 then
      vim.fn.system({'wl-copy'}, text)
    else
      print("No clipboard tool found. Please install xclip, xsel, or wl-copy.")
    end
  end
end

local function paste_from_system_clipboard()
  local os = get_os()

  if os == 'Windows' then
    return vim.fn.system('powershell.exe Get-Clipboard')
  elseif os == 'WSL' then
    return vim.fn.system('/mnt/c/Windows/System32/WindowsPowershell/v1.0/powershell.exe Get-Clipboard')
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
map("n", "<leader>p", function()
  local clipboard_content = paste_from_system_clipboard()
  local lines = vim.split(clipboard_content, "\n")
  local current_line = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
end)

map("v", "<leader>y", function()
  -- Yank selection to unnamed register
  vim.cmd('normal! y')
  -- Get the yanked text
  local text = vim.fn.getreg('"')
  copy_to_system_clipboard({text})
end)
