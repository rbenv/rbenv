#
#  Defines assertions and other functions needed
#  to run the tests.
#

flunk () {
  echo "[$TEST_CASE:$lineno] $TEST_NAME\n$1\n" 1>&2
  return 1
}

assert_status_equal () {
  expected=$1; actual=$2; lineno=$3

  if [ $actual -ne $expected ]
  then
    flunk "expected exit status $expected but was $actual"
  fi
}

assert_output_equal () {
  expected=$(cat); actual=$1; lineno=$2

  if [ "$actual" != "$expected" ]
  then
    echo -e "$expected" > "$0_$2_expected.txt"
    echo -e "$actual"   > "$0_$2_actual.txt"
    
    flunk "unequal stdout:\n$(diff "$0_$2_expected.txt" "$0_$2_actual.txt")"
    
    rm "$0_$2_expected.txt" "$0_$2_actual.txt"
    return 1
  fi
}

assert_equal () {
  assert_status_equal $1 $? $3 &&
  assert_output_equal "$2" $3
}

run_test_case () {
  for test_name in $(grep -oE "^ *${NAME:-test_\w+} +\(\)" "$1" | tr -d " ()")
  do
    if TEST_NAME="$test_name" "$test_name"
    then printf '.'
    else printf 'F'
    fi
  done
}