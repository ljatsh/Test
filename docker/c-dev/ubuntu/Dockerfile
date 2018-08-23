
FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

ARG LUAROCKS_VERSION="3.0.0"

RUN apt-get update \
    && apt-get install -y curl unzip make gcc-4.8 g++-4.8 gdb vim scons \
    && ln -s /usr/bin/gcc-4.8 /usr/bin/gcc \
    && ln -s /usr/bin/g++-4.8 /usr/bin/g++

# install cmake (default package was depended on gcc-5)
RUN cd /tmp \
    && curl -fSL https://cmake.org/files/v2.8/cmake-2.8.0.tar.gz -o cmake-2.8.0.tar.gz --progress \
    && tar xvzf cmake-2.8.0.tar.gz \
    && cd cmake-2.8.0 \
    && ./bootstrap --prefix=/usr -- -DCMAKE_BUILD_TYPE:STRING=Release \
    && make install

# install clib
RUN apt-get install -y libcurl4-gnutls-dev -qq
RUN apt-get install -y git
RUN ln -s /usr/bin/gcc /usr/bin/cc

RUN git clone https://github.com/clibs/clib.git /tmp/clib \
    && cd /tmp/clib \
    && make \
    && make install

# install cmocka (build failed under gcc 5 --> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=777818)
RUN git clone https://github.com/clibs/cmocka.git /tmp/cmocka \
    && mkdir -p /tmp/cmocka/build \
    && cd /tmp/cmocka/build \
    && cmake .. \
    && make \
    && make install

RUN apt-get autoremove -y \
    && rm -fr /tmp/*

CMD ["/bin/bash"]
