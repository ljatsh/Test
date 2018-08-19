#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name skynet -it --rm \
-v $dir:/opt/dev \
-w /opt/dev \
--link mysql \
--link redis \
--cap-add=SYS_PTRACE \
skynet-dev:latest
