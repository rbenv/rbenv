#!/usr/bin/env bats

load test_helper

setup_rbenv_git_clone(){
  mkdir -p "$RBENV_ROOT"
  cd "$RBENV_ROOT"
  git init
  git config user.name  "Tester"
  git config user.email "tester@test.local"
}

git_commit() {
  git commit --quiet --allow-empty -m "empty"
}

@test "default version" {
  assert [ ! -e "$RBENV_ROOT" ]
  run rbenv---version
  assert_success
  [[ $output == "rbenv 0."* ]]
}

@test "reads version from git repo" {
  setup_rbenv_git_clone

  git_commit
  git tag v0.4.1
  git_commit
  git_commit

  cd "$RBENV_TEST_DIR"
  run rbenv---version
  assert_success
  [[ $output == "rbenv 0.4.1-2-g"* ]]
}

@test "prints default version if no tags in git repo" {
  setup_rbenv_git_clone

  git_commit

  cd "$RBENV_TEST_DIR"
  run rbenv---version
  [[ $output == "rbenv 0."* ]]
}
