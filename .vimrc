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

"Insert single character
nnoremap <Space> i_<Esc>r

"Change tabs:
map [5;5~ gT
map [6;5~ gt


"Map forward/backword words:
map [1;5C w
map [1;5D b
