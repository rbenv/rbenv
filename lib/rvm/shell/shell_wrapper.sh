# Prints an epilog to a shell command.
__rvm_show_command_epilog() {
  local _code="$?"
  echo "---------------RVM-RESULTS-START---------------"
  ruby -rrubygems -ryaml -e \
      "puts YAML.dump({'environment' => ENV.to_hash, 'exit_status' => '${_code}'})"
  echo "----------------RVM-RESULTS-END----------------"
}

