
FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y curl unzip make libreadline-dev autoconf gcc vim

RUN apt-get install -y libncurses-dev

# install lua
RUN cd /tmp \
    && curl -fSL http://www.lua.org/ftp/lua-5.3.5.tar.gz -o lua-5.3.5.tar.gz --progress \
    && tar xzf lua-5.3.5.tar.gz \
    && cd lua-5.3.5 \
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

# install busted, luaposix
RUN luarocks install busted 
RUN luarocks install luaposix

# install gyp
RUN apt-get install -y git python
RUN apt-get install -y python-setuptools
RUN git clone https://chromium.googlesource.com/external/gyp.git /tmp/gyp \
    && cd /tmp/gyp \
    && python setup.py install
RUN apt-get install -y g++

RUN apt-get autoremove -y \
    && rm -fr /tmp/*

CMD ["/bin/bash"]
