vim.cmd([[
	set tabstop=4
	set shiftwidth=4
	
	set number
	set relativenumber

	set textwidth=0
	set wrapmargin=0
	set wrap
	set linebreak
	set display+=truncate
	
	set encoding=utf-8
	
	set termguicolors
	syntax enable
	colorscheme truedark

	let g:vimtex_view_method = 'zathura'
	let g:vimtex_compiler_method = 'latexrun'
	]])

require("plugins")
require("treesitter")
require("nvim-cmp")
