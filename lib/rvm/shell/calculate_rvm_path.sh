#!/bin/bash

# Calculates a default rvm path

# Check first.
if [[ -n "$rvm_path" ]]; then
  echo "$rvm_path"
  exit
fi

# Load extra files.

[[ -s ~/.rvmrc ]] && source ~/.rvmrc >/dev/null 2>&1
[[ -s /etc/.rvmrc ]] && source /etc/rvmrc >/dev/null 2>&1

if [[ -n "$rvm_path" ]]; then
  echo "$rvm_path"
elif [[ -d ~/.rvm ]]; then
  echo "~/.rvm"
elif [[ -d /usr/local/rvm ]]; then
  echo "/usr/local/rvm"
else
  exit 1
fi

exit 0