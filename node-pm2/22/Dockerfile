# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:node-pm2`

ARG ROOT_PATH=instructure
FROM --platform=${TARGETPLATFORM} ${ROOT_PATH}/node:22
MAINTAINER Instructure

USER root

# Install Nginx
RUN  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y apt-transport-https ca-certificates \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  nginx-extras=1.18.0-6ubuntu14.7 libnginx-mod-http-headers-more-filter \
  ruby \
  sudo \
  supervisor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN yarn global add pm2@5.3.0

RUN mkdir -p /usr/src/supervisord/ \
  && mkdir -p /usr/src/nginx/conf.d \
  && mkdir -p /usr/src/nginx/location.d \
  && mkdir -p /usr/src/nginx/main.d \
  && mkdir -p /usr/src/nginx/server.d \
  && mkdir -p /usr/src/app \
  && mkdir -p /var/log/app \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && ln -sf /dev/stdout /var/log/app/output.log \
  && ln -sf /dev/stderr /var/log/app/error.log

COPY entrypoint /usr/src/entrypoint
COPY supervisord/* /usr/src/supervisord/
COPY nginx.conf.erb /usr/src/nginx/nginx.conf.erb
COPY conf.d/* /usr/src/nginx/conf.d/
COPY default.config.json /usr/src/app/.pm2.config.default.json

RUN chown docker:docker -R /usr/src/supervisord \
  && chown docker:docker -R /usr/src/nginx \
  && chown docker:docker -R /var/lib/nginx \
  && chown docker:docker -R /var/log/app \
  && chgrp docker /var/run \
  && chmod g+w /var/run

USER docker

EXPOSE 80

ENTRYPOINT ["/tini", "--"]

CMD ["/usr/src/entrypoint"]
