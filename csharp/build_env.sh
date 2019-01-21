#!/bin/bash

install_mono() {
  brew cask list mono-mdk >/dev/null 2>&1

  if [ $? -ne 0 ]; then
    # version is 5.16.0.179 when I install it on mac
    brew cask install mono-mdk || { echo "failed to install mono-mdk by brew"; exit 1; };
  fi
}

#https://www.mono-project.com/docs/getting-started/mono-basics
check_mono() {
  TEST_SRC=$(mktemp)
  TEST_EXE=$(mktemp)

  echo $TEST_SRC

  cat <<'EOF' | tee $TEST_SRC
using System;

public class HelloWorld
{
  static public void Main ()
  {
    Console.WriteLine ("Hello Mono World");
  }
}
EOF

  if [ ! -e csc ]; then
    MONO_BIN=$(</etc/paths.d/mono-commands)
    PATH=$PATH:"$MONO_BIN"
  fi

	csc "$TEST_SRC" -out:"$TEST_EXE" >/dev/null
	mono "$TEST_EXE" || { echo "failed to check MDK"; exit 1; }
}

install_mono
check_mono

exit 0
