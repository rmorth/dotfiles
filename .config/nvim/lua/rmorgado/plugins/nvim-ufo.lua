return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
        "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    opts = {
        provider_selector = function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
        end,
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = {
            default = { "imports" },
            json = { "array" },
            c = { "region" },
            cpp = { "region" },
        },
        preview = {
            win_config = {
                border = { "", "─", "", "", "", "─", "", "" },
                winhighlight = "Normal:Folded",
                winblend = 0,
            },
            mappings = {
                scrollU = "<C-u>",
                scrollD = "<C-d>",
                jumpTop = "[",
                jumpBot = "]",
            },
        },
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local foldedLines = endLnum - lnum
            
            -- Only show line count if more than 1 line is folded
            if foldedLines <= 1 then
                return virtText
            end
            
            local suffix = (' [%d lines]'):format(foldedLines)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            
            table.insert(newVirtText, {suffix, 'Comment'})
            return newVirtText
        end,
    },
    init = function()
        -- Using ufo provider need remap `zR` and `zM`
        -- foldcolumn = "0" because Neovim shows ugly numbers when fold levels exceed column width
        -- No native way to show only arrows without numbers - would need statuscol.nvim plugin
        vim.o.foldcolumn = "0"
        vim.o.foldlevel = 99 -- Using ufo provider need a large value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        
        -- Custom fold column with small arrows instead of + (no fold level numbers)
        vim.o.fillchars = [[eob: ,fold: ,foldopen:⌄,foldclose:›,foldsep: ]]
    end,
    config = function(_, opts)
        local ufo = require("ufo")
        ufo.setup(opts)
        
        -- Keymaps are managed in core/keymaps.lua for better organization

        -- Folding operations are in the toggle submenu: <leader>t*
    end,
}
