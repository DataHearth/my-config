vim.g.mapleader = " " -- leader key is space
vim.cmd("set number")

vim.cmd("highlight NvimTreeFolderIcon guibg=blue")
vim.cmd("set termguicolors")

vim.cmd("nnoremap <C-n> :NvimTreeToggle<CR>")
vim.cmd("nnoremap <leader>r :NvimTreeRefresh<CR>")
vim.cmd("nnoremap <leader>n :NvimTreeFindFile<CR>")
