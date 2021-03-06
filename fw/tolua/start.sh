#!/bin/bash

PWD=$(cd `dirname $0` && pwd)

docker run -it --name tolua --rm -v $PWD:/opt/dev -w /opt/dev \
 --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
 tolua-dev
