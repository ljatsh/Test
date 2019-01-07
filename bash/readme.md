Utilities
=========

常见Linux命令工具

Table of Contents
=================

* [hexdump](#hexdump)
* [read](#read)

hexdump
-------

* [man](http://man7.org/linux/man-pages/man1/hexdump.1.html)
* 重用选项:
  * 显示可以打印的字符
    ```bash
    hexdump -s 16 -n 32 -C create_docker.sh

    00000010  3d 24 28 63 64 20 60 64  69 72 6e 61 6d 65 20 24  |=$(cd `dirname $|
    00000020  30 60 3b 20 70 77 64 29  0a 0a 64 6f 63 6b 65 72  |0`; pwd)..docker|
    00000030
    ```
  * 自定义格式
    ```bash
    hexdump  -e '16/1 "%02x " " |"' -e '16/1 "%_p" "|"  "\n"'  create_docker.sh 

    23 21 2f 62 69 6e 2f 62 61 73 68 0a 0a 64 69 72 |#!/bin/bash..dir|
    3d 24 28 63 64 20 60 64 69 72 6e 61 6d 65 20 24 |=$(cd `dirname $|
    30 60 3b 20 70 77 64 29 0a 0a 64 6f 63 6b 65 72 |0`; pwd)..docker|
    20 72 75 6e 20 2d 2d 6e 61 6d 65 20 6c 75 61 35 | run --name lua5|
    33 20 2d 69 74 20 2d 2d 72 6d 20 5c 0a 2d 76 20 |3 -it --rm \.-v |
    24 64 69 72 3a 2f 6f 70 74 2f 64 65 76 20 5c 0a |$dir:/opt/dev \.|
    2d 77 20 2f 6f 70 74 2f 64 65 76 20 5c 0a 6c 75 |-w /opt/dev \.lu|
    61 35 33 2d 64 65 76 3a 6c 61 74 65 73 74 0a    |a53-dev:latest.|
    ```

read
----

* [read](http://man7.org/linux/man-pages/man1/read.1p.html)