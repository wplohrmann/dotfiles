require("config.lazy")

-- Settings
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true

vim.g.mapleader = ","

-- space -> Insert mode
vim.keymap.set('n', '<Space>', 'i')
-- enter -> Save file
vim.keymap.set('n', '<CR>', ':w<CR>')
-- Move back and forth between buffers
vim.keymap.set('n', 'l', 'gt')
vim.keymap.set('n', 'h', 'gT')
-- Find file
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>')

-- LSP
vim.lsp.config['basedpyright'] = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = 'standard',
            },
        },
    },
}
vim.lsp.enable('basedpyright')

-- Execute last command in the last tab again
vim.keymap.set('n', '<Leader>r', function()
    vim.fn.system("tmux send-keys -t ! Up Enter")
end)
