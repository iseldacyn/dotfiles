return {
    "mg979/vim-visual-multi",
    branch = "master",

    init = function ()

        vim.g.VM_default_mappings = 0
 
        vim.g.VM_maps = nil
        vim.g.VM_maps = {
            ["Add Cursor Down"] = '<M-j>',
            ["Add Cursor Up"] = '<M-k>',
            ["Undo"] = 'u',
            ["Redo"] = '<C-r>',
        }
    end,
}
