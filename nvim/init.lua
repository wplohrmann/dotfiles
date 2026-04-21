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

vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = ","
vim.diagnostic.config({ virtual_lines = {current_line = true} })


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
vim.lsp.config['lua_ls'] = {
  -- Command and arguments to start the server.
  cmd = { 'lua-language-server' },
  -- Filetypes to automatically attach to.
  filetypes = { 'lua' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    diagnostics = {
        globals = {"vim"}
    },
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}
vim.lsp.enable('lua_ls')

-- Run clangd inside the ncb_dev container when working in fusion-ncb, so it
-- can resolve /workspace/ncb and /opt/ros paths from the container's view.
local clangd_cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' }
if vim.fn.getcwd():match('/fusion%-ncb') then
    clangd_cmd = {
        'docker', 'exec', '-i', 'ncb_dev',
        'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu',
        '--path-mappings=' .. vim.fn.getcwd() .. '=/workspace/ncb',
    }
end
vim.lsp.config['clangd'] = {
  cmd = clangd_cmd,
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
}
vim.lsp.enable('clangd')


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'lua', 'json', 'toml', 'rust', 'c', 'cpp' },
  callback = function() vim.treesitter.start() end,
})

require('mini.files').setup({})
require('mini.hues').setup({
    background = '#11262d',
    foreground = '#c0c8cc',
    plugins = {
      default = false,
      ['nvim-mini/mini.nvim'] = true,
    },
})
require('mini.completion').setup({})
require('mini.pairs').setup({})
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

vim.keymap.set('n', '<C-n>', MiniFiles.open)
vim.keymap.set('n', '<Leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<Leader>r', ':Telescope lsp_references<CR>')
vim.keymap.set('n', '<Leader>d', ':Telescope lsp_definitions<CR>')
vim.keymap.set('n', '<Leader>n', vim.lsp.buf.rename)
vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<Leader>e', ':Telescope diagnostics<CR>')
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
vim.keymap.set('n', '<C-w>', ':bd<CR>', { nowait = true })
vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>')

local imap_expr = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true })
end
imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
_G.cr_action = function()
    -- If there is selected item in popup, accept it with <C-y>
    if vim.fn.complete_info()['selected'] ~= -1 then return '\25' end
    -- Fall back to plain `<CR>`. You might want to customize according
    -- to other plugins. For example if 'mini.pairs' is set up, replace
    -- next line with `return MiniPairs.cr()`
    return '\r'
end

vim.keymap.set('i', '<CR>', 'v:lua.cr_action()', { expr = true })

-- Open dotfiles in telescope
vim.api.nvim_create_user_command('Config', function()
    require('telescope.builtin').git_files({ cwd = vim.fn.expand('~/src/dotfiles') })
end, {})


vim.keymap.set('n', 'f', function() require("flash").jump() end )
vim.keymap.set('n', 'F', function() require("flash").treesitter() end )

-- Treewalker
vim.keymap.set('n', '<S-Right>', '<cmd>Treewalker Right<CR>', { silent = true })
vim.keymap.set('n', '<S-Left>', '<cmd>Treewalker Left<CR>', { silent = true })
vim.keymap.set('n', '<S-Up>', '<cmd>Treewalker Up<CR>', { silent = true })
vim.keymap.set('n', '<S-Down>', '<cmd>Treewalker Down<CR>', { silent = true })

-- REPL sender via tmux
_G.repl_indent = 0

local function tmux_send_lines(lines)
    for _, line in ipairs(lines) do
        vim.fn.system({ 'tmux', 'send-keys', '-t', '{last}', '-l', line })
        vim.fn.system({ 'tmux', 'send-keys', '-t', '{last}', 'Enter' })
    end
end

local function repl_send(lines)
    local min_indent = math.huge
    for _, line in ipairs(lines) do
        if line:match('%S') then
            min_indent = math.min(min_indent, #line:match('^%s*'))
        end
    end
    if min_indent == math.huge then min_indent = 0 end

    local prefix = string.rep(' ', _G.repl_indent)
    local out = {}
    for _, line in ipairs(lines) do
        if line:match('%S') then
            table.insert(out, prefix .. line:sub(min_indent + 1))
        end
    end

    tmux_send_lines(out)

    local last = out[#out]
    if not last:match('%S') then
        _G.repl_indent = 0
    elseif last:match(':%s*$') then
        _G.repl_indent = _G.repl_indent + 4
    end
end

vim.keymap.set('n', 's', function()
    repl_send({ vim.api.nvim_get_current_line() })
end)

vim.keymap.set('v', 's', function()
    local vstart = vim.fn.getpos('v')
    local vend = vim.fn.getpos('.')
    local start_line = math.min(vstart[2], vend[2])
    local end_line = math.max(vstart[2], vend[2])
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    repl_send(lines)
end)

vim.keymap.set('n', 'S', function()
    tmux_send_lines({ '' })
    _G.repl_indent = 0
end)

