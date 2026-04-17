require("config.lazy")

-- Settings
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.o.autoread = true

vim.g.clipboard = 'tmux'
vim.g.mapleader = ","

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
})


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



require('mini.diff').setup({})
require('mini.git').setup({})
require('mini.icons').setup({})
require('mini.statusline').setup({})
require('mini.tabline').setup({})
require('mini.comment').setup({
    mappings = {
      -- Toggle comment (like `gcip` - comment inner paragraph) for both
      -- Normal and Visual modes
      comment = 'gc',

      -- Toggle comment on current line
      comment_line = '<C-_>',

      -- Toggle comment on visual selection
      comment_visual = '<C-_>',

      -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      -- Works also in Visual mode if mapping differs from `comment_visual`
      textobject = 'gc',
    },
})

vim.keymap.set('n', '<Leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<Leader>r', ':Telescope lsp_references<CR>')
vim.keymap.set('n', '<Leader>d', ':Telescope lsp_definitions<CR>')
vim.keymap.set('n', '<Leader>n', vim.lsp.buf.rename)
vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<Leader>t', vim.lsp.buf.type_definition)

-- space -> Insert mode
vim.keymap.set('n', '<Space>', 'i')
-- enter -> Save file
vim.keymap.set('n', '<CR>', ':w<CR>')
-- Move back and forth between buffers
vim.keymap.set('n', 'l', ':bNext<CR>')
vim.keymap.set('n', 'h', ':bprevious<CR>')
-- Find file
vim.keymap.set('n', '<C-p>', ':Telescope git_files<CR>')
vim.keymap.set('n', '<C-w>', ':bd<CR>')
vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>')

-- Open dotfiles in telescope
vim.api.nvim_create_user_command('Config', function()
    require('telescope.builtin').find_files({ cwd = vim.fn.expand('~/src/dotfiles') })
end, {})

-- Execute last command in the last tab again
vim.keymap.set('n', '<Leader>r', function()
    vim.fn.system("tmux send-keys -t ! Up Enter")
end)
