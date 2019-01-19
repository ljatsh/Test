
#!/usr/bin/env bats
# https://www.gnu.org/software/bash/manual/bash.html#Redirections

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

  [ "$(awk 'NR==1 {print}' < "$TMP"/test_redirection )" = "lj@sh 35 man" ]
  [ "$(awk 'NR==2 {print}' < "$TMP"/test_redirection )" = "lj@xa 24 man" ]
}

# [n]<&word - duplicate input file descriptor
# 1. if word is digits, n is a copy of the file descriptor(must be opened for reading)
# 2. if word is -, n is closed
# 3. default value of n is 0(the standard input)
# [n]>&word - duplicate output file descriptor
# 1. if word is digits, n is a copy of the file descriptor(must be opened for writing)
# 2. is word is -. n is closed
# 3. default value of n is 1(the standard output)
# 4. >& file or &> file is a shortcut that simply send both STDOUT and STDERR to the same place
@test "duplicate file descriptor" {
  # input
  echo lj@sh 35 man > "$TMP"/test_redirection

  read name age sex 4< "$TMP"/test_redirection <&4
  [ $name = lj@sh -a $age = 35 -a $sex = man ]

  error=
  read name age sex <& - || error=yes
  [ $error = yes ]

  # output
  echo lj@sh 35 man 4> "$TMP"/test_redirection >& 4
  content=$(< "$TMP"/test_redirection)
  [ "$content" = "lj@sh 35 man" ]
}

# [n]<&digit-
# moves file descriptor digit to n (default is the standard input), digit is closed after being duplicated to n
@test "move file descriptor" {
  # input
  echo lj@sh 35 man > "$TMP"/test_redirection

  read name age sex 4< "$TMP"/test_redirection <&4-
  [ $name = lj@sh -a $age = 35 -a $sex = man ]

  error=
  read -u 4 name a  ge sex 4< "$TMP"/test_redirection <&4- || error=yes
  [ $error = yes ]
}

# [n]<<-word
#		here document
# world
# - means formatted here document, all leading tabs in here documented are stripped, and the terminator can have tabs prefix. Otherwise, the terminator must be at the beginning of the new line.
# enclose word in quotes is the preferred style, otherwise, the here document would be expanded.
@test "here document" {
  var=$(head -n 1 <<'EOF'
	line1  
	line2
EOF
)
  [ "$var" = '	line1  ' ]

  var=$(head -n 1 <<-'EOF'
		line1
		line2
		EOF
	)

  [ "$var" = 'line1' ]
}

# Tips
# 1. redirect both standard output and standard error to file (TODO, i dont't know the reason, just remember it)
#    a) &> f
#    b) > f 2>& 1
# 2. several specified files:
#    /dev/stdin, /dev/stdout, /dev/stderr, /dev/null
