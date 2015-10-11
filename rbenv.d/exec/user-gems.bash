if [[ "$RBENV_COMMAND" = "gem" && "$RBENV_VERSION" != "system" ]]; then
  # hax to reuse logic from `which` hook without repeating it
  orig_command_path="$RBENV_COMMAND_PATH"
  RBENV_COMMAND_PATH=""
  source "${BASH_SOURCE%/*}/../which/user-gems.bash"
  if [ -n "$RBENV_COMMAND_PATH" ]; then
    # add user install location to PATH to silence RubyGems warning when installing
    export PATH="${RBENV_COMMAND_PATH%/gem}:$PATH"
  fi
  RBENV_COMMAND_PATH="$orig_command_path"
  unset orig_command_path
fi
