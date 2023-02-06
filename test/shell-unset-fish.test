#!/usr/bin/env fish

set -gx RBENV_VERSION "1.7.5"

rbenv init - fish | source

RBENV_SHELL=fish rbenv shell --unset

if [ "$RBENV_VERSION" != "" ]
  exit 1
end

if [ "$RBENV_VERSION_OLD" != "1.7.5" ]
  exit 1
end

exit 0
