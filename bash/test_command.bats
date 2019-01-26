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
# 3. commands are executed in sub shells, and they don't have to run sequentially
@test "pipe command" {
  echo "lj@sh lj@xa" | grep "lj@sh" > /dev/null
  ! echo "lj@sh lj@xa" | grep "lj@usa" > /dev/null

  ! echo "lj@sh lj@xa" > "$TMP"/test_command | grep "lj@sh"
}

# 1. command; command; ...
#    command are executed in sequence, exit status is the last command executed (every command will be executed regardless of the exist status of last command)
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
# 3. for name [ [in [words ...]]; ] do commands; done
#    if 'in words' is not presend, 'in "$@"' is assumed
#    the return status is the exit status of the last executed command
#    for ((expr1; expr2; expr3)); do commands; done
#    all three expressions are arithmetic expressions
#    the return status is the exit status of the last executed command

@test "looping constructs" {
  # test arithmetic expression 
  OUT_VALUE=
  while (( (TEST_VALUE += 1) <= 3)); do
    OUT_VALUE=${OUT_VALUE}${TEST_VALUE}\;
  done

  [ $OUT_VALUE = "1;2;3;" ]

  # test read
  OUT_VALUE=
  while read STATUS FILE; do
    if [ $STATUS = M ]; then OUT_VALUE="${OUT_VALUE} $FILE"; fi
  done <<'EOF'
! file1.txt
M file2.txt
M file3.txt
D file4.txt
A file5.txt
EOF

  [ "$OUT_VALUE" = " file2.txt file3.txt" ]

  # test for
  OUT_VALUE=
  for v in a b c; do
    OUT_VALUE=$OUT_VALUE_$v\;
  done

  [ $OUT_VALUE = "_a;_b;_c;" ]

  set -- e f g
  for v do
    OUT_VALUE=$OUT_VALUE_$v\;
  done

  [ $OUT_VALUE = "_e;_f;_g;" ]

  OUT_VALUE=
  for ((i=1; i<=3; i++)); do
    OUT_VALUE=$OUT_VALUE_$i\;
  done

  [ $OUT_VALUE = "_1;_2;_3;" ]
}

# if test-command; then
#   consequend-commands;
# [elif more-test-command; then
#   more-consequends;]
# [else alternate-consequends;]
# fi

# [ equivalents to test
# (()) equivalents let "expression"

test_conditional_constructs_let() {
  if (($1 < 10)); then echo "<"; else echo ">="; fi
}

test_conditional_constructs_simple_form() {
  (($1 < 10)) && { echo "<"; exit 0; } || { echo ">="; exit 1; }
}

@test "conditional constucts" {
  [ $(test_conditional_constructs_let 9) = "<" ]
  [ $(test_conditional_constructs_let 10) = ">=" ]

  [ $(test_conditional_constructs_simple_form 9) = "<" ]
  [ $(test_conditional_constructs_simple_form 10) = ">=" ]
}

# (list) list commands are executed in sub shell
# { list; } The braces are actually reserved words, so they must be surrounded by white space. Also, the trailing semicolon is required before the closing space.
@test "grouping commands" {

}

