#!/usr/bin/env bats

load test_helper

@test "brace expansion" {
  v="$(echo a{,1,2,3}b)"
  [ "$v" = "ab a1b a2b a3b" ]
}
