#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run rbenv
  assert_failure
  assert_line 0 "$(rbenv---version)"
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

@test "RBENV_DIR should have higher precedence than RBENV_FILE_ARG" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  touch "$dir/test.rb"
  RBENV_DIR="$dir" RBENV_FILE_ARG="$dir/test.rb" run rbenv echo RBENV_DIR
  assert_output "$dir"
}

@test "detect RBENV_DIR from RBENV_FILE_ARG" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  touch "$dir/test.rb"
  RBENV_FILE_ARG="$dir/test.rb" run rbenv echo RBENV_DIR
  assert_output "$dir"
}

@test "detect RBENV_DIR from RBENV_FILE_ARG in current directory" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  touch "$dir/test.rb"
  cd "$dir"
  BYENV_FILE_ARG="test.rb" run rbenv echo RBENV_DIR
  assert_output "$dir"
}

@test "detect RBENV_DIR from RBENV_FILE_ARG via symlink" {
  dir1="${BATS_TMPDIR}/myproject1"
  dir2="${BATS_TMPDIR}/myproject2"
  mkdir -p "$dir1" "$dir2"
  touch "$dir1/test.rb"
  ln -fs "$dir1/test.rb" "$dir2/test.rb"
  RBENV_FILE_ARG="$dir2/test.rb" run rbenv echo RBENV_DIR
  assert_output "$dir1"
}

@test "adds its own libexec to PATH" {
  run rbenv echo "PATH"
  assert_success "${BATS_TEST_DIRNAME%/*}/libexec:$PATH"
}

@test "adds plugin bin dirs to PATH" {
  mkdir -p "$RBENV_ROOT"/plugins/ruby-build/bin
  mkdir -p "$RBENV_ROOT"/plugins/rbenv-each/bin
  run rbenv echo -F: "PATH"
  assert_success
  assert_line 0 "${BATS_TEST_DIRNAME%/*}/libexec"
  assert_line 1 "${RBENV_ROOT}/plugins/ruby-build/bin"
  assert_line 2 "${RBENV_ROOT}/plugins/rbenv-each/bin"
}

@test "RBENV_HOOK_PATH preserves value from environment" {
  RBENV_HOOK_PATH=/my/hook/path:/other/hooks run rbenv echo -F: "RBENV_HOOK_PATH"
  assert_success
  assert_line 0 "/my/hook/path"
  assert_line 1 "/other/hooks"
  assert_line 2 "${RBENV_ROOT}/rbenv.d"
}

@test "RBENV_HOOK_PATH includes rbenv built-in plugins" {
  run rbenv echo "RBENV_HOOK_PATH"
  assert_success ":${RBENV_ROOT}/rbenv.d:${BATS_TEST_DIRNAME%/*}/rbenv.d:/usr/local/etc/rbenv.d:/etc/rbenv.d:/usr/lib/rbenv/hooks"
}
