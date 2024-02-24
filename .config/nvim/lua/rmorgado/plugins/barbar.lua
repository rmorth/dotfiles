return {
    "romgrk/barbar.nvim",
    config = function ()
        vim.g.barbar_auto_setup = false
        require("barbar").setup({
            animation = true,
            auto_hide = true, -- hide on single buffer
        })
    end
}
