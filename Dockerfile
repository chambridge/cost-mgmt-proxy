FROM openresty/openresty:ubi9

USER root

RUN mkdir -p /var/run/openresty /user/local/openresty/nginx/client_body_temp \
    /usr/local/openresty/nginx/proxy_temp /usr/local/openresty/nginx/logs && \
    chown -R 1001:1001 /var/run/openresty /usr/local/openresty/nginx

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
RUN chown -R 1001:1001 /usr/local/openresty/nginx/conf/nginx.conf

USER 1001

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
