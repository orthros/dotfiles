#!/bin/bash
if [ ! -x /usr/bin/git ]; then
        echo "Please ensure git is installed"
        exit
fi

if [ ! -x /usr/bin/vim ]; then
        echo "Please ensure vim is installed"
        exit
fi

mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors

cd ~/.vim/colors
curl -O https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim
cd -

cd ~/.vim/bundle
if [ ! -d ctrlp.vim ]; then
        git clone https://github.com/ctrlpvim/ctrlp.vim.git
fi
if [ ! -d nerdtree ]; then
        git clone https://github.com/scrooloose/nerdtree.git
fi
if [ ! -d vim-airline ]; then
        git clone https://github.com/vim-airline/vim-airline
fi
cd -

if [ ! -e ~/.vim/autoload/pathogen.vim ]; then
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi
cd -

curl -LSso ~/.vimrc https://raw.githubusercontent.com/orthros/dotfiles/master/.vimrc

