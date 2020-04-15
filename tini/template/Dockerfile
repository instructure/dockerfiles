FROM <%= base_image %>

RUN apk add --no-cache \
  gnupg

# Install Tini for init use (reaps defunct processes and forwards signals)
ARG KEYSERVERS="ipv4.pool.sks-keyservers.net pgp.mit.edu keyserver.ubuntu.com"
ADD https://github.com/krallin/tini/releases/download/<%= version %>/tini /tini
ADD https://github.com/krallin/tini/releases/download/<%= version %>/tini.asc /tini.asc
RUN \
  set -ex; \
  for ks in ${KEYSERVERS}; do gpg --no-tty --keyserver "${ks}" --recv-keys <%= gpg_key %> && break; done \
  && gpg --no-tty --batch --verify /tini.asc /tini \
  && chmod +x /tini
