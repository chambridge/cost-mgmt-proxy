FROM openresty/openresty:alpine

COPY nginx.conf /etc/nginx/nginx.conf

CMD["openresty", "-g", "daemon off;"]
