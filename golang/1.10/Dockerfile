# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:golang`

FROM instructure/core:bionic
MAINTAINER Instructure

USER root

ENV GOLANG_VERSION 1.10.8
ENV GOLANG_DOWNLOAD_URL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 d8626fb6f9a3ab397d88c483b576be41fa81eefcec2fd18562c87626dbb3c39e

# Per https://github.com/golang/go/issues/29906, there are extraneous build artifacts
# present in the 0.11.5 and 0.10.8 build tars.  Specifying `go` as the only component
# extracted from the tar is the suggested workaround.  This would be ill-advised for
# future releases Hence, replace the tar step below with
# "&& tar -C /usr/local -xzf golang.tar.gz \" on the next release.
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz go \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV SRCPATH $GOPATH/src
RUN mkdir -p $SRCPATH && chown -R docker:docker $GOPATH
WORKDIR $SRCPATH

USER docker
