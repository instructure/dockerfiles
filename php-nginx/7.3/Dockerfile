# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:php-nginx`

FROM instructure/php:7.3
LABEL maintainer=Instructure

USER root

RUN /bin/bash -c 'source /etc/lsb-release \
 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/nginx.list \
 && echo "deb-src http://ppa.launchpad.net/nginx/stable/ubuntu $DISTRIB_CODENAME main" >> /etc/apt/sources.list.d/nginx.list' \
 && curl "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xb96f2300ad11cbee" | apt-key add - \
 && curl "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x00a6f0a3c300ee8c" | apt-key add - \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
        php${PHP_VERSION}-cgi \
        php${PHP_VERSION}-fpm \
        nginx \
        python3-pip \
 && pip3 install supervisor setuptools \
 && apt-get purge --yes --autoremove python3-pip \
 # delete default php-fpm pool
 && rm -f /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm \
 && mkdir -p /usr/src/nginx/conf.d /usr/src/nginx/location.d /usr/src/nginx/main.d \
 && mkdir -p /usr/src/php/fpm /var/log/php \
 && mkdir -p /usr/src/supervisor \
 && mkdir -p /var/lib/nginx/body /var/lib/fastcgi \
 && chown -R docker:docker /usr/src/nginx /usr/src/php /usr/src/supervisor /var/run/php /var/log/nginx /var/lib/nginx \
 && mkdir -p /usr/src/app

COPY --chown=docker:docker entrypoint.d/ /entrypoint.d/
COPY --chown=docker:docker supervisor/ /usr/src/supervisor/

USER docker

CMD ["supervisord", "--configuration", "/usr/src/supervisor/supervisord.conf"]
