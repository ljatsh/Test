
FROM ubuntu:xenial

MAINTAINER ljatsh@test.com

RUN apt-get update \
    && apt-get install -y curl unzip make git libreadline-dev autoconf gcc

RUN apt-get install -y 

RUN cd /tmp \
    && curl -fSL https://github.com/cloudwu/skynet/archive/v1.1.0.zip -o skynet.zip --progress \
    && unzip skynet.zip -d . \
    && cd skynet-1.1.0/3rd \
    && rmdir jemalloc \
    && curl -fSL https://github.com/jemalloc/jemalloc/archive/5.1.0.zip -o 5.1.0.zip --progress \
    && unzip 5.1.0.zip -d . \
    && mv jemalloc-5.1.0 jemalloc \
    && cd .. \
    && make linux

RUN apt-get autoremove -y

CMD ["/bin/bash"]
