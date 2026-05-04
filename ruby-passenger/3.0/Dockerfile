# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:ruby-passenger`

ARG ROOT_PATH=instructure
FROM --platform=${TARGETPLATFORM} ${ROOT_PATH}/ruby:3.0
LABEL org.opencontainers.image.authors="Instructure"

USER root

# Install Nginx with Passenger from official repository
RUN curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt | gpg --dearmor -o /etc/apt/trusted.gpg.d/phusion.gpg \
  && curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key-2025.txt | gpg --dearmor -o /etc/apt/trusted.gpg.d/phusion-2025.gpg \
  && echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nginx-extras \
    sudo \
    passenger \
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
 && mkdir -p /usr/src/nginx/server.d \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && chown docker:docker -R /usr/src/nginx

USER docker

EXPOSE 80
CMD ["/tini", "--", "/usr/src/entrypoint"]
