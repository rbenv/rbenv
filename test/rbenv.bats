#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run rbenv
  assert_success
  assert [ "${lines[0]}" = "rbenv 0.4.0" ]
}

@test "invalid command" {
  run rbenv does-not-exist
  assert_failure
  assert_output "rbenv: no such command \`does-not-exist'"
}

@test "default RBENV_ROOT" {
  RBENV_ROOT="" HOME=/home/mislav run rbenv root
  assert_success
  assert_output "/home/mislav/.rbenv"
}

@test "inherited RBENV_ROOT" {
  RBENV_ROOT=/opt/rbenv run rbenv root
  assert_success
  assert_output "/opt/rbenv"
}

@test "default RBENV_DIR" {
  run rbenv echo RBENV_DIR
  assert_output "$(pwd)"
}

@test "inherited RBENV_DIR" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  RBENV_DIR="$dir" run rbenv echo RBENV_DIR
  assert_output "$dir"
}

@test "invalid RBENV_DIR" {
  dir="${BATS_TMPDIR}/does-not-exist"
  assert [ ! -d "$dir" ]
  RBENV_DIR="$dir" run rbenv echo RBENV_DIR
  assert_failure
  assert_output "rbenv: cannot change working directory to \`$dir'"
}

@test "runs commands from ~/.rbenvrc" {
  mkdir -p "${BATS_TMPDIR}/home/raven"
  echo "export ONCE_UPON_A_MIDNIGHT_DREARY='while I pondered weak and weary'" > "${BATS_TMPDIR}/home/raven/.rbenvrc"
  RBENV_ROOT="" HOME="${BATS_TMPDIR}/home/raven" run rbenv echo ONCE_UPON_A_MIDNIGHT_DREARY
  assert_success
  assert_output "while I pondered weak and weary"
}
