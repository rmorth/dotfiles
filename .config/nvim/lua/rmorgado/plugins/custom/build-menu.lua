local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local themes = require('telescope.themes')

local function run_command(cmd)
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(string.format("Error running command '%s': %s", cmd, result), vim.log.levels.ERROR)
    else
        vim.notify(string.format("Successfully ran command '%s'", cmd), vim.log.levels.INFO)
    end
    return result
end

local function generate_compile_commands(hw)
    local src = string.format("build_%s/compile_commands.json", hw)
    local dest = "compile_commands.json"
    local cmd = string.format("CMAKE_EXPORT_COMPILE_COMMANDS=1 make package HW=%s", hw)
    run_command(cmd)

    local ret = vim.fn.filereadable(src)
    if ret == false then
        print(string.format("File %s does not exist", src))
        return
    end

    if os.rename(src, dest) then
        vim.notify(string.format("Generated compile_commands.json for %s", hw), vim.log.levels.INFO)
    else
        vim.notify(string.format("Failed to generate compile_commands.json for %s", hw), vim.log.levels.ERROR)
    end
end

local function move_compile_commands(hw)
    local src = string.format("build_%s/compile_commands.json", hw)
    local dest = "compile_commands.json"

    if os.rename(src, dest) then
        print(string.format("Moved compile_commands.json for %s", hw))
    else
        print(string.format("Failed to move compile_commands.json for %s", hw))
    end
end
--
--local function setup_clangd_config(hw)
--    local config = string.format("CompileFlags:\n  Add: [\"-DHARDWARE=%s\"]", hw)
--    local file = io.open(".clangd", "w")
--    file:write(config)
--    file:close()
--    print(string.format("Configured .clangd for %s", hw))
--end

local build_menu = function()
    local hardwares = {"b2", "n1", "b0"}
    local jobs = "JOBS=12"
    local commands = {
        {name = "Build package", command = "Make package"},
        {name = "Build image", command = "Make image"},
        {name = "Dist-clean", command = "Make dist-clean"},
        {name = "Generate compile_commands.json", func = generate_compile_commands},
        {name = "Move compile_commands.json", func = move_compile_commands},
    }

    local results = {}
    for _, cmd in ipairs(commands) do
        for _, hw in ipairs(hardwares) do
            if cmd.command then
                table.insert(results, {
                    string.format("%s %s", cmd.name, hw:upper()), string.format("%s HW=%s %s", cmd.command, hw, jobs)
                })
            else
                table.insert(results, {
                    string.format("%s %s", cmd.name, hw:upper()), function() cmd.func(hw) end
                })
            end
        end
    end

    local opts = themes.get_dropdown({
        prompt_title = "Build Menu",
        results_title = false,
        previewer = false,
        layout_config = {
            width = 0.3,
            height = 0.3
        },
        finder = finders.new_table({
            results = results,
                -- Add more menu items here
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry[1],
                    ordinal = entry[1],
                    cmd = entry[2],
                }
            end
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local run_command = function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if type(selection.cmd) == "function" then
                    selection.cmd()
                else
                    vim.cmd(selection.cmd)
                end
            end
            map('i', '<CR>', run_command)
            map('n', '<CR>', run_command)
            return true
        end,
    })

    pickers.new(opts):find()
end

return {
    build_menu = build_menu
}

