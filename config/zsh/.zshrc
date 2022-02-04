#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Config/ Zsh Run Commands
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# `.zshrc' is sourced in interactive shells. It should contain
# commands to set up aliases, functions, options, key bindings,
# etc.

# Assumptions:
# * ${dotfile_config_path} is set to config directory's path

if type brew &>/dev/null
then
  # This is a HACK b/c for whatever reason
  # brew requires FPATH to be set before compinit
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

setopt PROMPT_SUBST

# History
export HISTFILE=~/.zsh_history
# Immediatly appends history
setopt INC_APPEND_HISTORY
export HISTSIZE=1000
export SAVEHIST=1000



# Keybindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

source $dotfile_config_path/zsh/.prompt

source $dotfile_config_path/zsh/.aliases

source $dotfile_config_path/zsh/.functions

source $dotfile_config_path/zsh/.completions

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Super hack for if we have alacritty and peco
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if [[ $TERM == "alacritty" && $(command -v peco &>/dev/null) != 0 ]]; then
  if command -v peco &>/dev/null; then
    # peco does not support the alacritty terminal
    # as one of it's dependencies (termbox) does not
    # support "alacritty". If our terminal is alacritty then
    # set the term variable to xterm-256color
    TERM=xterm-256color
  fi
fi

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# This section is to import any corporate specific config
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if [[ -r $dotfile_config_path/corp/.zsh  ]]; then
    source $dotfile_config_path/corp/.zsh
fi
