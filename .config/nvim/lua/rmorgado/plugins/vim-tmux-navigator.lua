return {
    "christoomey/vim-tmux-navigator",
    config = function ()
        local noremap = {
            noremap = true
        }

        vim.api.nvim_set_keymap("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", noremap)
        vim.api.nvim_set_keymap("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", noremap)
        vim.api.nvim_set_keymap("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", noremap)
        vim.api.nvim_set_keymap("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", noremap)
    end
}
