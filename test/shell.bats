#!/usr/bin/env bats

load test_helper

@test "shell integration disabled" {
  run rbenv shell
  assert_failure "rbenv: shell integration not enabled. Run \`rbenv init' for instructions."
}

@test "shell integration enabled" {
  eval "$(rbenv init -)"
  run rbenv shell
  assert_success "rbenv: no shell-specific version configured"
}

@test "no shell version" {
  mkdir -p "${RBENV_TEST_DIR}/myproject"
  cd "${RBENV_TEST_DIR}/myproject"
  echo "1.2.3" > .ruby-version
  RBENV_VERSION="" run rbenv-sh-shell
  assert_failure "rbenv: no shell-specific version configured"
}

@test "no shell version (end-to-end test)" {
  mkdir -p "${RBENV_TEST_DIR}/myproject"
  cd "${RBENV_TEST_DIR}/myproject"
  echo "1.2.3" > .ruby-version
  eval "$(rbenv init -)"
  RBENV_VERSION="" run rbenv shell
  assert_output "rbenv: no shell-specific version configured"
}

@test "shell version" {
  RBENV_SHELL=bash RBENV_VERSION="1.2.3" run rbenv-sh-shell
  assert_success 'echo "$RBENV_VERSION"'
}

@test "shell version (end-to-end test)" {
  eval "$(rbenv init -)"
  RBENV_SHELL=bash RBENV_VERSION="1.2.3" run rbenv shell
  assert_output '1.2.3'
}

@test "shell version (fish)" {
  RBENV_SHELL=fish RBENV_VERSION="1.2.3" run rbenv-sh-shell
  assert_success 'echo "$RBENV_VERSION"'
}

@test "shell version (fish, end-to-end test)" {
  eval "$(rbenv init -)"
  RBENV_SHELL=fish RBENV_VERSION="1.2.3" run rbenv shell
  assert_output '1.2.3'
}

@test "shell unset (fish)" {
  RBENV_SHELL=fish run rbenv-sh-shell --unset
  assert_success
  assert_output <<OUT
set -gu RBENV_VERSION_OLD "\$RBENV_VERSION"
set -e RBENV_VERSION
OUT
}

@test "shell unset (fish, end-to-end test)" {
  FISH_PATH="$(command -v fish || echo 'fish not found')"
  if [ "fish not found" = "$FISH_PATH" ]; then
    skip
  else
    run "$(dirname BASH_SOURCE[0])/test/shell-unset.fish"
    assert_success
  fi
}

@test "shell revert" {
  RBENV_SHELL=bash run rbenv-sh-shell -
  assert_success
  assert_line 0 'if [ -n "${RBENV_VERSION_OLD+x}" ]; then'
}

@test "shell revert (end-to-end test)" {
  eval "$(rbenv init -)"
  RBENV_VERSION=1.7.5
  RBENV_VERSION_OLD=2.0.0

  rbenv shell -

  assert_equal $RBENV_VERSION 2.0.0
  assert_equal $RBENV_VERSION_OLD 1.7.5
}

@test "shell revert (fish)" {
  RBENV_SHELL=fish run rbenv-sh-shell -
  assert_success
  assert_line 0 'if set -q RBENV_VERSION_OLD'
}

@test "shell revert (fish, end-to-end test)" {
  FISH_PATH="$(command -v fish || echo 'fish not found')"

  if [ "fish not found" = "$FISH_PATH" ]; then
    skip
  else
    run "$(dirname BASH_SOURCE[0])/test/shell-revert.fish"
    assert_success
  fi
}

@test "shell unset" {
  RBENV_SHELL=bash run rbenv-sh-shell --unset
  assert_success
  assert_output <<OUT
RBENV_VERSION_OLD="\${RBENV_VERSION-}"
unset RBENV_VERSION
OUT
}

@test "shell unset (end-to-end test)" {
  eval "$(rbenv init -)"
  RBENV_VERSION=1.7.5
  unset RBENV_VERSION_OLD

  assert_equal "$RBENV_VERSION" 1.7.5
  assert [ -z "${RBENV_VERSION_OLD+x}" ];

  rbenv shell --unset

  assert_equal $RBENV_VERSION_OLD 1.7.5
  assert [ -z "${RBENV_VERSION+x}" ];
}

@test "shell unset (end-to-end test)" {
  eval "$(rbenv init -)"
  RBENV_VERSION="2.7.5" run rbenv shell

  assert_output "2.7.5"
}

@test "shell change invalid version" {
  run rbenv-sh-shell 1.2.3
  assert_failure
  assert_output <<SH
rbenv: version \`1.2.3' not installed
false
SH
}

@test "shell change invalid version (end-to-end test)" {
  eval "$(rbenv init -)"

  run rbenv shell 1.2.3

  assert_output "rbenv: version \`1.2.3' not installed"
}

@test "shell change version" {
  mkdir -p "${RBENV_ROOT}/versions/1.2.3"
  RBENV_SHELL=bash run rbenv-sh-shell 1.2.3
  assert_success
  assert_output <<OUT
RBENV_VERSION_OLD="\${RBENV_VERSION-}"
export RBENV_VERSION="1.2.3"
OUT
}

@test "shell change version (end-to-end test)" {
  eval "$(rbenv init -)"
  mkdir -p "${RBENV_ROOT}/versions/1.2.3"
  assert [ -z "${RBENV_VERSION+x}" ];

  RBENV_SHELL=bash rbenv shell 1.2.3

  assert_equal "$RBENV_VERSION" 1.2.3
  assert_equal "$RBENV_VERSION_OLD" ""
}

@test "shell change version (fish)" {
  mkdir -p "${RBENV_ROOT}/versions/1.2.3"
  RBENV_SHELL=fish run rbenv-sh-shell 1.2.3
  assert_success
  assert_output <<OUT
set -gu RBENV_VERSION_OLD "\$RBENV_VERSION"
set -gx RBENV_VERSION "1.2.3"
OUT
}

@test "shell change version (fish, end-to-end test)" {
  FISH_PATH="$(command -v fish || echo 'fish not found')"

  if [ "fish not found" = "$FISH_PATH" ]; then
    skip
  else
    run "$(dirname BASH_SOURCE[0])/test/shell-change-version.fish"
    assert_success
  fi
}
