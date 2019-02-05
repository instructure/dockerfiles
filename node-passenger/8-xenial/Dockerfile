# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:node-passenger`

FROM instructure/node:8-xenial
MAINTAINER Instructure

USER root

#Install Nginx with Passenger from official repository
RUN  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y apt-transport-https ca-certificates \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nginx-extras \
    passenger \
    sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'docker ALL=(ALL) NOPASSWD: SETENV: /usr/sbin/nginx' >> /etc/sudoers

USER docker
RUN passenger-config build-native-support

# Nginx Configuration
USER root

COPY entrypoint /usr/src/entrypoint
COPY nginx.conf.erb /usr/src/nginx/nginx.conf.erb
COPY main.d/* /usr/src/nginx/main.d/
RUN mkdir -p /usr/src/nginx/conf.d \
 && mkdir -p /usr/src/nginx/location.d \
 && mkdir -p /usr/src/nginx/main.d \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && chown docker:docker -R /usr/src/nginx

USER docker

EXPOSE 80
CMD ["/tini", "--", "/usr/src/entrypoint"]
