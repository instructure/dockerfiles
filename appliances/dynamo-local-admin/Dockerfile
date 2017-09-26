# I'd like to use alpine, but for some reason, DynamoDB Local seems to hang
# in all the alpine java images.
FROM openjdk:8-jre

MAINTAINER Zach Wily <zach@instructure.com>

# We need java and node in this image, so we'll start with java (cause it's
# more hairy), and then dump in the node Dockerfile below. It'd be nice if there
# was a more elegant way to compose at the image level, but I suspect the
# response here would be "use two containers".

################################################################################
## START COPY FROM https://github.com/nodejs/docker-node
################################################################################
##
## Released under MIT License
## Copyright (c) 2015 Joyent, Inc.
## Copyright (c) 2015 Node.js contributors
##

# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex \
  && for key in \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
  ; do \
    gpg --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL error
ENV NODE_VERSION 8.5.0

RUN  curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && npm install -g npm@"$NPM_VERSION" \
  && npm cache clear --force

################################################################################
## END COPY
################################################################################

RUN npm install --no-optional --global dynamodb-admin@2.0.2

RUN cd /usr/lib && \
    curl -L https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz | tar xz
RUN mkdir -p /var/lib/dynamodb
VOLUME /var/lib/dynamodb

RUN apt-get update && \
    apt-get install -y supervisor nginx && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY nginx-proxy.conf /etc/nginx-proxy.conf
COPY supervisord.conf /etc/supervisord.conf

# Configure a sane default Java heap size (that can be overridden).
ENV JAVA_OPTS "-Xmx256m"

# Configuration for dynamo-admin to know where to hit dynamo.
ENV DYNAMO_ENDPOINT http://localhost:8002/

# For dinghy users.
ENV VIRTUAL_HOST dynamo.docker
ENV VIRTUAL_PORT 8000

# Main proxy on 8000, dynamo-admin on 8001, dynamodb on 8002
EXPOSE 8000 8001 8002

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
