<%= generation_message %>
FROM instructure/node:<%= version %>
MAINTAINER Instructure

USER root

# Install Nginx with Passenger from official repository on x86_64
RUN if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
    && apt-get install -y apt-transport-https ca-certificates \
    && echo deb https://oss-binaries.phusionpassenger.com/apt/passenger <%= base_distro %> main > /etc/apt/sources.list.d/passenger.list ; \
  elif [ "$(dpkg --print-architecture)" = "arm64" ]; then \
    # Install Nginx with Passenger from Instructure packages on arm64
    curl -fsSL https://packagecloud.io/instructure/docker-support/gpgkey | gpg --dearmor | apt-key add - \
    && echo "deb https://packagecloud.io/instructure/docker-support/ubuntu <%= base_distro %> main" > /etc/apt/sources.list.d/instructure-ruby.list ; \
  fi

RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    nginx-extras \
    passenger \
    sudo \
<% if ['bionic', 'focal'].include? base_distro -%>
    libnginx-mod-http-passenger \
<% end -%>
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
