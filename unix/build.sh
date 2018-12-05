#!/bin/bash

cd /opt/dev

rm -fr out
gyp -f make -Goutput_dir=build --generator-output=out --depth=. test.gyp
make -C out

cp out/build/Debug/lib.target/test.so /usr/local/lib/lua/5.3
