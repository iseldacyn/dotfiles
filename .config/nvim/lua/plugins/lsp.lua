return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        "j-hui/fidget.nvim",
    },

    config = function ()
        -- initialize lsp
        local cmp_lsp = require('cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_install = {
                "lua_ls",
            },
            handlers = {
                function(server_name) -- default handler (optional)

                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.4.7" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        },
                        root_dir = "~/.local/share/nvim/lazy/nvim-lspconfig/",
                    }
                end,
            }
        })

        -- snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        -- autocompletion
        vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local select_opts = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            -- get snippet of data
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            -- sources for autocompletion
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp', keyword_length = 1 },
                { name = 'buffer', keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },

            -- controls appears for documentation window
            window = { documentation = cmp.config.window.bordered() },

            formatting = {
                -- determine order of elements
                fields = { 'menu', 'abbr', 'kind', },
                -- customize appearance of completion menu
                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = 'λ',
                        luasnip = '⋗',
                        buffer = 'Ω',
                        path = '🖫',
                    }
                    item.menu = menu_icon[entry.source.name]
                    return item
                end
            },

            -- maps keys to completion menu
            mapping = {
                ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),
                ['<C-j>'] = cmp.mapping.select_next_item(select_opts),
                ['<C-Enter>'] = cmp.mapping.confirm({select = true}),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1

                    if cmp.visible() then
                        cmp.select_next_item(select_opts)
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, {'i', 's'}),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item(select_opts)
                    else
                        fallback()
                    end
                end, {'i', 's'}),
            }
        })

        -- change diagnostic config
        vim.diagnostic.config({
            virtual_text = false,
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN] = '▲',
                    [vim.diagnostic.severity.INFO] = '⚑',
                    [vim.diagnostic.severity.HINT] = '»',
                },
            },
            float = {
                border = 'rounded',
                source = 'always',
            },
        })

        -- change help window borders
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            {border = 'rounded'}
        )

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            {border = 'rounded'}
        )
    end
}
