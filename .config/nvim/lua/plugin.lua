vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'morhetz/gruvbox'

    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup()
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/plenary.nvim'}}
    }

    use({
        "wintermute-cell/gitignore.nvim",
        requires = {
            "nvim-telescope/telescope.nvim"
        }
    })

    use {
        'goolord/alpha-nvim',
        config = function()
            require('alpha').setup(require('alpha.themes.dashboard').config)
        end
    }

    use 'echasnovski/mini.nvim'

    --------------
    -- TERMINAL -- 
    --------------
    use {
        'voldikss/vim-floaterm',
        config = function()
            vim.cmd [[ hi FloatermBorder guibg=black guifg=white ]]

            vim.g.floaterm_keymap_toggle = '<leader>t'
            vim.g.floaterm_keymap_new = '<F12>'
            vim.g.floaterm_keymap_prev = '<C-S-Tab>'
            vim.g.floaterm_keymap_next = '<C-Tab>'

            vim.g.floaterm_shell = 'pwsh -NoLogo'
            vim.g.floaterm_title = 'Terminal ($1|$2)'
            vim.g.floaterm_autoclose = 2 -- 0 -> never close, 1 -> close on 0 exit code, 2 -> always close

            vim.g.floaterm_width = 0.85
            vim.g.floaterm_height = 30
            vim.g.floaterm_position = 'center'
        end
    }

    use 'kyazdani42/nvim-web-devicons'
    use 'lewis6991/gitsigns.nvim'
    use 'romgrk/barbar.nvim'
    use 'sudormrfbin/cheatsheet.nvim'
    use 'theprimeagen/harpoon'
    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'
    use 'github/copilot.vim'
    use 'RaafatTurki/hex.nvim'

    ---------
    -- LSP --  
    ---------
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        }
    }

    --use {
    --    "folke/trouble.nvim",
    --    config = function()
    --        require("trouble").setup {
    --            icons = false,
    --            -- your configuration comes here
    --            -- or leave it empty to use the default settings
    --            -- refer to the configuration section below
    --        }
    --    end
    --}

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason-lspconfig.nvim'}, -- Optional
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'p00f/clangd_extensions.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    }
}

end)
