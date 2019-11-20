set hlsearch
set ignorecase
set autoindent
set smartcase
set expandtab
set tabstop=4
set shiftwidth=4
set number
filetype indent on

inoremap <S-Tab> <C-d>

"Make vim recognize aliases
set shellcmdflag=-ic

"Enter insert mode
nnoremap <Space> i

"Change tabs:
nnoremap [5;5~ gT
nnoremap [6;5~ gt
set tabpagemax=100

"Map forward/backword words:
nnoremap [1;5C w
nnoremap [1;5D b
inoremap [1;5C <Esc>
inoremap [1;5D <Esc>

"Map ENTER in normal mode to save
nnoremap <CR> :w<CR>

"Recognize .CPP files
autocmd BufNewFile,BufRead *.CPP set syntax=cpp

set showtabline=2

"Show trailing whitespace
set list!
set listchars=tab:>-,trail:~

"Enable folds by default
set foldmethod=syntax
set foldlevel=99

"Send current line to tmux pane
function SendLine()
    let foo = getline(getcurpos()[1])
    call system("tmux send-keys -t 1 '" . foo . "' Enter")
endfunction

noremap s :call SendLine()<CR>
