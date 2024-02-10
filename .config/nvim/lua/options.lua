local options = {
    background = "dark",
    termguicolors = true,

    cursorline = true,

    spell = false,

    ttimeoutlen = 0,
    timeoutlen = 250,
    updatetime = 750,

    relativenumber = true,
    nu = true,

    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,

    autoindent = true,
    expandtab = true,
    smartindent = true,
    ai = true,

    signcolumn = "number", -- Merge the gutter and the number into one column

    mouse = 'a',

    -- Search ignores case unless an uppercase letter appears in the pattern.
    ignorecase = true,
    smartcase = false,
    showmatch = true,

    hlsearch = false,
    incsearch = true,

    swapfile = false,
    backup = false,
    undodir = os.getenv("HOME") .. "/.vim/undodir",
    undofile = true,

    --conceallevel = 0, -- so that `` is visible in markdown files

    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window

    list = true,
    listchars = table.concat(
      { 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:<->', 'trail:·' },
      ','
    )
}


vim.cmd('colorscheme catppuccin-mocha')

--
for k, v in pairs(options) do
    vim.opt[k] = v
end
