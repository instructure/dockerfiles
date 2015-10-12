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

# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN  set -ex \
  && for key in \
       7937DFD2AB06298B2293C3187D33FF9D0246406D \
       114F43EE0176B71C7BC219DD50A3051F888C628D \
     ; do \
       gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
     done

ENV NODE_VERSION 0.12.7
ENV NPM_VERSION 2.13.3

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app
WORKDIR /usr/src/app

RUN  curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && npm install -g npm@"$NPM_VERSION" \
  && npm cache clear

USER docker
COPY nginx.conf.erb /usr/src/nginx/nginx.conf.erb
COPY entrypoint /usr/src/entrypoint

EXPOSE 80
CMD ["/usr/src/entrypoint"]
