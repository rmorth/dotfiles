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

local files = require('mini.files')
files.setup({
  content = {
    -- Predicate for which file system entries to show
    filter = nil,
    -- What prefix to show to the left of file system entry
    prefix = nil,
    -- In which order to show file system entries
    sort = nil,
  },

  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close       = 'q',
    go_in       = 'L', -- switched with below (more intuitive for me)
    go_in_plus  = 'l',
    go_out      = 'H', -- switched with below (more intuitive for me)
    go_out_plus = 'h',
    reset       = '<BS>',
    reveal_cwd  = '@',
    show_help   = 'g?',
    synchronize = '=',
    trim_left   = '<',
    trim_right  = '>',
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = true,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = true,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 80,
  },
})

vim.keymap.set("n", "<leader>ft", "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>")
