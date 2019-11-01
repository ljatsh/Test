FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y libreadline-dev autoconf g++ scons lua5.1

RUN apt-get install -y lua5.1-dev
RUN apt-get install -y gdb

RUN apt-get autoremove -y \
    && rm -fr /tmp/*

CMD ["/bin/bash"]