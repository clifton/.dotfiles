-- Check if mini.nvim modules are properly loaded
local M = {}

function M.check_modules()
  local modules = {
    "mini.ai",
    "mini.pairs",
    "mini.statusline",
    "mini.bufremove",
    "mini.move",
    "mini.indentscope",
    "mini.files",
    "mini.cursorword",
    "mini.jump",
    "mini.hipatterns",
    "mini.comment",
    "mini.surround",
    "mini.pick",
    "mini.splitjoin",
    "mini.trailspace",
    "mini.align",
    "mini.animate"
  }

  local results = {}
  local all_loaded = true

  for _, module in ipairs(modules) do
    local loaded = pcall(require, module)
    results[module] = loaded
    if not loaded then
      all_loaded = false
    end
  end

  -- Print results
  vim.notify("mini.nvim modules load status:", vim.log.levels.INFO)
  for module, loaded in pairs(results) do
    local status = loaded and "✓ Loaded" or "✗ Not loaded"
    vim.notify(string.format("%s: %s", module, status), loaded and vim.log.levels.INFO or vim.log.levels.ERROR)
  end

  return all_loaded
end

return M