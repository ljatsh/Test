#!/usr/bin/env bats

load test_helper

@test "test_list_hiden_files" {
  test_dir=$TMP/test_dir
  if [ -d $test_dir ]; then rmdir $test_dir; fi
  mkdir $test_dir

  # TODO ls -C can have multiple columns, but there are more than 1 spaces bwtween tokens
  r=$(ls -a $test_dir | xargs)
  [ "$r" = ". .." ]

  r=$(ls -A $test_dir | xargs)
  [ ! "$r" ]

  touch $test_dir/a
  touch $test_dir/.a

  r=$(ls -a $test_dir | xargs)
  [ "$r" = ". .. .a a" ]

  r=$(find $test_dir -name .[!.]* -print | xargs)
  [ "$r" = "$test_dir/.a" ]
}
