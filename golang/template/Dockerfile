<%= generation_message %>
FROM <%= base_image %>
MAINTAINER Instructure

USER root

ENV GOLANG_VERSION <%= full_version %>
ENV GOLANG_DOWNLOAD_URL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 <%= package_sha %>

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
