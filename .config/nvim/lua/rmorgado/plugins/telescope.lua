return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local ts = require('telescope')
        local b = require('telescope.builtin')
        local build_menu = require('rmorgado.plugins.custom.build-menu')

        ts.setup {
            extensions = {
                file_browser = {
                    -- theme = "ivy",
                    -- disables netrw and use telescope-file-browser in its place
                    -- hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                            -- your custom insert mode mappings
                        },
                        ["n"] = {
                            -- your custom normal mode mappings
                        },
                    },
                }
            },
        }

        ts.load_extension('aerial')

        -- set keymaps

        vim.keymap.set("n", "<C-p>", b.git_files, {}) -- VSCode jump to file shortcut

        vim.keymap.set("n", "<leader>pf", b.find_files, {}) -- Find file in whole project

        vim.keymap.set("n", "<leader>ps", function () -- Grep search in project
            b.grep_string({ search = vim.fn.input("Grep >") })
        end)

        vim.keymap.set('n', '<leader>vh', b.help_tags, {})
        vim.keymap.set('n', '<leader>vs', ':Telescope aerial<CR>')
        vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>')

        vim.keymap.set('n', '<leader>cb', build_menu.build_menu, { noremap = true, silent = true })

    end
}
