#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Config/ Zsh Environmental Variables
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autoload -U select-word-style
select-word-style bash

source $dotfile_config_path/zsh/.path

# use a tty for gpg
# solves error: "gpg: signing failed: Inapporopriate ioctl for device"
GPG_TTY=$(tty)
export GPG_TTY
