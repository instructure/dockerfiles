# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:golang`

FROM --platform=${TARGETPLATFORM} instructure/core:jammy
MAINTAINER Instructure

USER root

ARG TARGETARCH
ENV GOLANG_VERSION 1.24.3

RUN case "$TARGETARCH" in \
    amd64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="3333f6ea53afa971e9078895eaa4ac7204a8c6b5c68c10e6bc9a33e8e391bdd8"; \
      ;; \
    arm64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-arm64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="a463cb59382bd7ae7d8f4c68846e73c4d589f223c589ac76871b66811ded7836"; \
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
