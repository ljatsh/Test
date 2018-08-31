
FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y curl unzip make libreadline-dev autoconf gcc gdb vim scons

RUN apt-get install -y libncurses-dev

# install luajit
RUN cd /tmp \
    && curl -fSL http://luajit.org/download/LuaJIT-2.0.5.tar.gz -o LuaJIT-2.0.5.tar.gz --progress \
    && tar xzf LuaJIT-2.0.5.tar.gz \
    && cd LuaJIT-2.0.5 \
    && make \
    && make install

# install luarocks
RUN cd /tmp \
    && curl -fSL https://github.com/luarocks/luarocks/archive/${LUAROCKS_VERSION}.tar.gz -o luarocks-${LUAROCKS_VERSION}.tar.gz --progress \
    && tar xzf luarocks-${LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure \
        --with-lua-include=/usr/local/include/luajit-2.0 \
    && make build \
    && make install

# install busted
RUN luarocks install busted

# install luv
RUN apt-get install -y git g++ libtool \
    && ln -s /usr/bin/libtoolize /usr/bin/libtool

RUN git clone https://github.com/ljatsh/luv.git /tmp/luv \
    && cd /tmp/luv \
    && make \
    && cp src/luv.so /usr/local/lib/lua/5.1

# install http-parser
RUN luarocks install lua-http-parser

RUN apt-get autoremove -y \
    && rm -fr /tmp/*

CMD ["/bin/bash"]
