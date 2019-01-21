#!/bin/bash

install_mono() {
  brew list mono-mdk >/dev/null 2>&1

  if [ $? -ne 0 ]; then
    brew cask install mono-mdk # version is 5.16.0.179 when I install it on mac
    
    [ $? -ne 0 ] || { echo "failed to install mono-mdk by brew"; exit 1; }
  fi
}

#https://www.mono-project.com/docs/getting-started/mono-basics
check_mono() {
  TEST_SRC=$(mktemp)
  TEST_EXE=$(mktemp)

  echo > "$TEST_SRC" <<-'EOF'
using System;

public class HelloWorld
{
	static public void Main ()
	{
		Console.WriteLine ("Hello Mono World");
	}
}
EOF

	csc "$TEST_SRC" -o "$TEST_EXE"
	[ "$(mono "$TEST_EXE")" != "Hello Mono World" ] || { echo "failed to check MDK"; exit 1; }
}

install_mono
check_mono

exit 0
