return {
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP
            { "j-hui/fidget.nvim", opts = {} },

            -- Additional lua configuration for nvim
            "folke/neodev.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- Setup neovim lua configuration
            require("neodev").setup()

            -- Setup mason so it can manage external tooling
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                },
                log_level = vim.log.levels.DEBUG
            })

            -- Configure LSP keymaps when an LSP connects to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
                    end

                    -- Create helper functions for mini.pick LSP integration
                    local pick_lsp = {}

                    -- LSP definitions
                    pick_lsp.definitions = function()
                        local params = vim.lsp.util.make_position_params()
                        vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result)
                            if not result or vim.tbl_isempty(result) then
                                vim.notify('No definitions found', vim.log.levels.INFO)
                                return
                            end
                            require('mini.pick').start({
                                source = {
                                    items = result,
                                    name_extractor = function(item)
                                        local uri = item.uri or item.targetUri
                                        local range = item.range or item.targetSelectionRange
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        local col = range.start.character + 1
                                        return string.format('%s:%d:%d', fname, row, col)
                                    end,
                                    preview = function(_, item)
                                        local uri = item.uri or item.targetUri
                                        local range = item.range or item.targetSelectionRange
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        return require('mini.pick.builtin').file_preview(fname, row)
                                    end,
                                    action = function(item)
                                        local uri = item.uri or item.targetUri
                                        local range = item.range or item.targetSelectionRange
                                        vim.cmd('edit ' .. vim.uri_to_fname(uri))
                                        vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
                                    end,
                                },
                            })
                        end)
                    end

                    -- LSP references
                    pick_lsp.references = function()
                        local params = vim.lsp.util.make_position_params()
                        params.context = { includeDeclaration = true }
                        vim.lsp.buf_request(0, 'textDocument/references', params, function(_, result)
                            if not result or vim.tbl_isempty(result) then
                                vim.notify('No references found', vim.log.levels.INFO)
                                return
                            end
                            require('mini.pick').start({
                                source = {
                                    items = result,
                                    name_extractor = function(item)
                                        local uri = item.uri
                                        local range = item.range
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        local col = range.start.character + 1
                                        return string.format('%s:%d:%d', fname, row, col)
                                    end,
                                    preview = function(_, item)
                                        local uri = item.uri
                                        local range = item.range
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        return require('mini.pick.builtin').file_preview(fname, row)
                                    end,
                                    action = function(item)
                                        local uri = item.uri
                                        local range = item.range
                                        vim.cmd('edit ' .. vim.uri_to_fname(uri))
                                        vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
                                    end,
                                },
                            })
                        end)
                    end

                    -- LSP implementations
                    pick_lsp.implementations = function()
                        local params = vim.lsp.util.make_position_params()
                        vim.lsp.buf_request(0, 'textDocument/implementation', params, function(_, result)
                            if not result or vim.tbl_isempty(result) then
                                vim.notify('No implementations found', vim.log.levels.INFO)
                                return
                            end
                            require('mini.pick').start({
                                source = {
                                    items = result,
                                    name_extractor = function(item)
                                        local uri = item.uri
                                        local range = item.range
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        local col = range.start.character + 1
                                        return string.format('%s:%d:%d', fname, row, col)
                                    end,
                                    preview = function(_, item)
                                        local uri = item.uri
                                        local range = item.range
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        return require('mini.pick.builtin').file_preview(fname, row)
                                    end,
                                    action = function(item)
                                        local uri = item.uri
                                        local range = item.range
                                        vim.cmd('edit ' .. vim.uri_to_fname(uri))
                                        vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
                                    end,
                                },
                            })
                        end)
                    end

                    -- LSP type definitions
                    pick_lsp.type_definitions = function()
                        local params = vim.lsp.util.make_position_params()
                        vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, function(_, result)
                            if not result or vim.tbl_isempty(result) then
                                vim.notify('No type definitions found', vim.log.levels.INFO)
                                return
                            end
                            require('mini.pick').start({
                                source = {
                                    items = result,
                                    name_extractor = function(item)
                                        local uri = item.uri
                                        local range = item.range
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        local col = range.start.character + 1
                                        return string.format('%s:%d:%d', fname, row, col)
                                    end,
                                    preview = function(_, item)
                                        local uri = item.uri
                                        local range = item.range
                                        local fname = vim.uri_to_fname(uri)
                                        local row = range.start.line + 1
                                        return require('mini.pick.builtin').file_preview(fname, row)
                                    end,
                                    action = function(item)
                                        local uri = item.uri
                                        local range = item.range
                                        vim.cmd('edit ' .. vim.uri_to_fname(uri))
                                        vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
                                    end,
                                },
                            })
                        end)
                    end

                    -- LSP document symbols
                    pick_lsp.document_symbols = function()
                        local params = { textDocument = vim.lsp.util.make_text_document_params() }
                        vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(_, result)
                            if not result or vim.tbl_isempty(result) then
                                vim.notify('No symbols found', vim.log.levels.INFO)
                                return
                            end

                            local items = {}
                            local function extract_symbols(symbols, level)
                                level = level or 0
                                for _, symbol in ipairs(symbols) do
                                    local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "Unknown"
                                    local indent = string.rep("  ", level)
                                    local name = indent .. kind .. ": " .. symbol.name
                                    table.insert(items, { name = name, symbol = symbol })
                                    if symbol.children then
                                        extract_symbols(symbol.children, level + 1)
                                    end
                                end
                            end

                            extract_symbols(result)

                            require('mini.pick').start({
                                source = {
                                    items = items,
                                    name_extractor = function(item)
                                        return item.name
                                    end,
                                    action = function(item)
                                        local range = item.symbol.range or item.symbol.location.range
                                        vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
                                        -- Center the cursor
                                        vim.cmd('normal! zz')
                                    end,
                                },
                            })
                        end)
                    end

                    -- LSP workspace symbols
                    pick_lsp.workspace_symbols = function()
                        vim.ui.input({ prompt = 'Query: ' }, function(query)
                            if not query or query == '' then return end

                            local params = { query = query }
                            vim.lsp.buf_request(0, 'workspace/symbol', params, function(_, result)
                                if not result or vim.tbl_isempty(result) then
                                    vim.notify('No symbols found', vim.log.levels.INFO)
                                    return
                                end

                                require('mini.pick').start({
                                    source = {
                                        items = result,
                                        name_extractor = function(item)
                                            local kind = vim.lsp.protocol.SymbolKind[item.kind] or "Unknown"
                                            local uri = item.location.uri
                                            local range = item.location.range
                                            local fname = vim.uri_to_fname(uri)
                                            local row = range.start.line + 1
                                            local col = range.start.character + 1
                                            return string.format('%s [%s] %s:%d:%d', item.name, kind, fname, row, col)
                                        end,
                                        preview = function(_, item)
                                            local uri = item.location.uri
                                            local range = item.location.range
                                            local fname = vim.uri_to_fname(uri)
                                            local row = range.start.line + 1
                                            return require('mini.pick.builtin').file_preview(fname, row)
                                        end,
                                        action = function(item)
                                            local uri = item.location.uri
                                            local range = item.location.range
                                            vim.cmd('edit ' .. vim.uri_to_fname(uri))
                                            vim.api.nvim_win_set_cursor(0,
                                                { range.start.line + 1, range.start.character })
                                        end,
                                    },
                                })
                            end)
                        end)
                    end

                    -- Jump to the definition of the word under your cursor
                    map("gd", pick_lsp.definitions, "Goto Definition")
                    -- Find references for the word under your cursor
                    map("gr", pick_lsp.references, "Goto References")
                    -- Jump to the implementation of the word under your cursor
                    map("gI", pick_lsp.implementations, "Goto Implementation")
                    -- Jump to the type definition of the word under your cursor
                    map("<leader>D", pick_lsp.type_definitions, "Type Definition")
                    -- Fuzzy find all the symbols in your current document
                    map("<leader>ds", pick_lsp.document_symbols, "Document Symbols")
                    -- Fuzzy find all the symbols in your current workspace
                    map("<leader>ws", pick_lsp.workspace_symbols, "Workspace Symbols")
                    -- Rename the variable under your cursor
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    -- Format the current buffer
                    map("<leader>cf", vim.lsp.buf.format, "Format")
                    -- Execute a code action, usually your cursor needs to be on top of an error
                    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    -- Show the signature of the function you're currently completing
                    map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
                    -- Go to the declaration of the word under your cursor
                    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
                    -- Show documentation under cursor
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- Create a command `:Format` local to the LSP buffer
                    vim.api.nvim_buf_create_user_command(event.buf, "Format", function(_)
                        vim.lsp.buf.format()
                    end, { desc = "Format current buffer with LSP" })
                end,
            })

            -- Enable the following language servers
            local servers = {
                pyright = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                        -- Point to your virtualenv
                        venvPath = vim.fn.getcwd() .. "/.venv",              -- Adjust to your venv folder
                        venv = ".venv",                                      -- Name of the virtualenv folder
                        pythonPath = vim.fn.getcwd() .. "/.venv/bin/python", -- Full path to interpreter
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                        },
                    },
                },
                -- Add more LSP servers here
                jsonls = {},
                yamlls = {},
                rust_analyzer = {},
            }

            -- Ensure the servers and tools above are installed
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                -- We're using conform.nvim for formatting now
            })
            require("mason-tool-installer").setup({
                ensure_installed = ensure_installed,
                auto_update = true,
                run_on_start = true,
            })

            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed,
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above
                        server.capabilities = vim.tbl_deep_extend(
                            "force",
                            {},
                            vim.lsp.protocol.make_client_capabilities(),
                            server.capabilities or {}
                        )
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many Windows environments
                    -- Remove the below condition to re-enable on Windows
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },
}
