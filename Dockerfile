FROM openresty/openresty:alpine

USER root

RUN mkdir -p /var/run/openresty/nginx-client-body && \
    mkdir -p /var/run/openresty/nginx-proxy && \
    mkdir -p /var/run/openresty/nginx-fastcgi && \
    mkdir -p /var/run/openresty/nginx-uwsgi && \
    mkdir -p /var/run/openresty/nginx-scgi && \
    chown -R 1001:1001 /var/run/openresty

COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R 1001:1001 /etc/nginx

USER 1001

CMD ["openresty", "-g", "daemon off;"]
