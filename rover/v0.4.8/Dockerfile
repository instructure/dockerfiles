FROM --platform=${TARGETPLATFORM} rust:1.60.0-slim-buster
LABEL maintainer="Instructure"

RUN mkdir -p /tmp/rover \
  && apt-get update && apt-get install -y \
      build-essential \
      curl \
      wget \
  && wget -O - https://github.com/apollographql/rover/tarball/v0.4.8 | tar xz -C /tmp/rover --strip-components=1 \
  && cd /tmp/rover \
  && cargo run --release -- install \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
