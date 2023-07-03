local animate = require('mini.animate')

local animateTimeFunction = animate.gen_timing.linear({ duration = 100, unit = 'total' })

animate.setup({
    -- Cursor path
    cursor = {
        enable = true,
        timing = animateTimeFunction,
        path = animate.gen_path.line({})
    },

    -- Vertical scroll
    scroll = {
        enable = true,
        timing = animateTimeFunction,
    },

    -- Window Resize
    resize = {
        enable = true,
        timing = animateTimeFunction
    },

    -- Window Open
    open = {
        enable = true,
        timing = animateTimeFunction
    },

    -- Window Close
    close = {
        enable = true,
        timing = animateTimeFunction
    },
})

local trailspace = require('mini.trailspace')
trailspace.setup({})
vim.keymap.set("n", "<leader>tw", "<Cmd>lua MiniTrailspace.trim()<CR>")

local pairs = require('mini.pairs')
pairs.setup({})

local statusline = require('mini.statusline')
statusline.setup({})

