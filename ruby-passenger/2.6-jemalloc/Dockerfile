# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:ruby-passenger`

FROM instructure/ruby:2.6-jemalloc
MAINTAINER Instructure

USER root

#Install Nginx with Passenger from official repository
RUN  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y apt-transport-https ca-certificates \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nginx-extras \
    sudo \
    libnginx-mod-http-passenger \

# libnginx-mod-http-passenger in bionic destroys the alternatives in the base ruby image
    && update-alternatives --install /usr/bin/gem gem /usr/bin/gem$RUBY_MAJOR 181 \
    && update-alternatives \
      --install /usr/bin/ruby ruby /usr/bin/ruby${RUBY_MAJOR} 51 \
      --slave /usr/bin/erb erb /usr/bin/erb${RUBY_MAJOR} \
      --slave /usr/bin/irb irb /usr/bin/irb${RUBY_MAJOR} \
      --slave /usr/bin/rdoc rdoc /usr/bin/rdoc${RUBY_MAJOR} \
      --slave /usr/bin/ri ri /usr/bin/ri${RUBY_MAJOR} \

  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN gem install passenger --no-rdoc --no-ri

RUN echo 'docker ALL=(ALL) NOPASSWD: SETENV: /usr/sbin/nginx' >> /etc/sudoers

#Sensu check
COPY passenger_metrics.rb /monitoring/sensu/
COPY passenger_check /monitoring/sensu/
RUN chmod +x /monitoring/sensu/passenger_metrics.rb /monitoring/sensu/passenger_check

RUN gem install -i /var/lib/gems/$RUBY_MAJOR.0 nokogiri sensu-plugin

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
