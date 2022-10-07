#!/usr/bin/env bats

load test_helper

create_executable() {
  local bin
  if [[ $1 == */* ]]; then bin="$1"
  else bin="${RBENV_ROOT}/versions/${1}/bin"
  fi
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "outputs path to executable" {
  create_executable "1.8" "ruby"
  create_executable "2.0" "rspec"

  RBENV_VERSION=1.8 run rbenv-which ruby
  assert_success "${RBENV_ROOT}/versions/1.8/bin/ruby"

  RBENV_VERSION=2.0 run rbenv-which rspec
  assert_success "${RBENV_ROOT}/versions/2.0/bin/rspec"
}

@test "searches PATH for system version" {
  create_executable "${RBENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${RBENV_ROOT}/shims" "kill-all-humans"

  RBENV_VERSION=system run rbenv-which kill-all-humans
  assert_success "${RBENV_TEST_DIR}/bin/kill-all-humans"
}

@test "searches PATH for system version (shims prepended)" {
  create_executable "${RBENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${RBENV_ROOT}/shims" "kill-all-humans"

  PATH="${RBENV_ROOT}/shims:$PATH" RBENV_VERSION=system run rbenv-which kill-all-humans
  assert_success "${RBENV_TEST_DIR}/bin/kill-all-humans"
}

@test "searches PATH for system version (shims appended)" {
  create_executable "${RBENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${RBENV_ROOT}/shims" "kill-all-humans"

  PATH="$PATH:${RBENV_ROOT}/shims" RBENV_VERSION=system run rbenv-which kill-all-humans
  assert_success "${RBENV_TEST_DIR}/bin/kill-all-humans"
}

@test "searches PATH for system version (shims spread)" {
  create_executable "${RBENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${RBENV_ROOT}/shims" "kill-all-humans"

  PATH="${RBENV_ROOT}/shims:${RBENV_ROOT}/shims:/tmp/non-existent:$PATH:${RBENV_ROOT}/shims" \
    RBENV_VERSION=system run rbenv-which kill-all-humans
  assert_success "${RBENV_TEST_DIR}/bin/kill-all-humans"
}

@test "doesn't include current directory in PATH search" {
  mkdir -p "$RBENV_TEST_DIR"
  cd "$RBENV_TEST_DIR"
  touch kill-all-humans
  chmod +x kill-all-humans
  PATH="$(path_without "kill-all-humans")" RBENV_VERSION=system run rbenv-which kill-all-humans
  assert_failure "rbenv: kill-all-humans: command not found"
}

@test "version not installed" {
  create_executable "2.0" "rspec"
  RBENV_VERSION=1.9 run rbenv-which rspec
  assert_failure "rbenv: version \`1.9' is not installed (set by RBENV_VERSION environment variable)"
}

@test "no executable found" {
  create_executable "1.8" "rspec"
  RBENV_VERSION=1.8 run rbenv-which rake
  assert_failure "rbenv: rake: command not found"
}

@test "no executable found for system version" {
  PATH="$(path_without "rake")" RBENV_VERSION=system run rbenv-which rake
  assert_failure "rbenv: rake: command not found"
}

@test "executable found in other versions" {
  create_executable "1.8" "ruby"
  create_executable "1.9" "rspec"
  create_executable "2.0" "rspec"

  RBENV_VERSION=1.8 run rbenv-which rspec
  assert_failure
  assert_output <<OUT
rbenv: rspec: command not found

The \`rspec' command exists in these Ruby versions:
  1.9
  2.0
OUT
}

@test "executable not found in user gems" {
  create_executable "2.7.6" "ruby"
  create_executable "${HOME}/.gem/ruby/2.7.0/bin" "rake"
  GEM_HOME='' RBENV_VERSION=2.7.6 run rbenv-which rake
  assert_failure
}

@test "executable found in gem home" {
  create_executable "2.7.6" "ruby"
  create_executable "${HOME}/mygems/bin" "rake"
  create_executable "${HOME}/.gem/ruby/2.7.0/bin" "rake"
  GEM_HOME="${HOME}/mygems" RBENV_VERSION=2.7.6 run rbenv-which rake
  assert_success "${HOME}/mygems/bin/rake"
}

@test "executable found in gem home (system ruby)" {
  create_executable "${HOME}/mygems/bin" "rbenv-test-lolcat"
  create_executable "${HOME}/.gem/ruby/2.6.0/bin" "rbenv-test-lolcat"
  GEM_HOME="${HOME}/mygems" RBENV_VERSION=system run rbenv-which rbenv-test-lolcat
  assert_success "${HOME}/mygems/bin/rbenv-test-lolcat"
}

@test "carries original IFS within hooks" {
  create_hook which hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
exit
SH

  IFS=$' \t\n' RBENV_VERSION=system run rbenv-which anything
  assert_success
  assert_output "HELLO=:hello:ugly:world:again"
}

@test "discovers version from rbenv-version-name" {
  mkdir -p "$RBENV_ROOT"
  cat > "${RBENV_ROOT}/version" <<<"1.8"
  create_executable "1.8" "ruby"

  mkdir -p "$RBENV_TEST_DIR"
  cd "$RBENV_TEST_DIR"

  RBENV_VERSION='' run rbenv-which ruby
  assert_success "${RBENV_ROOT}/versions/1.8/bin/ruby"
}
