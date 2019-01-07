FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y curl unzip make libreadline-dev autoconf gcc vim git

RUN apt-get install -y libncurses-dev

# install gawk
# https://www.gnu.org/software/gawk/manual/html_node/Installation.html#Installation
RUN cd /tmp \
    && curl -fSL https://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz -o gawk-4.2.1.tar.gz --progress \
    && tar xzf gawk-4.2.1.tar.gz \
    && cd gawk-4.2.1 \
    && ./configure \
    && make install

# install gawk-unittest
RUN cd /tmp \
    && git clone https://github.com/soimort/awkunit.git awkunit \
    && export AWKSRCPATH=/tmp/gawk-4.2.1 \
    && cd awkunit \
    && sed -i "s#PREFIX=/usr#PREFIX=/usr/local#g" Makefile \
    && make install

# install bats
RUN cd /tmp \
    && git clone https://github.com/sstephenson/bats.git \
    && cd bats \
    && ./install.sh /usr/local

RUN apt-get autoremove -y \
    && rm -r /usr/bin/awk \
    && ln -s /usr/local/bin/awk /usr/bin/awk \
    && rm -fr /tmp/*

CMD ["/bin/bash"]