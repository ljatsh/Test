#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name math -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
math-dev:latest
