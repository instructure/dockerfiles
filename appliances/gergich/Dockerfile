FROM ruby:2.5-alpine

RUN apk add --no-cache sqlite sqlite-libs git sqlite-dev build-base && \
    gem install gergich --no-rdoc --no-ri && \
    apk del --purge build-base sqlite-dev

WORKDIR /app

ENTRYPOINT ["gergich"]