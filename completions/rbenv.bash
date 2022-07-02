_rbenv() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(rbenv commands)" -- "$word") )
  else
    local completions=$(rbenv completions "${COMP_WORDS[@]: -2:1}")
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _rbenv rbenv
