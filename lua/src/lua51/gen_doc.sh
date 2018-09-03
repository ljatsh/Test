#!/bin/bash

pwd="$(cd "$(dirname "$0"  )" && pwd )"
doc=$pwd/doc
src=$pwd

if [ -d $doc ]; then
  rm -fr $doc
fi

mkdir -p $doc

if [ -d $pwd/tmp ]; then
  rm -fr $pwd/tmp
fi
mkdir $pwd/tmp

for i in stream stream_socket; do
  cp $src/$i.lua $pwd/tmp
done;

ldoc -d $doc $pwd/tmp

rm -fr $pwd/tmp
