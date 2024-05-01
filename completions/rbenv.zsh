if [[ ! -o interactive ]]; then
    return
fi

compdef _rbenv rbenv

_rbenv() {
  local completions

  emulate -L zsh

  if [ "${#words}" -eq 2 ]; then
    completions="$(rbenv commands)"
  else
    completions="$(rbenv completions ${words[2,-2]})"
  fi

  compadd - "${(ps:\n:)completions}"
}
