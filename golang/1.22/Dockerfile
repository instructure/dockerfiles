# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:golang`

FROM instructure/core:jammy
MAINTAINER Instructure

USER root

ENV GOLANG_VERSION 1.22.6

RUN dpkgArch="$(dpkg --print-architecture)"; \
  case "$dpkgArch" in \
    amd64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="999805bed7d9039ec3da1a53bfbcafc13e367da52aa823cb60b68ba22d44c616"; \
      ;; \
    arm64) \
      export GOLANG_DOWNLOAD_URL="https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-arm64.tar.gz"; \
      export GOLANG_DOWNLOAD_SHA256="c15fa895341b8eaf7f219fada25c36a610eb042985dc1a912410c1c90098eaf2"; \
      ;; \
    *) echo >&2 "unsupported architecture: $dpkgArch"; exit 1 ;; \
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
