set hlsearch
set ignorecase
set autoindent
set smartcase
set expandtab
set tabstop=4
set shiftwidth=4
set number
filetype indent on

"VimPlug
 if empty(glob('~/.vim/autoload/plug.vim'))
   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin("~/.vim/plugged")
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'lervag/vimtex'
Plug 'sirver/ultisnips'
Plug 'leafgarland/typescript-vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'AndrewRadev/sideways.vim'
call plug#end()

"vimtex setup
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

"Comment lines with one key stroke
nmap # gcc
vmap # gc

nmap , <Leader>
nmap f <Leader><Leader>f
nmap F <Leader><Leader>F
nmap t <Leader><Leader>t
nmap T <Leader><Leader>T

nnoremap <Leader>f f
nnoremap <Leader>f f
nnoremap <Leader>t t
nnoremap <Leader>T T

"For consistency with D and C
nmap Y y$

"Show possible autocompletions in command mode
set wildmenu
set path +=**

"YouCompleteMe Shortcuts
nmap <Leader>g :YcmCompleter GoTo<CR>
nmap <Leader>r :YcmCompleter GoToReferences<CR>
nmap <Leader>t :YcmCompleter GetType<CR>
nmap <Leader>d :YcmCompleter GetDoc<CR>
nmap <Leader>f :YcmCompleter Format<CR>
nmap <Leader>h :YcmCompleter FixIt<CR>
let g:ycm_show_diagnostics_ui = 0
"Cycle through buffers
nnoremap l :bnext<CR>
nnoremap h :bprev<CR>

"All of the colours
set t_Co=256
set background=dark
color pablo

"Airline options
let g:airline#extensions#tabline#enabled = 1

"Tabnine
" set rtp+=~/src/tabnine-vim

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
