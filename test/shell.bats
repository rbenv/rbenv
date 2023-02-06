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
  eval "$(rbenv init -)"

  RBENV_VERSION="" run rbenv shell

  assert_success "rbenv: no shell-specific version configured"
}

@test "shell version" {
  eval "$(rbenv init -)"

  RBENV_SHELL=bash RBENV_VERSION="1.2.3" run rbenv shell

  assert_success '1.2.3'
}

@test "shell version (fish)" {
  eval "$(rbenv init -)"

  RBENV_SHELL=fish RBENV_VERSION="1.2.3" run rbenv shell

  assert_success '1.2.3'
}

@test "shell revert" {
  eval "$(rbenv init -)"
  export RBENV_SHELL=bash
  export RBENV_VERSION=1.7.5
  export RBENV_VERSION_OLD=2.0.0

  rbenv shell -

  assert_equal $RBENV_VERSION 2.0.0
  assert_equal $RBENV_VERSION_OLD 1.7.5
}

@test "shell revert (fish)" {
  $(/Users/richiethomas/Workspace/OpenSource/rbenv/test/shell-revert-fish.test)
  exit_code="$?"

  assert [ "0" = "$exit_code" ]
}

@test "shell unset" {
  eval "$(rbenv init -)"
  export RBENV_SHELL=bash
  export RBENV_VERSION=1.7.5
  assert_equal "$RBENV_VERSION" 1.7.5
  assert [ -z "${RBENV_VERSION_OLD+x}" ];

  rbenv shell --unset

  assert_success
  assert_equal $RBENV_VERSION_OLD 1.7.5
  assert [ -z "${RBENV_VERSION+x}" ];
}

@test "shell unset (fish)" {
  $(/Users/richiethomas/Workspace/OpenSource/rbenv/test/shell-unset-fish.test)
  exit_code="$?"

  assert [ "0" = "$exit_code" ]
}

@test "shell unset (integration test)" {
  eval "$(rbenv init -)"
  export RBENV_VERSION="2.7.5"

  run rbenv shell

  assert_success
  assert_output "2.7.5"
}

@test "shell change invalid version" {
  eval "$(rbenv init -)"

  run rbenv shell 1.2.3

  assert_failure
  assert_output "rbenv: version \`1.2.3' not installed"
}

@test "shell change version" {
  eval "$(rbenv init -)"
  mkdir -p "${RBENV_ROOT}/versions/1.2.3"
  assert [ -z "${RBENV_VERSION+x}" ];

  RBENV_SHELL=bash rbenv shell 1.2.3

  assert_equal "$RBENV_VERSION" 1.2.3
  assert_equal "$RBENV_VERSION_OLD" ""
}

@test "shell change version (fish)" {
  $(/Users/richiethomas/Workspace/OpenSource/rbenv/test/shell-change-version-fish.test)
  exit_code="$?"

  assert [ "0" = "$exit_code" ]
}
