FROM --platform=${TARGETPLATFORM} ruby:2.7-alpine

RUN apk add --no-cache \
    build-base \
    git \
    sqlite \
    sqlite-dev \
    sqlite-libs \
  && apk del --purge \
    build-base \
    sqlite-dev

# sqlite3 1.6.9 is the last version that supports Ruby 2.7
# multi_xml 0.6.0 is the last version that supports Ruby 2.7
RUN gem install sqlite3:1.6.9 \
    multi_xml:0.6.0 \
    gergich:2.2.0

WORKDIR /app

ENTRYPOINT ["gergich"]
