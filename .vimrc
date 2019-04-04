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

so ~/.vim/plugins.vim

"Nerdtree: 
map <C-o> :NERDTreeToggle<CR>

"Enter insert mode
nnoremap <Space> i

"Change tabs:
nnoremap [5;5~ gT
nnoremap [6;5~ gt
"inoremap [5;5~ <Esc>
"inoremap [6;5~ <Esc>

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
