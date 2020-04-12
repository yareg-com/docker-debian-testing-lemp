FROM debian:testing-slim

LABEL maintainer="Yar Rick <yar@yareg.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yy && apt-get install -yy apt-utils

RUN apt-get dist-upgrade -yy --purge && \        
    apt-get install -yy --no-install-recommends --no-install-suggests \
    procps \
    nano \
    nginx \
    php7.3-fpm \
    mariadb-server \
    composer \
    && \   
    apt-get clean && \
    apt-get autoremove -yy --purge && \
    rm -rf /var/lib/apt/lists/* \
		   /var/cache/apt/archives/*.deb \
		   /var/cache/apt/*cache.bin && \
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # create app directory
    mkdir -p /opt/app

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
