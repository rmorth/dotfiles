return {
    "christoomey/vim-tmux-navigator",

    -- set before the plugin loads
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,

    config = function()
        local map = vim.keymap.set
        local opts = { silent = true, noremap = true }

        -- normal-mode mappings
        map('n', '<C-h>', '<Cmd> TmuxNavigateLeft<CR>',  opts)
        map('n', '<C-j>', '<Cmd> TmuxNavigateDown<CR>',  opts)
        map('n', '<C-k>', '<Cmd> TmuxNavigateUp<CR>',    opts)
        map('n', '<C-l>', '<Cmd> TmuxNavigateRight<CR>', opts)

        -- terminal-mode mappings: leave terminal first, then navigate (to avoid conflicts with ZSH bindings)
        map('t', '<C-h>', [[<C-\><C-n><Cmd> TmuxNavigateLeft<CR>]],  opts)
        map('t', '<C-j>', [[<C-\><C-n><Cmd> TmuxNavigateDown<CR>]],  opts)
        map('t', '<C-k>', [[<C-\><C-n><Cmd> TmuxNavigateUp<CR>]],    opts)
        map('t', '<C-l>', [[<C-\><C-n><Cmd> TmuxNavigateRight<CR>]], opts)
    end,
}

