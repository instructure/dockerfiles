FROM alpine

RUN apk add --no-cache \
  gnupg

# Install Tini for init use (reaps defunct processes and forwards signals)
ARG TINI_VERSION=v0.18.0
ARG KEYSERVERS="ipv4.pool.sks-keyservers.net pgp.mit.edu keyserver.ubuntu.com"
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN \
  set -ex; \
  for ks in ${KEYSERVERS}; do gpg --no-tty --keyserver "${ks}" --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break; done \
  && gpg --no-tty --batch --verify /tini.asc /tini \
  && chmod +x /tini