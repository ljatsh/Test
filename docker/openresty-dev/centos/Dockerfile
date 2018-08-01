# Dockerfile - CentOS 7 - RPM version
# https://github.com/openresty/docker-openresty

ARG RESTY_IMAGE_BASE="centos"
ARG RESTY_IMAGE_TAG="7"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="Evan Wies <evan@neomantra.net>"

ARG RESTY_IMAGE_BASE="centos"
ARG RESTY_LUAROCKS_VERSION="2.4.4"
ARG RESTY_RPM_FLAVOR=""
ARG RESTY_RPM_VERSION="1.13.6.2-1.el7.centos"
ARG RESTY_RPM_ARCH="x86_64"

LABEL resty_luarocks_version="${RESTY_LUAROCKS_VERSION}"
LABEL resty_rpm_flavor="${RESTY_RPM_FLAVOR}"
LABEL resty_rpm_version="${RESTY_RPM_VERSION}"
LABEL resty_rpm_arch="${RESTY_RPM_ARCH}"

RUN yum-config-manager --add-repo https://openresty.org/package/${RESTY_IMAGE_BASE}/openresty.repo \
    && yum install -y \
        gettext \
        make \
        openresty${RESTY_RPM_FLAVOR}-${RESTY_RPM_VERSION}.${RESTY_RPM_ARCH} \
        openresty-opm-${RESTY_RPM_VERSION} \
        openresty-resty-${RESTY_RPM_VERSION} \
        unzip \
    && cd /tmp \
    && curl -fSL https://github.com/luarocks/luarocks/archive/${RESTY_LUAROCKS_VERSION}.tar.gz -o luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && tar xzf luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${RESTY_LUAROCKS_VERSION} \
    && ./configure \
        --prefix=/usr/local/openresty/luajit \
        --with-lua=/usr/local/openresty/luajit \
        --lua-suffix=jit-2.1.0-beta3 \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make build \
    && make install \
    && cd /tmp \
    && rm -rf luarocks-${RESTY_LUAROCKS_VERSION} luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && yum remove -y make \
    && yum clean all \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# build cmake 3.12.0
RUN yum install -y which make gcc gcc-c++ \
    cd /tmp \
    && curl -fSL https://cmake.org/files/v3.12/cmake-3.12.0.tar.gz -o cmake-3.12.0.tar.gz \
    && tar xvzf cmake-3.12.0.tar.gz \
    && cd cmake-3.12.0 \
    && ./bootstrap --prefix=/usr -- -DCMAKE_BUILD_TYPE:STRING=Release \
    && make install \
    && cd .. \
    && rm -fr cmake-3.12.0 cmake-3.12.tar.gz

# build libbson
RUN curl -fSL https://github.com/mongodb/mongo-c-driver/releases/download/1.11.0/mongo-c-driver-1.11.0.tar.gz -o mongo-c-driver-1.11.0.tar.gz \
    && tar xvzf mongo-c-driver-1.11.0.tar.gz \
    && cd mongo-c-driver-1.11.0 \
    && mkdir cmake-build \
    && cd cmake-build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/openresty/bson -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DENABLE_BSON=ONLY .. \
    && make install \
    && cd ../.. \
    && rm -fr mongo-c-driver-1.11.0 mongo-c-driver-1.11.0.tar.gz

RUN curl -fSL https://github.com/isage/lua-cbson/archive/master.zip -o lua-cbson.zip \
    && unzip lua-cbson.zip -d . \
    && cd lua-cbson-master \
    && mkdir build \
    && cd build \
    && cmake -DLIBBSON_INCLUDE_DIR:PATH=/usr/local/openresty/bson/include/libbson-1.0 -DLIBBSON_LIBRARY:FILEPATH=/usr/local/openresty/bson/lib64/libbson-1.0.so .. \
    && make \
    && cp cbson.so /usr/local/openresty/lualib \
    && cd ../.. \
    && rm -fr lua-cbson.zip lua-cbson-master

# install lua-resty-busted
RUN yum -y git \
    && luarocks install lua-resty-busted \
    && luarocks install busted 2.0.rc12-1 \
    && luarocks remove --force busted 2.0.rc11-0

# install cpan
RUN yum install -y wget cpan \
    && mkdir -p /root/.cpan/CPAN \
    && yum clean all

# Copy cpan configuration files
COPY MyConfig.pm /root/.cpan/CPAN/MyConfig.pm
RUN cpan -f -i Test::Nginx

# Unused, present for parity with other Dockerfiles
# This makes some tooling/testing easier, as specifying a build-arg
# and not consuming it fails the build.
ARG RESTY_J="1"

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

# Copy nginx configuration files
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/bin/openresty", "-g", "daemon off;"]