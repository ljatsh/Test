
FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y curl unzip make libreadline-dev autoconf gcc gdb vim

RUN apt-get install -y libncurses-dev

# install lua
RUN cd /tmp \
    && curl -fSL http://www.lua.org/ftp/lua-5.1.5.tar.gz -o lua-5.1.5.tar.gz --progress \
    && tar xzf lua-5.1.5.tar.gz \
    && cd lua-5.1.5 \
    && make linux test \
    && make install

# install luarocks
RUN cd /tmp \
    && curl -fSL https://github.com/luarocks/luarocks/archive/${LUAROCKS_VERSION}.tar.gz -o luarocks-${LUAROCKS_VERSION}.tar.gz --progress \
    && tar xzf luarocks-${LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure \
    && make build \
    && make install

# install luasocket
RUN cd /tmp \
    && curl -fSL https://github.com/diegonehab/luasocket/archive/v3.0-rc1.zip -o luasocket.zip --progress \
    && unzip luasocket.zip -d . \
    && cd luasocket-3.0-rc1 \
    && make -e LUAV=5.1 linux \
    && make install test

# install busted
RUN luarocks install busted

RUN apt-get autoremove -y \
    && rm -fr /tmp/*

CMD ["/bin/bash"]
