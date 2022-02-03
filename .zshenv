#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Zsh Environmental Variables
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# Export config location for global usage.
export dotfile_config_path="$HOME/.config"

# Source zsh startup files from:  ~/.config/zsh
export ZDOTDIR="$dotfile_config_path/zsh"
. $ZDOTDIR/.zshenv
