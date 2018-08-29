#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name luajit -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
luajit-dev:latest
