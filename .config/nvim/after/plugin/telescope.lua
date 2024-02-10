local ts = require('telescope')
local b = require('telescope.builtin')

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

-- VSCode jump to file shortcut
vim.keymap.set("n", "<C-p>", b.git_files, {})

-- Find file in whole project
vim.keymap.set("n", "<leader>pf", b.find_files, {})

-- Grep search in project
vim.keymap.set("n", "<leader>ps", function ()
    b.grep_string({ search = vim.fn.input("Grep >") })
end)

vim.keymap.set('n', '<leader>vh', b.help_tags, {})

vim.keymap.set('n', '<leader>vs', ':Telescope aerial<CR>')

vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>')

ts.load_extension('aerial')
