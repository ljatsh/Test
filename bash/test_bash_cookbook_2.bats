#!/usr/bin/env bats

load test_helper

# The echo utility writes any specified operands, separated by single blank (` ') characters and followed by a newline (`\n') character, to the standard output.
@test "test_echo" {
  r=$(echo a  b    c)
  [ "$r" = "a b c" ]
  r=$(echo "a  b    c")
  [ "$r" = "a  b    c" ]
}

# printf format [arguments ...]
@test "test_printf" {
  # the trailing newline was removed by command substitution
  r=$(printf "%s=%d\n" lj@sh 50)
  [ "$r" = "lj@sh=50" ]
}

# redirection is not transparent to ls
@test "test_ls_redirection" {
  ls / > $TMP/test_ls_redirection
  r=$(<$TMP/test_ls_redirection)
  # TODO multiple line tests
}


