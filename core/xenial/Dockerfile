ARG TINI_VERSION=v0.16.1
FROM instructure/tini:${TINI_VERSION} as tini

FROM ubuntu:xenial
MAINTAINER Instructure

ENV DEBIAN_FRONTEND=noninteractive
## Create a 'docker' user
RUN addgroup --gid 9999 docker \
 && adduser --uid 9999 --gid 9999 --disabled-password --gecos "Docker User" docker \
 && usermod -L docker \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        language-pack-en \
        locales \
 && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        psmisc \
        python \
        software-properties-common \
        tzdata \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

## Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

# Install Tini for init use (reaps defunct processes and forwards signals)
COPY --from=tini /tini /tini

# Switch to the 'docker' user
USER docker
