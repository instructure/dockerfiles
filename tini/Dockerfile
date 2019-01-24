FROM alpine

ARG TINI_VERSION=v0.16.1

RUN apk add --no-cache \
  gnupg

# Install Tini for init use (reaps defunct processes and forwards signals)
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN for i in 1 2 3 \
  ; do \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 || \
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
    gpg --verify /tini.asc && chmod +x /tini && break ; \
  done
