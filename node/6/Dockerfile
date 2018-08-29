# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:node`

FROM instructure/core:latest
MAINTAINER Instructure

ENV NODE_VERSION 6.14.4
ENV NPM_VERSION 3.10.10

USER root

# verify gpg and sha256: http://nodejs.org/dist/v*/SHASUMS256.txt.asc
# Current Releases:
#  Colin Ihrig <cjihrig@gmail.com> 94AE36675C464D64BAFA68DD7434390BDBE9B9C5
#  Evan Lucas <evanlucas@me.com> B9AE9905FFD7803F25714661B63B535A4C206CA9
#  Gibson Fahnestock <gibfahn@gmail.com> 77984A986EBC2AA786BC0F66B01FBB92821C587A
#  James M Snell <jasnell@keybase.io> 71DCFD284A79C3B38668286BC97EC7A07EDE3FC1
#  Jeremiah Senkpiel <fishrock@keybase.io> FD3A5288F042B6850C66B31F09FE44734EB7990E
#  Michaël Zasso <targos@protonmail.com> 8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600
#  Myles Borins <myles.borins@gmail.com> C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8
#  Rod Vagg <rod@vagg.org> DD8F2338BAE7501E3DD5AC78C273792F7D83545D
# Old Releases:
#  Chris Dickinson <christopher.s.dickinson@gmail.com> 9554F04D7259F04124DE6B476D5A82AC7E37093B
#  Italo A. Casas <me@italoacasas.com> 56730D5401028683275BD23C23EFEFE93C4CFFFE
RUN set -ex \
 && for key in \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      9554F04D7259F04124DE6B476D5A82AC7E37093B \
      56730D5401028683275BD23C23EFEFE93C4CFFFE \
    ; do \
      gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key"; \
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
  && npm cache clear --force

COPY npm-private /usr/local/bin

USER docker
