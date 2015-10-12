FROM instructure/ruby:2.1
MAINTAINER Instructure

USER root

#Install Nginx with Passenger from official repository
RUN  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y apt-transport-https ca-certificates \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update \
  && apt-get install -y --no-install-recommends nginx-extras passenger \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN  echo 'docker ALL=(ALL) NOPASSWD: SETENV: /usr/sbin/nginx' >> /etc/sudoers \
  && mkdir -p /usr/src/nginx/main.d \
  && mkdir -p /usr/src/nginx/conf.d \
  && mkdir -p /usr/src/nginx/location.d \
  && chown docker:docker /usr/src/nginx

RUN  ln -sf /dev/stdout /var/log/nginx/access.log \ 
  && ln -sf /dev/stderr /var/log/nginx/error.log

#Sensu check
COPY passenger_metrics.rb /monitoring/sensu/
COPY passenger_check /monitoring/sensu/
RUN chmod +x /monitoring/sensu/passenger_metrics.rb /monitoring/sensu/passenger_check \
  && gem install sensu-plugin nokogiri


USER docker
COPY nginx.conf.erb /usr/src/nginx/nginx.conf.erb
COPY entrypoint /usr/src/entrypoint

EXPOSE 80
CMD ["/usr/src/entrypoint"]
