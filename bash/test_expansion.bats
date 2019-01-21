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

# parameter expansion
# ${variable:offset} offset > 0, from left, from 0; < 0, from right, from -1 ( blanks should be inserted to avoid confusion)
# ${variable:offset:length}:  If length is omitted, it expands to the substring of the value of parameter starting at the character specified by offset and extending to the end of the value.  If length evaluates to a number less than zero, it is interpreted as an offset in characters from the end of the value of parameter rather than a number of characters, and the expansion is the characters between offset and that result(the second offset is excluded)
# @ and * can be used here
@test "parameter expansion" {
  v=0123456789abcdefgh
  # value:        0  1  2  3  4  5  6  7  8  9  a   b   c   d   e   f   g   h
  # left index:   0  1  2  3  4  5  6  7  8  9  10  11  12  13  14  15  16  17
  # right index:  -18-17-16-15-14-13-12-11-10-9 -8  -7  -6  -5  -4  -3  -2  -1
 
  # offset > 0
  [ ${v:0} = "0123456789abcdefgh" ]
  [ ${v:1} = "123456789abcdefgh" ]
  [ ${v:16} = "gh" ]
  [ ${v:17} = "h" ]
  [ "${v:18}" = "" ]

  # offset < 0
  [ ${v: -1} = "h" ]
  [ ${v: -2} = "gh" ]
  [ ${v: -17} = "123456789abcdefgh" ]
  [ ${v: -18} = "0123456789abcdefgh" ]
  [ "${v: -19}" = "" ]

  # length
  [ ${v:10:3} = "abc" ]
  echo ${v:10:-6} > test.txt
  [ ${v:10:-5} = "abc" ]
}
