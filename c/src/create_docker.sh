#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name cdev -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
c-dev:latest
