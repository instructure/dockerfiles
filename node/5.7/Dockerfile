# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:node`

FROM instructure/core:latest
MAINTAINER Instructure

ENV NODE_VERSION 5.7.1
ENV NPM_VERSION 3.7.5

USER root

# verify gpg and sha256: http://nodejs.org/dist/v*/SHASUMS256.txt.asc
# Chris Dickinson <christopher.s.dickinson@gmail.com>
# Colin Ihrig <cjihrig@gmail.com>
# Evan Lucas <evanlucas@me.com>
# James M Snell <jasnell@keybase.io>
# Jeremiah Senkpiel <fishrock@keybase.io>
# Sam Roberts <octetcloud@keybase.io>
# Rod Vagg <rod@vagg.org>
# Myles Borins <myles.borins@gmail.com>
RUN  set -ex \
  && for key in \
       9554F04D7259F04124DE6B476D5A82AC7E37093B \
       94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
       B9AE9905FFD7803F25714661B63B535A4C206CA9 \
       71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
       FD3A5288F042B6850C66B31F09FE44734EB7990E \
       0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
       DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
       C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
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

COPY npm-private /usr/local/bin

USER docker
