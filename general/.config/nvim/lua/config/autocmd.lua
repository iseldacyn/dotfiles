vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function ()
        local bufmap = function(mode, lhs, rhs)
            local opts = {buffer = true}
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        bufmap('n', 'K', '<cmd> lua vim.lsp.buf.hover()<cr>')
        bufmap('n', 'gd', '<cmd> lua vim.lsp.buf.definition()<cr>')
        bufmap('n', 'gD', '<cmd> lua vim.lsp.buf.declaration()<cr>')
        bufmap('n', 'gi', '<cmd> lua vim.lsp.buf.implementation()<cr>')
        bufmap('n', 'go', '<cmd> lua vim.lsp.buf.type_definition()<cr>')
        bufmap('n', 'gr', '<cmd> lua vim.lsp.buf.references()<cr>')
        bufmap('n', 'gs', '<cmd> lua vim.lsp.buf.signature_help()<cr>')
        bufmap('n', '<F2>', '<cmd> lua vim.lsp.buf.rename()<cr>')
        bufmap('n', '<F4>', '<cmd> lua vim.lsp.buf.code_action()<cr>')
        bufmap('n', 'gl', '<cmd> lua vim.diagnostic.open_float()<cr>')
        bufmap('n', '[d', '<cmd> lua vim.diagnostic.goto_prev()<cr>')
        bufmap('n', ']d', '<cmd> lua vim.diagnostic.goto_next()<cr>')
    end
})

-- Create an event handler for the FileType autocommand
vim.api.nvim_create_autocmd('FileType', {
    -- This handler will fire when the buffer's 'filetype' is "python"
    pattern = {'verilog', 'systemverilog'},
    callback = function()
        vim.lsp.start({
            name = 'verible',
            cmd = {
                'verible-verilog-ls',
                '--rules_config_search',
                '--indentation_spaces=4',
            },
        })
    end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.v",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})
