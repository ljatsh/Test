#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name skynet -it \
-v $dir:/tmp/skynet-1.1.0/mytest \
--cap-add=SYS_PTRACE \
skynet-dev:latest
