set hlsearch
set ignorecase
set autoindent
set smartcase
set expandtab
set tabstop=4
set shiftwidth=4
set number
filetype indent on
filetype plugin indent on

"VimPlug
 if empty(glob('~/.config/nvim/autoload/plug.vim'))
   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   autocmd VimEnter * PlugInstall --sync | source ~/.config/init.vim
endif

call plug#begin("~/.config/nvim/plugged")
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'lervag/vimtex'
Plug 'sirver/ultisnips'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'AndrewRadev/sideways.vim'
Plug 'liuchengxu/vista.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/vim-peekaboo'
Plug 'mogelbrod/vim-jsonpath'
call plug#end()

autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2
autocmd BufNewFile,BufRead *.tsx setlocal shiftwidth=2

autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2
autocmd BufNewFile,BufRead *.yaml setlocal shiftwidth=2

autocmd BufNewFile,BufRead *.go setlocal noexpandtab
autocmd BufNewFile,BufRead *.go setlocal nolist
autocmd BufNewFile,BufRead *.go setlocal listchars=trail:~


"Coc setup
if exists('g:vscode')
    " VSCode extension
    nmap <Leader>d :call VSCodeNotify("editor.action.revealDefinition")<CR>
    nmap <Leader>t :call VSCodeNotify("editor.action.goToTypeDefinition")<CR>
    nmap <Leader>h :call VSCodeNotify("editor.action.showHover")<CR>
else
    set signcolumn=yes
    set cmdheight=2
    nmap <Leader>d <Plug>(coc-definition)
    nmap <Leader>t <Plug>(coc-type-definition)
    nmap <Leader>a <Plug>(coc-references)
    nmap <Leader>f <Plug>(coc-fix-current)
    nmap <Leader>n <Plug>(coc-rename)
    nmap <Leader>h :call CocAction("doHover")<CR>
    vmap f :call CocAction("format")<CR>
endif

"fzf setup
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

nmap <C-P> :GFiles<CR>
nmap <C-G> :GGrep<CR>

"Vista setup
let g:vista_default_executive="coc"
nnoremap <C-f> :Vista finder<CR>


"Fugitive setup
nnoremap k :cp<CR>
nnoremap j :cn<CR>

"Close buffer
if exists('g:vscode')
    nnoremap <C-w> :call VSCodeNotify("workbench.action.closeActiveEditor")<CR>
else
    nnoremap <C-w> :bd<CR>
endif

"Move a single line up/down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv


"vimtex setup
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

"Comment lines with one key stroke
nmap # gcc
vmap # gc

nmap , <Leader>
nmap f <Plug>(easymotion-s)
nmap F <Plug>(easymotion-repeat)

"For consistency with D and C
nmap Y y$

"Show possible autocompletions in command mode
set wildmenu
set path +=**


"Cycle through buffers
if exists('g:vscode')
    " VSCode extension
    nnoremap h :call VSCodeNotify("workbench.action.previousEditor")<CR>
    nnoremap l :call VSCodeNotify("workbench.action.nextEditor")<CR>
else
    nnoremap l :bnext<CR>
    nnoremap h :bprev<CR>
endif

"All of the colours
set t_Co=256
set background=dark
color pablo
highlight Pmenu ctermbg=lightgray

"Airline options
let g:airline#extensions#tabline#enabled = 1

"Tabnine
" set rtp+=~/src/tabnine-vim

" Allow switching buffers without saving
set hidden


"sidways.vim remaps
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

"Enter insert mode

nnoremap <Space> i

"Map ENTER in normal mode to save
if exists('g:vscode')
    " VSCode extension
    nnoremap <CR> :Write<CR>
else
    nnoremap <CR> :w<CR>
endif


"Recognize .CPP files
autocmd BufNewFile,BufRead *.CPP set syntax=cpp

"Show trailing whitespace
set list!
set listchars=tab:>-,trail:~

"Enable folds by default
set foldmethod=syntax
set foldlevel=99


if exists('g:vscode')
    function SendLineWithoutIndent() range
        let startLine = line("'<")
        let indent = match(getline(startLine), '\S') + 1
        let endLine = line("'>")
        let currentLine = startLine
        while currentLine <= endLine
            call VSCodeCallRangePos("workbench.action.terminal.runSelectedText", currentLine, currentLine, indent, 9000, 0)<CR>
            let currentLine +=1
            echom currentLine
        endwhile
    endfunction
    function SendLine() range
        let startLine = line("'<")
        let endLine = line("'>")
        :call VSCodeNotifyRange("workbench.action.terminal.runSelectedText", startLine, endLine, 0)<CR>
    endfunction
    vnoremap S :call SendLineWithoutIndent()<CR>
    nnoremap S :call VSCodeNotify("workbench.action.terminal.runSelectedText")<CR>
    vnoremap s :call SendLine()<CR>
    nnoremap s :call VSCodeNotify("workbench.action.terminal.runSelectedText")<CR>
else
    "Send current line to tmux pane
    function! SendLine()
        let foo = getline(getcurpos()[1])
        call system("tmux send-keys -t ! '" . foo . "' Enter")
    endfunction

    "Send current line to tmux pane without indentation
    function! SendLineWithoutIndent()
        let foo = join(split(getline(getcurpos()[1])))
        call system("tmux send-keys -t ! '" . foo . "' Enter")
    endfunction

    noremap S :call SendLineWithoutIndent()<CR>
    noremap s :call SendLine()<CR>
endif


if exists('g:vscode')
    " text = up + enter
    nnoremap <Leader>r :call VSCodeNotify("workbench.action.terminal.sendSequence", {"text": "\u001b[A\u000d"})<CR>
else
    nnoremap <Leader>r :call system("tmux send-keys -t ! Up Enter")<CR>
endif

if exists('g:vscode')
    function! Flake8()
        call VSCodeNotify("workbench.action.terminal.sendSequence", {"text": "flake8 --exclude=nb_\\*,venv --max-line-length=120\u000d"})
    endfunction
else
    function! Flake8()
        call system("tmux send-keys -t ! 'flake8 --exclude=nb_\\*,venv --max-line-length=120' Enter")
    endfunction
endif

if exists('g:vscode')
    function! Mypy()
        call VSCodeNotify("workbench.action.terminal.sendSequence", {"text": "mypy . --ignore-missing-imports --exclude \"nb_*|venv\"\u000d"})
    endfunction
else
    function! Mypy()
        call system("tmux send-keys -t ! 'mypy . --ignore-missing-imports --exclude \"nb_*|venv\"' Enter")
    endfunction
endif

if exists('g:vscode')
    "VSCode prepends nvim buffer path with __vscode_neovim__-file:// so need to remove that first
    function! AutoPep8()
        call VSCodeNotify("workbench.action.terminal.sendSequence", {"text": "autopep8 " . expand("%")[25:] . " --in-place\u000d"})
    endfunction
else
    function! AutoPep8()
        call system("tmux send-keys -t ! 'autopep8 " . expand("%") . " --in-place' Enter")
    endfunction
endif

