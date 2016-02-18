FROM instructure/core:latest
MAINTAINER Instructure

USER root

ENV GOLANG_VERSION 1.6
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 5470eac05d273c74ff8bac7bef5bad0b5abbd1c4052efbdbc8db45332e836b0b

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
