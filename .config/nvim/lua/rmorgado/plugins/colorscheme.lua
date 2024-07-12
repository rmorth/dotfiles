return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- make sure to load first
    opts = {
        flavour = "auto",
        background = {
            light = "latte",
            dark = "mocha",
        }
    },
    config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme catppuccin]])
    end
}
