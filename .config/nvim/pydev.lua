require("mason").setup {}
require("mason-lspconfig").setup { ensure_installed = { "pyright", "rust_analyzer", }, }
local lspconfig = require 'lspconfig'
lspconfig.pyright.setup {}

require('lspconfig.configs').postgres_lsp = {
  default_config = {
    name = 'postgres_lsp',
    cmd = {'postgres_lsp'},
    filetypes = {'sql'},
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern 'root-file.txt'
  }
}
lspconfig.postgres_lsp.setup{}
