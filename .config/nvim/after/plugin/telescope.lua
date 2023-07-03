local builtin = require('telescope.builtin')

-- VSCode jump to file shortcut
vim.keymap.set("n", "<C-p>", builtin.git_files, {})

-- Find file in whole project
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})

-- Grep search in project
vim.keymap.set("n", "<leader>ps", function ()
    builtin.grep_string({ search = vim.fn.input("Grep >") })
end)

vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

