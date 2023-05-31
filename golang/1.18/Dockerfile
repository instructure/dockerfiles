# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:golang`

FROM instructure/core:jammy
MAINTAINER Instructure

USER root

ENV GOLANG_VERSION 1.18.10
ENV GOLANG_DOWNLOAD_URL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 5e05400e4c79ef5394424c0eff5b9141cb782da25f64f79d54c98af0a37f8d49

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
  && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

# For private gomodules that install via git, and to support Makefiles
RUN apt-get update \
  && apt-get install -y openssh-client make \
  && apt-get clean
RUN ssh-keyscan -p 29418 -H gerrit.instructure.com 2>/dev/null >> /etc/ssh/ssh_known_hosts
ENV GOPRIVATE gerrit.instructure.com,github.com/instructure

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV SRCPATH $GOPATH/src
RUN mkdir -p $SRCPATH && chown -R docker:docker $GOPATH
WORKDIR $SRCPATH

USER docker
