#!/usr/bin/env bats

load test_helper

# VAR=VALUE
# no spaces can occur between the assignment character
# $VAR or ${VAR} can refer to the variable, the second style is useful when the variable is surrouned by othe text
@test "test_variable" {
  NAME=lj@sh
  [ "he${NAME}" = helj@sh ]
}
