return {
    'almo7aya/openingh.nvim',
    config = function ()
        vim.keymap.set('n', '<leader>gf', '<cmd>OpenInGHFile<CR>', {
            desc = "Open file in GitHub"
        })
    end
}
