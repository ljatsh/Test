#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name lua51 -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
lua51-dev:latest
