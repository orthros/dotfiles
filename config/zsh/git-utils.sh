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
    git remote -v | rg '^origin\s+.+/([\w.-]+?)(?:\.git)?\s+\(fetch\)$' -r '$1' --only-matching
}

function get_tmux_session_name() {
	local branch_name
	branch_name=$(git branch --no-color --show-current)
	if [[ -z "${branch_name}" ]]; then
		branch_name=$(git rev-parse --short HEAD 2>/dev/null)
	fi
	local origin_path
	origin_path=$(get_origin_last_path)
	if [[ -z "${origin_path}" ]]; then
		origin_path=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
	fi
	local session_name="Git-${origin_path}-${branch_name}"
	echo "${session_name}"
}

function tmux() {
	if [[ $# -ne 0 ]]; then
		command tmux "$@"
	elif jj root &>/dev/null; then
		local repo_name=""
		if in_git_dir; then
			repo_name=$(get_origin_last_path)
		fi
		if [[ -z "${repo_name}" ]]; then
			repo_name=$(basename "$(jj root)")
		fi
		local rev_name
		rev_name=$(jj log --no-graph -r @ -T 'if(bookmarks, bookmarks.join("-"), change_id.short(8))' 2>/dev/null)
		command tmux new -s "JJ-${repo_name}-${rev_name}"
	elif in_git_dir; then
		local session_name
		session_name=$(get_tmux_session_name)
		command tmux new -s "${session_name}"
	else
		command tmux
	fi
}
