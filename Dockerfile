FROM ubuntu:latest
MAINTAINER Volodymyr Roshko "roshko.v.m@gmail.com"
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install net-tools nginx
EXPOSE 80

COPY nginx.conf /etc/nginx
COPY mime.types /etc/nginx
COPY web /usr/share/nginx/html
COPY web /var/www/html

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
