
FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y curl unzip make libreadline-dev autoconf gcc gdb vim

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

# install busted & lpeg
RUN luarocks install busted \
    && luarocks install lpeg

# install gtests
RUN apt-get update \
    && apt-get install -y cmake g++ scons

RUN cd /tmp \
    && curl -fSL https://github.com/google/googletest/archive/release-1.8.0.zip -o release-1.8.0.zip --progress \
    && unzip release-1.8.0.zip -d . \
    && cd googletest-release-1.8.0 \
    && cmake . \
    && make \
    && make install

RUN apt-get autoremove -y \
    && rm -fr /tmp/*

CMD ["/bin/bash"]
