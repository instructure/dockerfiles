FROM --platform=${TARGETPLATFORM} alpine

RUN apk add --no-cache \
  gnupg

# Install Tini for init use (reaps defunct processes and forwards signals)

RUN apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
    aarch64) export PLATFORM='-arm64' ;; \
    x86_64) export PLATFORM='' ;; \
  esac; \
  wget -O /tini https://github.com/krallin/tini/releases/download/v0.19.0/tini$PLATFORM ;\
  wget -O /tini.asc https://github.com/krallin/tini/releases/download/v0.19.0/tini$PLATFORM.asc

ARG KEYSERVERS="ipv4.pool.sks-keyservers.net pgp.mit.edu keyserver.ubuntu.com"
RUN \
  set -ex; \
  for ks in ${KEYSERVERS}; do gpg --no-tty --keyserver "${ks}" --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break; done \
  && gpg --no-tty --batch --verify /tini.asc /tini \
  && chmod +x /tini
