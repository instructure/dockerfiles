# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:golang`

FROM --platform=${TARGETPLATFORM} instructure/core:jammy
MAINTAINER Instructure

USER root

ARG TARGETARCH
ENV GOLANG_VERSION 1.21.13

RUN case "$TARGETARCH" in \
    amd64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="502fc16d5910562461e6a6631fb6377de2322aad7304bf2bcd23500ba9dab4a7"; \
      ;; \
    arm64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-arm64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="2ca2d70dc9c84feef959eb31f2a5aac33eefd8c97fe48f1548886d737bffabd4"; \
      ;; \
    *) echo >&2 "unsupported architecture: $TARGETARCH"; exit 1 ;; \
  esac; \
  curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
  && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

# For private gomodules that install via git, and to support Makefiles
RUN apt-get update \
  && apt-get install -y openssh-client git make \
  && apt-get clean
RUN ssh-keyscan -p 29418 -H gerrit.instructure.com 2>/dev/null >> /etc/ssh/ssh_known_hosts
ENV GOPRIVATE gerrit.instructure.com,github.com/instructure

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV SRCPATH $GOPATH/src
RUN mkdir -p $SRCPATH && chown -R docker:docker $GOPATH
WORKDIR $SRCPATH

USER docker
