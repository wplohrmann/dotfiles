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
Plug 'davidhalter/jedi-vim'
call plug#end()

"vimtex setup
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

"Ultisnips setup
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"Comment lines with one key stroke
nmap # gcc
vmap # gc

nmap , <Leader>
nmap f <Leader><Leader>f
nmap F <Leader><Leader>F
nmap t <Leader><Leader>t
nmap T <Leader><Leader>T

"Show possible autocompletions in command mode
set wildmenu

"Vim-jedi configs
let g:jedi#popup_on_dot=0
let g:jedi#popup_select_first=0
let g:jedi#completions_command=""

"Cycle through buffers
nnoremap l :bnext<CR>
nnoremap h :bprev<CR>
nnoremap j :ls<CR>:b

"All of the colours
set t_Co=256

"Airline options
let g:airline#extensions#tabline#enabled = 1

"Tabnine
" set rtp+=~/src/tabnine-vim

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
function SendLine()
    let foo = getline(getcurpos()[1])
    call system("tmux send-keys -t ! '" . foo . "' Enter")
endfunction

noremap s :call SendLine()<CR>

"Send current line to tmux pane without indentation
function SendLineWithoutIndent()
    let foo = join(split(getline(getcurpos()[1])))
    call system("tmux send-keys -t ! '" . foo . "' Enter")
endfunction

noremap S :call SendLineWithoutIndent()<CR>

function Pdb()
    execute "normal! oimport pdb; pdb.set_trace()"
endfunction
