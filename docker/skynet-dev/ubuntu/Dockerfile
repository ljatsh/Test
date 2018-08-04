
FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG SKYNET_LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y curl unzip make libreadline-dev autoconf gcc gdb vim

# build skynet

COPY luaconf.h /tmp/

RUN cd /tmp \
    && curl -fSL https://github.com/cloudwu/skynet/archive/v1.1.0.zip -o skynet.zip --progress \
    && unzip skynet.zip -d . \
    && cd skynet-1.1.0/3rd \
    && rmdir jemalloc \
    && curl -fSL https://github.com/jemalloc/jemalloc/archive/5.1.0.zip -o 5.1.0.zip --progress \
    && unzip 5.1.0.zip -d . \
    && mv jemalloc-5.1.0 jemalloc \
    && cd .. \
    && mv /tmp/luaconf.h 3rd/lua/ \
    && make linux

# install skynet to /usr/local/skynet

RUN cd /tmp/skynet-1.1.0 \
    && for i in include lib bin; do mkdir -p /usr/local/skynet/lua/$i; done \
    && for i in lauxlib.h luaconf.h lua.h lua.hpp lualib.h; do cp 3rd/lua/$i /usr/local/skynet/lua/include; done \
    && cp 3rd/lua/liblua.a /usr/local/skynet/lua/lib \
    && for i in lua luac; do cp 3rd/lua/$i /usr/local/skynet/lua/bin; done \
    && for i in luaclib cservice lualib service; do cp -r $i /usr/local/skynet; done \
    && cp skynet /usr/local/skynet/

# install LuaRocks
RUN cd /tmp \
    && curl -fSL https://github.com/luarocks/luarocks/archive/${SKYNET_LUAROCKS_VERSION}.tar.gz -o luarocks-${SKYNET_LUAROCKS_VERSION}.tar.gz --progress \
    && tar xzf luarocks-${SKYNET_LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${SKYNET_LUAROCKS_VERSION} \
    && ./configure \
        --prefix=/usr/local/skynet/lua \
        --with-lua=/usr/local/skynet/lua \
    && make build \
    && make install

# install busted
RUN /usr/local/skynet/lua/bin/luarocks install busted

RUN apt-get autoremove -y

ENV PATH=$PATH:/usr/local/skynet/lua/bin:/usr/local/skynet

CMD ["/bin/bash"]
