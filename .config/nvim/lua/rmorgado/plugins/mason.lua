return {
    "williamboman/mason.nvim",
    build = function()
        pcall(vim.cmd, "MasonUpdate")
    end,
    config = function()
        local lsp_zero = require("lsp-zero")
        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = {},
            handlers = {
                lsp_zero.default_setup
            }
        })
    end
}
