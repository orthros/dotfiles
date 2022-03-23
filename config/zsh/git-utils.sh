#!/usr/bin/env zsh

if [[ "${_GIT_UTILS_INCLUDE}" == true ]]; then
	return
fi

export _GIT_UTILS_INCLUDE=true

# Git Helper
function in_git_dir() {
  git rev-parse --git-dir &>/dev/null
  # If non zero we have an error code...
  if (( $? )); then
    return 1
  fi
  return 0
}

function get_origin_last_path() {
    echo $(git remote -v | rg '^origin\s+.+/([\w-]+)\s+\(fetch\)$' -r '$1' --only-matching)
}

function get_tmux_session_name() {
	local branch_name=$(git branch --no-color --show-current)
	local origin_path=$(get_origin_last_path)
	local session_name="Git-${origin_path}-${branch_name}"
	echo ${session_name}
}
