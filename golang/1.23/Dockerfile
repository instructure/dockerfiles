# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:golang`

FROM --platform=${TARGETPLATFORM} instructure/core:jammy
MAINTAINER Instructure

USER root

ARG TARGETARCH
ENV GOLANG_VERSION 1.23.9

RUN case "$TARGETARCH" in \
    amd64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="de03e45d7a076c06baaa9618d42b3b6a0561125b87f6041c6397680a71e5bb26"; \
      ;; \
    arm64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-arm64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="3dc4dd64bdb0275e3ec65a55ecfc2597009c7c46a1b256eefab2f2172a53a602"; \
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
