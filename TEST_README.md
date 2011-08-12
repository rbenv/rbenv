# Testing

rbenv lives in the shell and so is tested in a shell. The test directory
contains shell-based unit tests.

To run locally:

    ./test/test_suite.sh

Or:

    rake local_test

To add another test suite, make a script in the test directory that ends with
`_test.sh` and ensure it is executable. Then follow the pattern in
`example_test.sh`:

    #!/bin/sh

    ########################################################################
    TEST_CASE=$(basename $0)
    ########################################################################
    . ${0%/$TEST_CASE}/../test_helper.sh

    test_echo_echos_a_string_to_stdout () {
    # The assert_equal method will check that the echo command exits
    # with status 0, and that the stdout is 'hello world'.
    #
    # There are similar assertions to just check the exit status
    # or just check stdout.

      assert_equal 0 "$(
      echo 'hello world'
    )" $LINENO <<stdout
    hello world
    stdout

    # Write as many assertions as you please in a given method.
    }

    run_test_case "$0"

You can write as many test methods as you like... just follow the same
conventions as in Test::Unit (ie start the method with `test_`).

## Running on VMs

First set up some virtual machines by following the instructions in
doc/vm_setup. Then copy config/ssh.example to config/ssh and replace the
USERNAME comment with your user for the virtual machines. You can add/remove
hosts as you please; each host should correspond to the name of a VM in
VirtualBox.

Now to run the tests:

  # starts each of the VMs
  rake start
  
  # copies the test scripts to each vm and runs the test suite on each
  rake remote_test
  
  # stops each of the VMs
  rake stop

Or you can run the whole shebang with:

  rake test
