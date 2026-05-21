lua << EOF
vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/coffebar/neovim-project" },
    { src = "https://github.com/Shatur/neovim-session-manager" },
    { src = "https://github.com/preservim/nerdtree" },

    -- Themes
    { src = "https://github.com/folke/tokyonight.nvim" },

    -- LSP
    { src = "https://github.com/neovim/nvim-lspconfig" },

    -- Parser
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

    -- UI
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/romgrk/barbar.nvim" },
    { src = "https://github.com/akinsho/toggleterm.nvim" },

    -- Git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },

    -- Autocompletion
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/hrsh7th/cmp-cmdline" },
})

vim.cmd.colorscheme("tokyonight-moon")

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFEA00" })

vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.g.mapleader = " "

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
    root_markers = { "composer.json", ".git" },
    settings = {
        intelephense = {
            diagnostics = { undefinedFunctions = false },
            files = { maxSize = 5000000 },
            environment = { includePaths = { vim.fn.getcwd() .. "/vendor" }, phpVersion = "8.4.15" },
            stubs = {
                "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype",
                "curl", "date", "dba", "dom", "enchant", "exif", "FFI", "fileinfo",
                "filter", "fpm", "ftp", "gd", "gettext", "gmp", "hash", "iconv", "imap",
                "intl", "json", "ldap", "libxml", "mbstring", "meta", "mysqli", "oci8",
                "odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql",
                "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", "pspell", "readline",
                "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets",
                "sodium", "SPL", "sqlite3", "standard", "superglobals", "sysvmsg",
                "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc",
                "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib", "Symfony",
            },
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

require('gitsigns').setup()

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

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)

-- Coding
vim.keymap.set('n', '<S-r>', '<Cmd>redo<CR>') -- Redo
vim.keymap.set('n', '<A-CR>', 'i<CR><Esc>') -- Set current line to new line
vim.keymap.set('n', ';', 'A;<Esc>', { noremap = true, silent = true }) -- append ;
vim.keymap.set('n', ',', 'A,<Esc>', { silent = true }) -- append ,

-- Split
vim.keymap.set('n', 'vs', '<Cmd>vs<CR>');

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
