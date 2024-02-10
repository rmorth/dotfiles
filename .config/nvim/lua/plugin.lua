vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'morhetz/gruvbox'
    use { "catppuccin/nvim", as = "catppuccin" }

    use 'christoomey/vim-tmux-navigator'

    use 'mg979/vim-visual-multi'

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
    use {
        'folke/todo-comments.nvim',
        requires = {{'nvim-lua/plenary.nvim'}}
    }

    --------------
    -- FILETREE --
    --------------
    --use 'theprimeagen/harpoon'

    use 'kyazdani42/nvim-web-devicons'
    use 'lewis6991/gitsigns.nvim'
    use 'romgrk/barbar.nvim'
    use 'sudormrfbin/cheatsheet.nvim'
    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'
    use 'github/copilot.vim'
    use 'RaafatTurki/hex.nvim'
    use "sindrets/diffview.nvim"

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
      'stevearc/aerial.nvim',
      config = function() require('aerial').setup() end
    }

    use {
        'sbdchd/neoformat'
    }

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
