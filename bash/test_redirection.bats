
#!/usr/bin/env bats

load test_helper

# [n] < file
@test "input redirection" {
  echo lj@sh 35 man > "$TMP"/test_redirection
  read name age sex < "$TMP"/test_redirection
  [ $name = lj@sh -a $age = 35 -a $sex = man ]
}
