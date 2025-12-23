call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'coffebar/neovim-project'
Plug 'Shatur/neovim-session-manager'
Plug 'preservim/nerdtree'

" Themes
Plug 'nickkadutskyi/jb.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'

" Parser
Plug 'nvim-treesitter/nvim-treesitter'

" UI
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'romgrk/barbar.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Coding
Plug 'nvim-mini/mini.pairs'

call plug#end()

color jb
set number

set smartindent
set shiftwidth=4
set tabstop=4
set guifont=Comic\ Mono:h16

let mapleader = " "

lua << EOF
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', telescope.find_files)
vim.keymap.set('n', '<leader>fg', telescope.live_grep)
vim.keymap.set('n', '<leader>fb', telescope.buffers)
vim.keymap.set('n', '<leader>fh', telescope.help_tags)

vim.opt.sessionoptions:append('globals')

require('neovim-project').setup {
	projects = {
		"~/projects/*"
	},
	picker = {
		type = "telescope"
	}
}

vim.keymap.set('n', '<leader>p', '<cmd>NeovimProjectDiscover<CR>')

-- NERDTree maps

vim.keymap.set('n', '<leader>tt', '<cmd>NERDTreeToggle<CR>')
vim.keymap.set('n', '<leader>tr', '<cmd>NERDTree<CR>')

-- CMP
local cmp = require('cmp')

cmp.setup({
	mapping = {
		['<C-space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
		{ name = 'path' }
	}
})

-- LSP
-- Define the config for intelephense
vim.lsp.config("intelephense", {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  settings = {
    intelephense = {
      files = { maxSize = 5000000 },
      environment = { includePaths = { vim.fn.getcwd() .. "/vendor" } },
      stubs = { "Core", "PDO", "Symfony" },
    },
  },
})

-- Enable the server for PHP buffers
vim.lsp.enable("intelephense")

-- Enable coding pairs (),{},[]
require('mini.pairs').setup();

-- Enable TreeSitter Parser
vim.api.nvim_create_autocmd('FileType', {
	pattern = {'html', 'twig', 'css', 'php'},
	callback = function()
		vim.treesitter.start()
	end,
})

-- Enable UI plugins
require('barbar').setup({
	insert_at_end = true,
	insert_at_start = false,
})

-- General maps

-- Identation
vim.keymap.set('i', '<S-Tab>', '<C-O><<')

-- Buffers
vim.keymap.set('n', '1', '<Cmd>BufferGoto 1<CR>')
vim.keymap.set('n', '2', '<Cmd>BufferGoto 2<CR>')
vim.keymap.set('n', '3', '<Cmd>BufferGoto 3<CR>')
vim.keymap.set('n', '4', '<Cmd>BufferGoto 4<CR>')
vim.keymap.set('n', '5', '<Cmd>BufferGoto 5<CR>')
vim.keymap.set('n', '<A-l>', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', '<A-h>', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<A-q>', '<Cmd>BufferClose<CR>')
EOF


