#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name skynet --detach \
--cap-add=SYS_PTRACE \
skynet-dev:latest
