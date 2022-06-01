local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/autoload/plugged')

-- tree
Plug 'kyazdani42/nvim-tree.lua'

-- cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

-- snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug "rafamadriz/friendly-snippets"

-- lsp
Plug "williamboman/nvim-lsp-installer"
Plug('neovim/nvim-lspconfig')

-- themes
Plug('EdenEast/nightfox.nvim')

-- statusline
Plug('nvim-lualine/lualine.nvim')
Plug('kyazdani42/nvim-web-devicons')

-- syntax highlighting
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

-- indentation
Plug('lukas-reineke/indent-blankline.nvim')

vim.call('plug#end')
