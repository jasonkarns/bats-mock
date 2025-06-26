#!/usr/bin/env bats

# this is the "code under test"
# it would normally be in another file
format_date() {
  date -r 222
}

# this is a function used in stub return evaluation
function my_test_fct()
{
    echo "This is my final stub return, receiving arguments: $*"
}
# it must be exported in the script to be accessible to its childs
export -f my_test_fct

setup() {
  # Load library
  load '../load'

  _DATE_ARGS='-r 222'
  stub date \
      "${_DATE_ARGS} : echo 'I am stubbed!'" \
      "${_DATE_ARGS} : my_test_fct \$*"
}

teardown() {
  unstub date
}

@test "date format util formats date with expected arguments" {
  result="$(format_date)"
  [ "$result" == 'I am stubbed!' ]

  result="$(format_date)"
  [ "$result" == "This is my final stub return, receiving arguments: -r 222" ]
}
