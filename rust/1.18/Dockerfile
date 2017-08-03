# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:rust`

FROM instructure/core:latest
MAINTAINER Instructure

USER root

ENV RUST_VERSION 1.18.0
ENV RUST_DOWNLOAD_URL https://static.rust-lang.org/dist/rust-$RUST_VERSION-aarch64-unknown-linux-gnu.tar.gz
ENV RUST_DOWNLOAD_SHA256 b5754708958aba0de49455b0665d27fe670291e14e0c0ca68a03008a1cb985b0

RUN mkdir -p /usr/src/rust/

RUN curl -fsSL "$RUST_DOWNLOAD_URL" -o rust.tar.gz \
	&& echo "$RUST_DOWNLOAD_SHA256  rust.tar.gz" | sha256sum -c - \
	&& tar -C /usr/src/rust/ -xzf rust.tar.gz \
  && /usr/src/rust/rust-$RUST_VERSION-aarch64-unknown-linux-gnu/install.sh \
	&& rm rust.tar.gz

RUN apt-get update && \
	apt-get install -y \
		cmake \
		file \
    libssl-dev \
		xutils-dev \
		&& \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app && chown docker:docker /usr/src/rust
WORKDIR /usr/src/app

USER docker