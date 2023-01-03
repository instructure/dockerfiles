FROM --platform=${TARGETPLATFORM} openjdk:11-jre-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      dirmngr \
      gnupg2 \
      nginx \
      supervisor \
      xz-utils \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

# We need java and node in this image, so we'll start with java (cause it's
# more hairy), and then dump in the node Dockerfile below. It'd be nice if there
# was a more elegant way to compose at the image level, but I suspect the
# response here would be "use two containers".

ENV NODE_VERSION 12
ENV NPM_CONFIG_LOGLEVEL error

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
  apt-get update && \
  apt-get install -y --no-install-recommends nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ && \
  npm install -g "npm@$NPM_VERSION" && \
  npm cache clean --force

RUN npm install --no-optional --global dynamodb-admin@4.0.0 \
 && npm cache clean --force

RUN mkdir -p /var/lib/dynamodb && cd /usr/lib && \
    curl -L https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz | tar xz
VOLUME /var/lib/dynamodb

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
