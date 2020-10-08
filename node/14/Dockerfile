# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:node`

FROM instructure/core:focal
LABEL maintainer="Instructure"

USER root

ENV YARN_VERSION latest

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

COPY yarn-private /usr/local/bin

ENV NODE_VERSION 14
ENV NPM_VERSION latest

# verify gpg and sha256: http://nodejs.org/dist/v*/SHASUMS256.txt.asc
# See: https://github.com/nodejs/node#release-keys
RUN set -ex && \
  for key in \
     4ED778F539E3634C779C87C6D7062848A1AB005C \
     94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
     71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
     8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
     C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
     C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
     DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
     A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
     B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
      gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y --no-install-recommends \
  xz-utils \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

RUN NODE_FILE="$(curl -sfS https://nodejs.org/dist/latest-v$NODE_VERSION.x/ | grep -oE node-v${NODE_VERSION}\.[0-9.]+-linux-x64.tar.xz | sort -r | head -n 1)" && \
  NODE_LATEST_VERSION=$(echo $NODE_FILE | grep -oE "v[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+") && \
  curl -fsSLO --compressed "https://nodejs.org/dist/$NODE_LATEST_VERSION/$NODE_FILE" && \
  curl -fsSLO --compressed "https://nodejs.org/dist/$NODE_LATEST_VERSION/SHASUMS256.txt.asc" && \
  gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc && \
  grep " $NODE_FILE\$" SHASUMS256.txt.asc | sha256sum -c - && \
  tar -xJf "$NODE_FILE" --warning=no-unknown-keyword -C /usr/local --strip-components=1 --no-same-owner && \
  ls -la /usr/local/bin/n* && \
  rm "$NODE_FILE" SHASUMS256.txt.asc SHASUMS256.txt && \
  npm install -g "npm@$NPM_VERSION" && \
  npm cache clean --force

COPY npm-private /usr/local/bin


USER docker
