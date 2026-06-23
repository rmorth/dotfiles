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
            pickers = {
                git_files = {
                    layout_strategy = 'flex',
                    border = true,
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },  -- Box drawing chars
                    results_title = false,
                    preview_title = false,
                    prompt_title = false,
                    preview = {
                        hide_on_startup = false,
                    },
                    layout_config = {
                        flex = {
                            flip_columns = 150,  -- Switch to vertical when width < 150 columns
                            flip_lines = 20,     -- Switch to horizontal when height < 20 lines
                        },
                        horizontal = {
                            preview_width = 0.7,
                            preview_cutoff = 80,
                            padding = 0,
                        },
                        vertical = {
                            preview_height = 0.7,
                            preview_cutoff = 20,
                        },
                    },
                },
            },
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

        -- Keymaps are now managed in core/keymaps.lua for better organization
        -- This keeps telescope config focused on telescope-specific settings
        
        -- Build menu keymap (plugin-specific functionality)
        vim.keymap.set('n', '<leader>cb', build_menu.build_menu, { noremap = true, silent = true })

    end
}
