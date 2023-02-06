#!/usr/bin/env fish

set -gx RBENV_VERSION "1.7.5"
set -gu RBENV_VERSION_OLD "2.0.0"
rbenv init - fish | source

RBENV_SHELL=fish rbenv shell -

if [ "$RBENV_VERSION" != "2.0.0" ]
  exit 1
end

if [ "$RBENV_VERSION_OLD" != "1.7.5" ]
  exit 1
end

exit 0
