
#!/usr/bin/env bats

load test_helper

# [n]< file
# file will be opened for reading on file descriptor n, default 0(the standard input)
# no spaces between n and <
@test "input redirection" {
  echo lj@sh 35 man > "$TMP"/test_redirection
  read name age sex < "$TMP"/test_redirection
  [ $name = lj@sh -a $age = 35 -a $sex = man ]

  read -u 4 name age sex 4< "$TMP/test_redirection"
  [ $name = lj@sh -a $age = 35 -a $sex = man ]
}

# [n]>[|] file
# [n]>> file
# file will be opened for writing/appending on file descriptor n, default 1(the standard output)
# | is optional, no spaces between n and >[|]
@test "output redirection" {
  # TODO n

  echo lj@sh 35 man > "$TMP"/test_redirection
  echo lj@xa 24 man >> "$TMP"/test_redirection

  # TODO how to check file content?
}

# [n]<&word - duplicate input file descriptor
# 1. if word is digits, n is a copy of the file descriptor(must be opened for reading)
# 2. if word is -, n is closed
# 3. default value of n is 0(the standard input)
# [n]>&word - duplicate output file descriptor
# 1. if word is digits, n is a copy of the file descriptor(must be opened for writing)
# 2. is word is -. n is closed
# 3. default value of n is 1(the standard output)
@test "duplicate file descriptor" {
  # input
  echo lj@sh 35 man > "$TMP"/test_redirection

  read name age sex 4< "$TMP"/test_redirection <&4
  [ $name = lj@sh -a $age = 35 -a $sex = man ]

  error=
  read name age sex <& - || error=yes
  [ $error = yes ]

  # output
  echo lj@sh 35 man 4> "$TMP"/test_redirection >&4
  # content=$(cat "$TMP"/test_redirection)
  # [ $content ="lj@sh 35 man" ]
  # TODO how to check file content
}
