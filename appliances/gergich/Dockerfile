FROM --platform=${TARGETPLATFORM} ruby:2.7-alpine

RUN apk add --no-cache \
    git \
    sqlite-libs

# sqlite3 1.6.9 is the last version that supports Ruby 2.7
# multi_xml 0.6.0 is the last version that supports Ruby 2.7
# --platform ruby because the precompiled arm64 sqlite3 gem is glibc-only
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    sqlite-dev \
  && gem install sqlite3:1.6.9 --platform ruby --no-document -- --enable-system-libraries \
  && gem install multi_xml:0.6.0 \
    gergich:2.2.0 \
  && apk del .build-deps

WORKDIR /app

ENTRYPOINT ["gergich"]
