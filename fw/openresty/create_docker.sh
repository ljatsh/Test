#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name openresty --detach \
-v $dir/conf.d:/etc/nginx/conf.d \
-v $dir:/opt/dev \
-p 8010:80 \
--link mysql \
--link redis \
-w /opt/dev \
openresty-dev:latest
