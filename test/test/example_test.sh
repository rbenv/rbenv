#!/bin/sh

########################################################################
TEST_CASE=$(basename $0)
########################################################################
. ${0%/$TEST_CASE}/../test_helper.sh

#
# assert_equal test
#

test_assert_equal_pass () {
  assert_equal 0 "$(
echo 'hello world'
echo 'hello world'
echo 'hello world'
)" $LINENO <<stdout
hello world
hello world
hello world
stdout
}

test_assert_equal_fail_by_status () {
  assert_equal 1 "$(
echo 'hello world'
echo 'hello world'
echo 'hello world'
)" $LINENO <<stdout
hello world
hello world
hello world
stdout
}

test_assert_equal_fail_by_output () {
  assert_equal 0 "$(
echo 'hello world'
echo 'ellow world'
echo 'hello world'
)" $LINENO <<stdout
hello world
hello world
hello world
stdout
}

#
# assert_status_equal test
#

test_assert_status_equal_pass () {
  true
  assert_status_equal 0 $? $LINENO
}

#
# assert_output test
#

test_assert_output_equal_pass () {
  assert_output_equal "$(
echo 'hello world'
echo 'hello world'
echo 'hello world'
)" $LINENO <<stdout
hello world
hello world
hello world
stdout
}

run_test_case "$0"