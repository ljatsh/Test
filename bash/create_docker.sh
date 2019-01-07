#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name awk -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
awk-dev:latest
