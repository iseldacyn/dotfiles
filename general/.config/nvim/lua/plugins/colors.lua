function colorSelector(color)
    -- replace with desired colorscheme
    color = color or "onelight"
    vim.o.background = "light"
    vim.cmd.colorscheme(color)
end

return {
    {
        "ellisonleao/gruvbox.nvim",

        config = function ()
            require('gruvbox').setup({
                transparent_mode = false,
            })

            vim.cmd("colorscheme gruvbox")

            colorSelector()
        end
    },

    {
        "rose-pine/neovim",

        config = function()
            require('rose-pine').setup({
                disable_background = false,
            })

            vim.cmd("colorscheme rose-pine")

            colorSelector()
        end
    },

    {
        "olimorris/onedarkpro.nvim",

        config = function()
            require('onedarkpro').setup({
                options = {
                    transparency = false,
                },
                colors = {
                    onelight = { bg = "#fafafa" },
                }
            })

            vim.cmd("colorscheme onedark")

            colorSelector()
        end
    },
}

