<%= generation_message %>
<%= from_image(base_image) %>
LABEL org.opencontainers.image.authors="Instructure"

USER root

# Install Nginx with Passenger from official repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
    && apt-get install -y apt-transport-https ca-certificates \
    && echo deb https://oss-binaries.phusionpassenger.com/apt/passenger <%= base_distro %> main > /etc/apt/sources.list.d/passenger.list

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nginx-extras \
    sudo \
    passenger<%= passenger_version ? "=#{passenger_version}" : "" %> \
    libnginx-mod-http-passenger<%= passenger_version ? "=#{passenger_version}" : "" %> \
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
