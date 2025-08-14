-- ============================================================================
-- NEOVIM KEYMAPS - HYBRID MNEMONIC/ERGONOMIC SYSTEM
-- ============================================================================

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Set leader key
vim.g.mapleader = ' '

-- ============================================================================
-- BASIC VIM IMPROVEMENTS
-- ============================================================================

-- Disable Q (ex mode)
keymap("", "Q", "<Nop>", opts)

-- Make Y behave like C and D (yank to end of line)
keymap("n", "Y", "y$", opts)

-- Better line joining (don't move cursor)
keymap("n", "J", "mzJ`z", opts)

-- Center cursor when navigating search results
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Center cursor when scrolling
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)

-- Create new lines without entering insert mode
keymap("n", "o", "o<esc>", opts)
keymap("n", "O", "O<esc>", opts)

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

-- Navigate split windows (tmux integration)
keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", opts)
keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", opts)
keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", opts)

-- Resize split windows
keymap("", "<C-up>", "<C-w>+", opts)
keymap("", "<C-down>", "<C-w>-", opts)
keymap("", "<C-left>", "<C-w>>", opts)
keymap("", "<C-right>", "<C-w><", opts)

-- Window operations (submenu)
--keymap("n", "<leader>wh", "<cmd>split<CR>", opts)
--keymap("n", "<leader>wv", "<cmd>vsplit<CR>", opts)
--keymap("n", "<leader>wc", "<cmd>close<CR>", opts)
--keymap("n", "<leader>wo", "<cmd>only<CR>", opts)
--keymap("n", "<leader>w=", "<C-w>=", opts)

-- ============================================================================
-- VISUAL MODE ENHANCEMENTS
-- ============================================================================

-- Move selected lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Paste over selection without yanking
keymap("x", "<leader>p", [["_dP]], opts)

-- ============================================================================
-- HYBRID KEYBIND SYSTEM - HIGH FREQUENCY (DIRECT ACTIONS)
-- ============================================================================

-- File operations (most frequent)
keymap("n", "<leader>f", "<cmd>Telescope git_files<CR>", opts)  -- Find files (git)
-- Keep Ctrl+P if you prefer it over leader+f
--keymap("n", "<C-p>", "<cmd>Telescope git_files<CR>", opts)

keymap("n", "<leader>e", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", opts)  -- Explorer
keymap("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)  -- Buffers

-- Header/Source switching (keep your muscle memory or use mnemonic)
--keymap("n", "<leader>vcf", "<cmd>ClangdSwitchSourceHeader<CR>", opts)  -- Your current binding
-- Alternative mnemonic option:
keymap("n", "<leader>a", "<cmd>ClangdSwitchSourceHeader<CR>", opts)  -- Alternate file

-- Search operations
keymap("n", "<leader>S", "<cmd>lua require('spectre').toggle()<CR>", opts)  -- Spectre search (keep your current!)

-- ============================================================================
-- SUBMENU GROUPS (EXTENSIBLE/DISCOVERABLE)
-- ============================================================================

-- File operations submenu (capital F)
keymap("n", "<leader>FF", "<cmd>Telescope find_files<CR>", opts)  -- Find files (all)
keymap("n", "<leader>Fr", "<cmd>Telescope oldfiles cwd_only=true<CR>", opts)  -- Recent files (project)
keymap("n", "<leader>FR", "<cmd>Telescope oldfiles<CR>", opts)  -- Recent files (global)

-- LSP operations submenu (integrated from lsp-zero.lua)
keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)  -- Go to definition (alternative to gd)
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)  -- References
keymap("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)  -- Hover (alternative to gh)
keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)  -- Signature help
keymap("n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)  -- Rename
keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)  -- Code actions
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)  -- Format
keymap("n", "<leader>lD", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)  -- Diagnostics float
keymap("n", "<leader>lw", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)  -- Workspace symbols

-- Buffer operations submenu (capital B)
keymap("n", "<leader>Ba", "<cmd>%bd|e#<CR>", opts)  -- Close all buffers
keymap("n", "<leader>Bo", "<cmd>%bd|e#|bd#<CR>", opts)  -- Close other buffers
keymap("n", "<leader>Bn", "<cmd>bnext<CR>", opts)  -- Next buffer
keymap("n", "<leader>Bp", "<cmd>bprev<CR>", opts)  -- Previous buffer
keymap("n", "<leader>Bt", "<cmd>lua MiniTrailspace.trim()<CR>", opts)  -- Trim whitespace
keymap("n", "<leader>Bs", "<cmd>Telescope aerial<CR>", opts)  -- Symbols in buffer using aerial

-- Toggle operations submenu
keymap("n", "<leader>tn", "<cmd>set number!<CR>", opts)  -- Toggle line numbers
keymap("n", "<leader>tr", "<cmd>set relativenumber!<CR>", opts)  -- Toggle relative numbers
keymap("n", "<leader>ts", "<cmd>set spell!<CR>", opts)  -- Toggle spell check
keymap("n", "<leader>th", "<cmd>set hlsearch!<CR>", opts)  -- Toggle search highlight
keymap("n", "<leader>tw", "<cmd>set wrap!<CR>", opts)  -- Toggle wrap
keymap("n", "<leader>tc", "<cmd>execute 'set colorcolumn=' . (&colorcolumn == '' ? '80' : '')<CR>", opts)  -- Toggle color column
keymap("n", "<leader>tb", function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end, opts)  -- Toggle background (light/dark)
keymap("n", "<leader>tf", "za", opts)  -- Toggle fold at cursor
keymap("n", "<leader>tF", "<cmd>lua require('ufo').openAllFolds()<CR>", opts)  -- Toggle all folds open
keymap("n", "<leader>tC", "<cmd>lua require('ufo').closeAllFolds()<CR>", opts)  -- Toggle all folds closed
keymap("n", "<leader>tp", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>", opts)  -- Toggle fold preview
keymap("n", "<leader>td", function()
    local enabled = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not enabled)
end, opts)  -- Toggle diagnostics

-- Git operations submenu
keymap("n", "<leader>gf", "<cmd>OpenInGHFile<CR>", opts)  -- Open file in GitHub
keymap("n", "<leader>gl", "<cmd>OpenInGHFileLines<CR>", opts)  -- Open lines in GitHub
keymap("n", "<leader>gb", function()
    local branch = vim.fn.input("Branch: ")
    if branch ~= "" then
        vim.cmd("OpenInGHFile " .. branch)
    end
end, opts)  -- Open file in GitHub (custom branch)
keymap("n", "<leader>gL", function()
    local branch = vim.fn.input("Branch: ")
    if branch ~= "" then
        vim.cmd("OpenInGHFileLines " .. branch)
    end
end, opts)  -- Open lines in GitHub (custom branch)

-- Additional useful operations that could be added to submenus if needed:
-- - Help tags: <leader>vh (telescope help)
-- - Build menu: <leader>cb (custom build menu)

-- ============================================================================
-- REMOVED/DEPRECATED KEYBINDS
-- ============================================================================

-- REMOVED: <leader>pf moved to <leader>FF (find all files)
-- REMOVED: <leader>ft moved to <leader>e (explorer)
-- REMOVED: <leader>tw moved to <leader>Bt (buffer trim whitespace)
