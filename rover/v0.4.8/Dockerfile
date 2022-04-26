FROM rust:1-buster

RUN mkdir -p /tmp/rover \
  && wget -O - https://github.com/apollographql/rover/tarball/v0.4.8 | tar xz -C /tmp/rover --strip-components=1 \
  && cd /tmp/rover \
  && cargo run --release -- install
