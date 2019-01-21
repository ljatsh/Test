#!/usr/bin/env bats

load test_helper

# VAR=VALUE
# no spaces can occur between the assignment character
# $VAR or ${VAR} can refer to the variable, the second style is useful when the variable is surrouned by othe text
@test "test_variable" {
  NAME=lj@sh
  [ "he${NAME}" = helj@sh ]
}

test_parameters1() {
  echo $1 $10 ${10}
}

test_parameters2() {
  for x in $*; do
    printf "%s;" "$x";
  done
  echo ""
}

test_parameters3() {
  for x in "$*"; do
    printf "%s;" "$x";
  done
  echo ""
}

test_parameters4() {
  for x in "$@"; do
    printf "%s;" "$x";
  done
  echo ""
}

test_parameters5() {
  echo $#
}

# 1. Prefer to quote parameter is the parameter is surrounded by other digits, ${1}00 etc.
# 2. Parameter must be quoted if the value contains blanks
# 3. A reference to $* inside of quotes gives the entire list inside one set of quotes. But a reference to $@ inside of quotes returns not one string but a list of quoted strings, one for each argument
# 4. $# indicates parameter count
@test "test_parameters" {
  [ "$(test_parameters1 I II III IV V VI VII VIII IX X XI)" = "I I0 X" ]

  # $*
  [ "$(test_parameters2 I II III)" = "I;II;III;" ]
  [ "$(test_parameters2 I II III "he and me")" = "I;II;III;he;and;me;" ]
  # "$*"
  [ "$(test_parameters3 I II III)" = "I II III;" ]
  [ "$(test_parameters3 I II III "he and me")" = "I II III he and me;" ]
  # "$@"
  [ "$(test_parameters4 I II III)" = "I;II;III;" ]
  [ "$(test_parameters4 I II III "he and me")" = "I;II;III;he and me;" ]
  # $#
  [ $(test_parameters5 I II III) = 3 ]
}
