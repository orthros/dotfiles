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

# Keybindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

source $dotfile_config_path/zsh/.prompt

source $dotfile_config_path/zsh/.aliases

source $dotfile_config_path/zsh/.functions

source $dotfile_config_path/zsh/.completions

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# This section is to import any corporate specific config
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if [[ -r $dotfile_config_path/corp/.zsh  ]]; then
    source $dotfile_config_path/corp/.zsh
fi
