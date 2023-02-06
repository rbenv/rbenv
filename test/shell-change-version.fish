#!/usr/bin/env fish

set -gx RBENV_VERSION "1.7.5"
set -gx RBENV_ROOT "./"

rbenv init - fish | source

mkdir -p "$RBENV_ROOT/versions/1.2.3"

RBENV_SHELL=fish rbenv shell 1.2.3

if [ "$RBENV_VERSION" != "1.2.3" ]
  exit 1
end

if [ "$RBENV_VERSION_OLD" != "1.7.5" ]
  exit 1
end

rm -r "$RBENV_ROOT/versions/1.2.3"

exit 0
