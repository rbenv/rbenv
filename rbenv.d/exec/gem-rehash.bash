if [[ ":$RUBYLIB:" != *":${BASH_SOURCE%.bash}:"* ]]; then
  RUBYLIB="${BASH_SOURCE%.bash}:$RUBYLIB"
fi
export RUBYLIB
