
#!/usr/bin/env bats

load test_helper

# test expression or [ expression ]

# -d file True if file exists and is a directory
# -f file True if file exists and is a regular file
# -h file True if file exists and is a symbolic link
# -x file True if file exists and is executable
@test "file status test" {
  [ -d "$TMP" ]

  touch "$TMP"/file_status_test
  [ -f "$TMP"/file_status_test ]

  ln -s "$TMP/file_status_test" "$TMP/file_status_test_link"
  [ -h "$TMP"/file_status_test_link ]

  [ ! -x "$TMP"/file_status_test ]
}

# operands are strings
# string True if the string is the null string
# s1 = s2(or ==) True if s1 and s2 are identical
# s1 != s2 True if s1 and s2 are not identical
# -z string True if length of string is zero
@test "string comparision" {
  [ ! "" ]
  [ ! $not_exist_var ]

  [ 1 = 1 ]
  [ 1 = "1" ]
  [ abc = "abc" ]
  [ 'abc' = "abc" ]
  [ 'abc' == "abc" ]

  [ abc != Abc ]
  [ ! abc = Abc ]

  [ -z "" ]
}

# n1 -eq n2 True if the integers n1 and n2 are equal
# n1 -ne n2 True if the integers n1 and n2 are not equal
# n1 -lt n2
# n1 -le n2
# n1 -gt n2
# n1 -ge n2
@test "numberic comparision" {
  [ 1 -eq " 1 " ]
  [ 1 -ne "2" ]

  [ 1 -lt 2 ]
  [ 2 -gt 1 ]
}

# logic operators
# ! expression is True if expression is False
# expression1 -a expression2 True if both expressions are True
# expression1 -o expression2 True if ethier expression1 or expression2 is True
@test "logic operators" {
  [ ! 1 -eq "2" ]
  [ 5 -lt 6 -a 5 -gt 4 ]
  [ 5 -lt 4 -o 5 -lt 6 ]
}
