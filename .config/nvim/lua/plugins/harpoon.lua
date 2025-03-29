return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",

    dependencies = { 
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "mike-jl/harpoonEx",
    },

    config = function ()
        local harpoon = require('harpoon')

        harpoon:setup()

        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

        local harpoonEx = require('harpoonEx')
        vim.keymap.set("n", "<leader>sh", function()
            harpoonEx.telescope_live_grep(harpoon:list())
        end, { desc = "Live grep harpoon files" })

        vim.keymap.set("n", "<C-e>", function()
            require("telescope").extensions.harpoonEx.harpoonEx({
                -- Optional: modify mappings, default mappings:
                attach_mappings = function(_, map)
                    local actions = require("telescope").extensions.harpoonEx.actions
                    map({ "i", "n" }, "<C-d>", actions.delete_mark)
                    map({ "i", "n" }, "<C-k>", actions.move_mark_up)
                    map({ "i", "n" }, "<C-j>", actions.move_mark_down)
                    return true
                end,
            })
            return true
        end, { desc = "Open harpoon window" })
    end
}
