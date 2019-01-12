#!/usr/bin/env bats

load test_helper

@test "simple command" {
  ls . > /dev/null
  [ $? -eq 0 ]
}

# [!] command1 | [ | or |& command2 ]
# 1. output(or and standard error) of command1 is connected via a pipe to the input of command2.
#    This connection is performed before any redirections specified by the command
# 2. exit status of the pipe command is the exit status of the last command
@test "pipe command" {
  echo "lj@sh lj@xa" | grep "lj@sh" > /dev/null
  ! echo "lj@sh lj@xa" | grep "lj@usa" > /dev/null

  ! echo "lj@sh lj@xa" > "$TMP"/test_command | grep "lj@sh"
}

# 1. command; command; ...
#    command are executed in sequence, exit status is the last command executed
# 2. command1 && command2
#    command2 is executed if and only if exit status of command1 is 0, the final exit status is the result of command2
# 3. command1 || command2
#    command2 is executed if and only if exit status of command1 is not 0, and the final exit status is the result of command2
@test "list command" {
  # TODO
}

# ; in the description of the compound commands can be replaced by new line
# 1. until test-command; do consequend-commands; done
#    execute consequend-commands until exit status of test-command is non 0, final exit status if the result of last executed consequend-command
# 2. while test-command; to consequend-commands; done
#    execute consequend-commands as long as test-command has an exit status of 0, final exit status if the last executed consequend-command
# 3. for ...

@test "looping constructs" {
  # mkdir "$TMP"/looping
  # touch "$TMP"/looping/1 "$TMP"/looping/3 "$TMP"/looping/3
}

# if test-command; then
#   consequend-commands;
# [elif more-test-command; then
#   more-consequends;]
# [else alternate-consequends;]
# fi
@test "conditional constucts" {

}


