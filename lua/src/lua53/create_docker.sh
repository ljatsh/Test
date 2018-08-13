#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name lua53 -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
lua53-dev:latest
