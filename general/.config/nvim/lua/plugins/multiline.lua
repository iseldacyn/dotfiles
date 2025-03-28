return {
    "mg979/vim-visual-multi",
    branch = "master",

    init = function ()

        vim.g.VM_default_mappings = 0
 
        vim.g.VM_maps = nil
        vim.g.VM_maps = {
            ["Add Cursor Down"]    = '<M-j>'            ,
            ["Add Cursor Up"]      = '<M-k>'            ,
            ["Select Cursor Down"] = '<M-C-j>'          ,
            ["Select Cursor Up"]   = '<M-C-k>'          ,

            ["Select All"]         = '<M-A>'            ,
            ["Align"]              = '<M-a>'            ,
            ["Undo"]               = 'u'                ,
            ["Redo"]               = '<C-r>'            ,

            ["Visual Cursors"]      = '<M-c>'           ,

            ["Mouse Cursor"]       = '<M-LeftMouse>'    ,
            ["Mouse Word"]         = '<M-RightMouse>'   ,
            ["Mouse Column"]       = '<M-C-RightMouse>' ,
        }
    end,
}
