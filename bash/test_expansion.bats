#!/usr/bin/env bats

load test_helper

@test "brace expansion" {
  v="$(echo a{,1,2,3}b)"
  [ "$v" = "ab a1b a2b a3b" ]
}

# command substituion
# $(command) or `command`
# The $( ) encloses a command that is run in a subshell. The output from that command is substituted in place of the $( ) phrase. Trailing newline in the output are replaced with a space character(see #IFS)
# $() is preferred than ``
@test "command substituion" {
  [ $(echo a) = a ]
}
