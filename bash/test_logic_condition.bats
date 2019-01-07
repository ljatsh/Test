
#!/usr/bin/env bats

load test_helper

# test expression or [ expression ]
# ! expression is True if expression is False

# -d file True if file exists and is a directory
# -f file True if file exists and is a regular file
# -h file True if file exists and is a symbolic link
# -x file True if file exists and is executable
@test "file status test" {
  [ -d "$TMP" ]
  [ ! -d "$TMP"/not_exist_folder ]

  touch "$TMP"/file_status_test
  [ -f "$TMP"/file_status_test ]

  ln -s "$TMP/file_status_test" "$TMP/file_status_test_link"
  [ -h "$TMP"/file_status_test_link ]

  [ ! -x "$TMP"/file_status_test ]
}
