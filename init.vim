call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'coffebar/neovim-project'
Plug 'Shatur/neovim-session-manager'
Plug 'preservim/nerdtree'

" Themes
Plug  'folke/tokyonight.nvim',

" LSP
Plug 'neovim/nvim-lspconfig'

" Parser
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' }

" UI
Plug 'nvim-tree/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'akinsho/toggleterm.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

call plug#end()

color tokyonight-moon

set cursorline
hi CursorLineNr guifg=#FFEA00

set number
set shiftwidth=4
set tabstop=4
set autoindent
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

require('neovim-project').setup {
    projects = { "~/projects/*" },
    picker = { type = "telescope" }
}

-- NERDTree
vim.keymap.set('n', '<leader>tt', '<cmd>NERDTreeToggle<CR>')
vim.keymap.set('n', '<leader>tr', '<cmd>NERDTree<CR>')
vim.keymap.set('n', '<leader>tf', '<cmd>NERDTreeFocus<CR>')
vim.keymap.set('n', '<leader>r', '<cmd>NERDTreeFind<CR>')

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
vim.lsp.config("intelephense", {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php" },
    settings = {
        intelephense = {
            diagnostics = { undefinedFunctions = false },
            files = { maxSize = 5000000 },
            environment = { includePaths = { vim.fn.getcwd() .. "/vendor" }, phpVersion = "8.4.15" },
            stubs = { "Core", "PDO", "Symfony" },
        },
    },
})

vim.lsp.config("javascript", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript" },
})

vim.lsp.enable("intelephense")
vim.lsp.enable("javascript")


-- Treesitter
vim.api.nvim_create_autocmd('FileType', {
 	pattern = { 'php', 'html', 'twig', 'css', 'sql', 'javascript' },
 	callback = function() vim.treesitter.start() end,
});

-- UI plugins
require('barbar').setup({
    insert_at_end = true,
    insert_at_start = false,
})

require('toggleterm').setup({
    persist_mode = true,
    direction = 'float',
    float_opts = { border = 'double', title_pos = 'center' }
})

-- General maps
-- remap repeat to \ 
vim.keymap.set('n', '\\', ';')
vim.keymap.set('n', ';', '<Nop>')

-- Telescope
vim.keymap.set('n', '<leader>ff', telescope.find_files)
vim.keymap.set('n', '<leader>fg', telescope.live_grep)
vim.keymap.set('n', '<leader>fb', telescope.buffers)
vim.keymap.set('n', '<leader>fh', telescope.help_tags)

-- Projects
vim.keymap.set('n', '<leader>p', '<cmd>NeovimProjectDiscover<CR>')

-- Indentation
vim.keymap.set('i', '<S-Tab>', '<C-O><<')

-- Buffers
vim.keymap.set('n', '1', '<Cmd>BufferGoto 1<CR>')
vim.keymap.set('n', '2', '<Cmd>BufferGoto 2<CR>')
vim.keymap.set('n', '3', '<Cmd>BufferGoto 3<CR>')
vim.keymap.set('n', '4', '<Cmd>BufferGoto 4<CR>')
vim.keymap.set('n', '5', '<Cmd>BufferGoto 5<CR>')
vim.keymap.set('n', '6', '<Cmd>BufferGoto 6<CR>')
vim.keymap.set('n', '7', '<Cmd>BufferGoto 7<CR>')
vim.keymap.set('n', '<S-A-l>', '<Cmd>BufferMoveNext<CR>')
vim.keymap.set('n', '<S-A-h>', '<Cmd>BufferMovePrevious<CR>')
vim.keymap.set('n', '<A-l>', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', '<A-h>', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<A-q>', '<Cmd>BufferClose<CR>')

-- Terminal
vim.keymap.set('n', '<A-t>', '<Cmd>ToggleTerm<CR>')
vim.keymap.set('t', '<A-t>', '<Cmd>ToggleTerm<CR>')

-- Coding
vim.keymap.set('n', '<S-r>', '<Cmd>redo<CR>')
vim.keymap.set('n', '<A-CR>', 'i<CR><Esc>')
vim.keymap.set('n', ';', 'A;<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', ',', 'A,<Esc>', { silent = true })

-- Snippets
vim.keymap.set('i', '<C-t>', '$this->')

-- Replacements
function toggleProtectionLevel()
	local word = vim.fn.expand("<cword>")

	if word == "private" then
		vim.cmd('normal! ciwpublic')
	elseif word == "public" then
		vim.cmd('normal! ciwprivate')
	end
end
vim.keymap.set('n', '<Tab>', toggleProtectionLevel)

vim.api.nvim_create_autocmd({"BufEnter", "FileType", "InsertEnter"}, {
    pattern = "php",
    callback = function()
        vim.opt_local.autoindent = true
        vim.opt_local.smartindent = true
    end
})
EOF
