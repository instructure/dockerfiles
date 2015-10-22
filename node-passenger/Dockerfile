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
  # gpg: aka "Chris Dickinson <christopher.s.dickinson@gmail.com>"
  # gpg: aka "Colin Ihrig <cjihrig@gmail.com>"
  # gpg: aka "Sam Roberts <octetcloud@keybase.io>"
  # gpg: aka "Jeremiah Senkpiel <fishrock@keybase.io>"
  # gpg: aka "James M Snell <jasnell@keybase.io>"
  # gpg: aka "Rod Vagg <rod@vagg.org>"
  RUN  set -ex \
    && for key in \
         7937DFD2AB06298B2293C3187D33FF9D0246406D \
         114F43EE0176B71C7BC219DD50A3051F888C628D \
         9554F04D7259F04124DE6B476D5A82AC7E37093B \
         94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
         0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
         FD3A5288F042B6850C66B31F09FE44734EB7990E \
         71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
         DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
       ; do \
         gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
       done

ENV NODE_VERSION 4.2.1
ENV NPM_VERSION 3.3.9

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
