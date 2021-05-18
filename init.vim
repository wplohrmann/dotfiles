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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/vim-peekaboo'
call plug#end()

autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2
autocmd BufNewFile,BufRead *.tsx setlocal shiftwidth=2

autocmd BufNewFile,BufRead *.go setlocal noexpandtab
autocmd BufNewFile,BufRead *.go setlocal nolist
autocmd BufNewFile,BufRead *.go setlocal listchars=trail:~

"Coc setup
set signcolumn=yes
set cmdheight=2
nmap <Leader>d <Plug>(coc-definition)
nmap <Leader>t <Plug>(coc-type-definition)
nmap <Leader>a <Plug>(coc-references)
nmap <Leader>f <Plug>(coc-fix-current)
nmap <Leader>n <Plug>(coc-rename)
nmap <Leader>h :call CocAction("doHover")<CR>
vmap f :call CocAction("format")<CR>

"fzf setup
nmap <C-P> :GFiles<CR>

"Fugitive setup
nnoremap k :cp<CR>
nnoremap j :cn<CR>

"Close buffer
nnoremap <C-w> :bd<CR>

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
nnoremap l :bnext<CR>
nnoremap h :bprev<CR>

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
nnoremap <CR> :w<CR>

"Recognize .CPP files
autocmd BufNewFile,BufRead *.CPP set syntax=cpp

"Show trailing whitespace
set list!
set listchars=tab:>-,trail:~

"Enable folds by default
set foldmethod=syntax
set foldlevel=99

"Send current line to tmux pane
function! SendLine()
    let foo = getline(getcurpos()[1])
    call system("tmux send-keys -t ! '" . foo . "' Enter")
endfunction

noremap s :call SendLine()<CR>

"Send current line to tmux pane without indentation
function! SendLineWithoutIndent()
    let foo = join(split(getline(getcurpos()[1])))
    call system("tmux send-keys -t ! '" . foo . "' Enter")
endfunction

noremap S :call SendLineWithoutIndent()<CR>

nnoremap <Leader>r :call system("tmux send-keys -t ! Up Enter")<CR>


