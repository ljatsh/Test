#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name skynet -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
--cap-add=SYS_PTRACE \
skynet-dev:latest

#--link mysql \
#--link redis \
