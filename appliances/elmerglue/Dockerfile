FROM node:10-alpine
MAINTAINER Instructure

RUN apk add --no-cache make gcc g++ python \
 && npm install --global --production --unsafe-perm true elmerglue@0.0.5 \
 && apk --purge del make gcc g++ python

RUN mkdir /app
VOLUME /app

EXPOSE 5678

CMD ["/usr/local/bin/elmerglue", "--path", "/app"]
