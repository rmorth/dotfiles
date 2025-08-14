return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        
        wk.setup({
            preset = "modern",
            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 20,
                },
                presets = {
                    operators = true,
                    motions = true,
                    text_objects = true,
                    windows = true,
                    nav = true,
                    z = true,
                    g = true,
                },
            },
            win = {
                border = "rounded",
                padding = { 1, 2 },
                wo = {
                    winblend = 0,
                },
            },
            layout = {
                height = { min = 4, max = 25 },
                width = { min = 20, max = 50 },
                spacing = 3,
                align = "left",
            },
            filter = function(mapping)
                -- Hide silent, cmd, etc.
                return not vim.tbl_contains({ "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua" }, mapping.desc)
            end,
            show_help = true,
            show_keys = true,
            triggers = {
                { "<auto>", mode = "nixsotc" },
                { "s", mode = { "n", "v" } },
            },
        })

        -- Define key groups using modern spec
        wk.add({
            -- Direct actions (no submenu)
            { "<leader>f", group = "Find files (git)" },
            { "<leader>e", group = "Explorer" },
            { "<leader>b", group = "Buffers" },
            { "<leader>a", group = "Alternate file" },
            { "<leader>S", group = "Spectre search" },
            
            -- File operations submenu
            { "<leader>F", group = "File operations" },
            { "<leader>FF", group = "Find files (all)" },
            { "<leader>Fr", group = "Recent files (project)" },
            { "<leader>FR", group = "Recent files (global)" },
            { "<leader>Fn", group = "New file" },
            { "<leader>Fs", group = "Save as" },
            
            -- LSP operations
            { "<leader>l", group = "LSP" },
            { "<leader>ld", group = "Go to definition" },
            { "<leader>lr", group = "References" },
            { "<leader>lh", group = "Hover" },
            { "<leader>ls", group = "Signature help" },
            { "<leader>ln", group = "Rename" },
            { "<leader>la", group = "Code actions" },
            { "<leader>lf", group = "Format" },
            { "<leader>lD", group = "Diagnostics" },
            
            -- Git operations
            { "<leader>g", group = "Git" },
            { "<leader>gf", group = "Open file in GitHub" },
            { "<leader>gF", group = "Open file in GitHub (custom branch)" },
            { "<leader>gl", group = "Open lines in GitHub" },
            { "<leader>gL", group = "Open lines in GitHub (custom branch)" },
            
            -- Debug operations
            { "<leader>d", group = "Debug" },
            { "<leader>db", group = "Toggle breakpoint" },
            { "<leader>dc", group = "Continue" },
            { "<leader>ds", group = "Step over" },
            { "<leader>di", group = "Step into" },
            { "<leader>do", group = "Step out" },
            { "<leader>dr", group = "Repl" },
            
            -- Toggle operations
            { "<leader>t", group = "Toggle" },
            { "<leader>tn", group = "Line numbers" },
            { "<leader>tr", group = "Relative numbers" },
            { "<leader>ts", group = "Spell check" },
            { "<leader>th", group = "Search highlight" },
            { "<leader>tw", group = "Wrap" },
            { "<leader>tc", group = "Color column" },
            { "<leader>tb", group = "Background (light/dark)" },
            { "<leader>tf", group = "Fold at cursor" },
            { "<leader>tF", group = "Open all folds" },
            { "<leader>tC", group = "Close all folds" },
            { "<leader>tp", group = "Peek fold preview" },
            { "<leader>td", group = "Diagnostics" },
            
            -- Window operations
            --{ "<leader>w", group = "Window" },
            --{ "<leader>wh", group = "Split horizontal" },
            --{ "<leader>wv", group = "Split vertical" },
            --{ "<leader>wc", group = "Close" },
            --{ "<leader>wo", group = "Only this window" },
            --{ "<leader>w=", group = "Equal size" },
            
            -- Buffer operations submenu
            { "<leader>B", group = "Buffer operations" },
            { "<leader>Bs", group = "Buffer symbols (aerial)" },
            { "<leader>Bt", group = "Trim whitespace" },
            { "<leader>Ba", group = "Close all buffers" },
            { "<leader>Bo", group = "Close other buffers" },
            { "<leader>Bn", group = "Next buffer" },
            { "<leader>Bp", group = "Previous buffer" },
            { "<leader>Bf", group = "Format buffer" },
        })
    end,
}
