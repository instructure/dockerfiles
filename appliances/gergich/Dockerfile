FROM ruby:2.5-alpine

RUN apk add --no-cache \
    build-base \
    git \
    sqlite \
    sqlite-dev \
    sqlite-libs \
  && gem install gergich \
  && apk del --purge \
    build-base \
    sqlite-dev

WORKDIR /app

ENTRYPOINT ["gergich"]
