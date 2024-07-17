return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio"
    },
    event = "InsertEnter", -- FIXME: should not be this event, but on keybind
    config = function ()
        require("dapui").setup()
    end
}
