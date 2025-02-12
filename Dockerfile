FROM registry.access.redhat.com/ubi9/ubi:latest

USER root

RUN dnf install -y \
    gcc \
    gcc-c++ \
    make \
    pcre-devel \
    openssl-devel \
    zlib-devel \
    unzip \
    tar \
    which \
    git \
    && dnf clean all

ENV OPENRESTY_VERSION=1.21.4.1
RUN curl -fSL https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz -o openresty.tar.gz \
    && tar -zxvf openresty.tar.gz \
    && cd openresty-${OPENRESTY_VERSION} \
    && ./configure --prefix=/usr/local/openresty \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf openresty-${OPENRESTY_VERSION} openresty.tar.gz

ENV LUAROCKS_VERSION=3.8.0
RUN curl -fSL https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz -o luarocks.tar.gz \
    && tar -zxvf luarocks.tar.gz \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure --prefix=/usr/local/openresty/luajit \
        --with-lua=/usr/local/openresty/luajit \
        --lua-suffix=jit-2.1.0-beta3 \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make \
    && make install \
    && cd .. \
    && rm -rf luarocks-${LUAROCKS_VERSION} luarocks.tar.gz

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-http

RUN mkdir -p /usr/local/openresty/nginx/conf

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

RUN chown -R 1001:1001 /usr/local/openresty

EXPOSE 8080

USER 1001

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]
