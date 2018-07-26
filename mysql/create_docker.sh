#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name mysql --detach \
-v $dir/t:/usr/lib/mysql-test/t \
-v $dir/r:/usr/lib/mysql-test/r \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
mysql-dev:latest
