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

# tail can be used to skip header
@test "test_skip_header" {
  for i in 2 3 4 5; do
    content=$(printf "line1\nline2\nline3\nline4\nline5\n" | tail -n +$i | awk 'NR==1 {print}')
    [ $content = line$i ]
  done
}

@test "test_swaping_stdout_and_stderr" {
  #TODO
  #command 3>&1 1> stdout.logfile 2>3&- | tee -a stderr.logfile
}
