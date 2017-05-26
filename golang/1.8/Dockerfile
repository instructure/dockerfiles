# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:golang`

FROM instructure/core:latest
MAINTAINER Instructure

USER root

ENV GOLANG_VERSION 1.8.3
ENV GOLANG_DOWNLOAD_URL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 1862f4c3d3907e59b04a757cfda0ea7aa9ef39274af99a784f5be843c80c6772

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV SRCPATH $GOPATH/src
RUN mkdir -p $SRCPATH && chown -R docker:docker $GOPATH
WORKDIR $SRCPATH

USER docker
