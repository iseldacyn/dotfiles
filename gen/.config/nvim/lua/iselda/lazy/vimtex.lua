return {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
        -- VimTeX configuration goes here
        vim.g.vimtex_options = "let g:vimtex_view_method = 'zathura', let g:vimtex_compiler_method = 'latexrun'"
  end
}
