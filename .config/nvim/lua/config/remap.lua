-- map leader
vim.g.mapleader = " "

-- "project view" (search directory)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- J and K swap in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- J swap and saves cursor place
vim.keymap.set("n", "J", "mzJ`z")

-- center screen when searching or moving screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- next greatest remap ever : asbjornHaland (copy to clipboard)
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete and dont copy
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- create new tmux window
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- jump to errors (quickfix/glb and location/local list)
vim.keymap.set("n", "<C-Up>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-Down>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- search and replace focused word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- compile latex files
vim.keymap.set("n", "<leader>ll", "<cmd>!latexmk -pdf %<CR><cmd>!latexmk -c<CR>", { silent = true })
vim.keymap.set("n", "<leader>lc", "<cmd>!latexmk -c<CR>", { silent = true })

-- create latex begin blocks
vim.keymap.set("n", "<leader>lp", "_yt}o<Esc>p_lcwend<Esc>A}<Esc>O<Esc>O<CR>")

-- disable lsp stuff
local diagnosticsVisible = true
vim.keymap.set("n", "<leader>ld", function()
    diagnosticsVisible = not diagnosticsVisible
    vim.diagnostic.config({
        virtual_text = diagnosticsVisible,
        underline = diagnosticsVisible
    }) end)
local formatOnSave = true
vim.keymap.set("n", "<leader>tf", function()
    formatOnSave = not formatOnSave
    vim.g.autoformat = formatOnSave
end
)

-- metals
vim.keymap.set("n", "<leader>mls", "<cmd>lua require'telescope'.extensions.metals.commands()<CR>")
