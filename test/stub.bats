#!/usr/bin/env bats

# this is the "code under test"
# it would normally be in another file
format_date() {
  date -r 222
}

setup() {
  load '../load'
  _DATE_ARGS='-r 222'
}

@test "date format util formats date with expected arguments" {
  stub date \
      "${_DATE_ARGS} : echo 'I am stubbed!'" \
      "${_DATE_ARGS} : echo 'Wed Dec 31 18:03:42 CST 1969'"

  result="$(format_date)"
  [ "$result" == 'I am stubbed!' ]

  result="$(format_date)"
  [ "$result" == 'Wed Dec 31 18:03:42 CST 1969' ]

  unstub date
}

@test "unstub forced not enough invocations" {
  stub date \
      "${_DATE_ARGS} : echo 'I am stubbed!'" \
      "${_DATE_ARGS} : echo 'Wed Dec 31 18:03:42 CST 1969'"

  result="$(format_date)"
  [ "$result" == 'I am stubbed!' ]

  unstub date true
}
