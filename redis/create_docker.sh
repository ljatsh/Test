#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name redis --detach \
-p 6379:6379 \
redis:4.0
