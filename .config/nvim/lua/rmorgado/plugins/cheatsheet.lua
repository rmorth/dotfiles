return {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim"
    },
    config = function()
        require("cheatsheet").setup({
            -- Whether to show bundled cheatsheets

            -- For generic cheatsheets like default, unicode, nerd-fonts, etc
            -- bundled_cheatsheets = {
            --     enabled = {},
            --     disabled = {},
            -- },
            bundled_cheatsheets = true,

            bundled_plugin_cheatsheets = true,

            include_only_installed_plugins = true,

            -- Key mappings bound inside the telescope window
            telescope_mappings = {
                ['<CR>'] = require('cheatsheet.telescope.actions').select_or_fill_commandline,
                ['<A-CR>'] = require('cheatsheet.telescope.actions').select_or_execute,
                ['<C-Y>'] = require('cheatsheet.telescope.actions').copy_cheat_value,
                ['<C-E>'] = require('cheatsheet.telescope.actions').edit_user_cheatsheet,
            }
        })
    end
}
