#!/bin/bash

#
#  Test Suite Setup
#

MESSAGES=messages
RESULTS=results
count_char () {
  grep -o "$1" "$2" | wc -l | tr -d " "
}

#
#  Run the test cases
#

echo "Started on $(hostname)"
START_TIME=$SECONDS
for test_case in $(dirname $0)/**/*_test.sh
do
  if [ -f "$test_case" ]
  then
    "$test_case" 2>>"$MESSAGES" | tee -a "$RESULTS"
  fi
done
END_TIME=$SECONDS
echo
echo "Finished in $(($END_TIME - $START_TIME))s"

#
#  Print results
#

if [ -f "$MESSAGES" ] && [ -f "$RESULTS" ]
then
  echo
  cat "$MESSAGES"
  echo "$(count_char "\." "$RESULTS") pass, $(count_char "F" "$RESULTS") fail"
  rm "$MESSAGES" "$RESULTS"
fi
