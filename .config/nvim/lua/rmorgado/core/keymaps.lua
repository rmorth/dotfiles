local noremap = {
    noremap = true
}

local silent = {
    silent = true
}

local silent_noremap = {unpack(silent), unpack(noremap)}

--
--
--

vim.g.mapleader = ' '

-- Disable whatever this is called
vim.api.nvim_set_keymap("", "Q", "<Nop>", noremap)

-- Resize split windows using arrow keys
vim.api.nvim_set_keymap("", "<C-up>", "<C-w>+", noremap)
vim.api.nvim_set_keymap("", "<C-down>", "<C-w>-", noremap)
vim.api.nvim_set_keymap("", "<C-left>", "<C-w>>", noremap)
vim.api.nvim_set_keymap("", "<C-right>", "<C-w><", noremap)

-----------------
-- NORMAL MODE --
-----------------

-- Navigate split windows
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", noremap)
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", noremap)
vim.api.nvim_set_keymap("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", noremap)
vim.api.nvim_set_keymap("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", noremap)

-- Explorer
-- vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)
-- Now handled by mini

-- Change Y to act like C, D
vim.api.nvim_set_keymap("n", "Y", "y$", {})

-- Change the behaviour of pressing the letter o, don't go into insert mode.
vim.api.nvim_set_keymap("n", "o", "o<esc>", noremap)
vim.api.nvim_set_keymap("n", "O", "O<esc>", noremap)

-- Center cursor when going through search matches
vim.api.nvim_set_keymap("n", "n", "nzzzv", noremap)
vim.api.nvim_set_keymap("n", "N", "Nzzzv", noremap)

-- Center cursor when scrolling
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", noremap)
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", noremap)

-- Do J without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Replace selected word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-----------------
-- VISUAL MODE --
-----------------

-- Move blocks in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Select a word and paste over it [x == Visual but not Select]
vim.keymap.set("x", "<leader>p", [["_dP]])
