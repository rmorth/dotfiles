return {
    'VonHeikemen/lsp-zero.nvim',
    branch = "v3.x",
    event = "InsertEnter",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "p00f/clangd_extensions.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "SirVer/ultisnips",
        "honza/vim-snippets"
    },
    config = function()
        local lsp = require("lsp-zero").preset({})
        lsp.set_preferences({
            suggest_lsp_servers = true,
            sign_icons = {
                error = 'E',
                warn = 'W',
                hint = 'H',
                info = 'I'
            }
        })

        local cmp = require("cmp")
        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            window = {

            },

            formatting = lsp.cmp_format(),
            sources = {
                { name = "nvim_lsp" }
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = nil,
                ["<S-Tab>"] = nil,
            })
        })

        lsp.on_attach(function(client, bufnr)
          -- LSP keymaps are now managed in core/keymaps.lua for better organization
          -- Standard LSP bindings like gd, gh, [d, ]d are kept here as they follow Vim conventions
          local opts = {buffer = bufnr, remap = false}

          -- Keep standard Vim-style LSP bindings (non-leader)
          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
          vim.keymap.set("n", "gh", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
          
          -- Leader-based LSP operations are moved to core/keymaps.lua under <leader>l* group
        end)

        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

        lsp.configure('clangd', {
            cmd = {'clangd', '--background-index', '--clang-tidy'},
            on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "<leader>vcf", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
            end
        })

        lsp.setup()

        vim.diagnostic.config({
            virtual_text = {
              prefix = "●", -- pick whatever symbol you like
              spacing = 4,
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
          })
    end
}
