FROM instructure/core:latest
MAINTAINER Instructure

USER root

ENV NODE_VERSION 4.3.1
ENV NPM_VERSION 3.7.5

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
