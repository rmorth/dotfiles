return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "vim-lua/plenary.nvim"
    },
    opts = {
        is_insert_mode = true,
        use_trouble_qf = true,
    },
    config = function()
        -- Keymaps are now managed in core/keymaps.lua for better organization
        -- Main spectre toggle: <leader>S (direct action)
        -- Additional spectre operations could be added to a submenu if needed
    end
}
