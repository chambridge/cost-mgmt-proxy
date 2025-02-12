FROM nginxinc/nginx-unpriviledged:latest

USER root

RUN apt-get update && apt-get install -y \
    libnginx-mod-http-lua lua-resty-http && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R 101:101 /etc/nginx

USER 101

CMD ["nginx", "-g", "daemon off;"]
