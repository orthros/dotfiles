"-----------------------------------------------------------
"  orthros settings
"-----------------------------------------------------------

"-----------------------------------------------------------
"  Pathogen
"-----------------------------------------------------------

execute pathogen#infect()
call pathogen#helptags()

"-----------------------------------------------------------
" General Features
"-----------------------------------------------------------

set number
syntax enable
set background=dark
colorscheme gruvbox
set mouse=a
set smartindent
set tabstop=4     " number of visual spaces per tab
set softtabstop=4 " number of spaces in tab when editing
set expandtab     " tabs resolve to spaces
set cursorline    " highlight current line
set showmatch     " highlight matching [{()}]
set incsearch     " search as characters are entered
set hlsearch      " highlight matches
set noswapfile
set backspace=indent,eol,start "Allow backspacing over everything in insert mode
set autoread      " If a file is changed outside of vim, automatically reload it witout asking


"-------------------------------------------------------------
"  Mappings
"-------------------------------------------------------------

map <C-b> :NERDTreeToggle<CR>


if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

