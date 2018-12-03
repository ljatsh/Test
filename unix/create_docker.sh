#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name unix -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
unix-dev:latest
