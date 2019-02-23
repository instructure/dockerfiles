ARG TINI_VERSION=v0.16.1
FROM instructure/tini:${TINI_VERSION} as tini

FROM ubuntu:bionic
MAINTAINER Instructure

## Create a 'docker' user
RUN  addgroup --gid 9999 docker \
  && adduser --uid 9999 --gid 9999 --disabled-password --gecos "Docker User" docker \
  && usermod -L docker

## APT setup
## Upgrade all packages
## Install common tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    language-pack-en \
    locales \
 && apt-get install -y --no-install-recommends \
    curl \
    psmisc \
    git \
    build-essential \
    tzdata \
    dirmngr \
    gpg-agent \
    python3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

# gnupg2 and dirmngr will attempt to use IPv6 if it's enabled in Docker, even
# if the container doesn't have an IPv6 address (this is true on Docker Hub).
RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

## Add monitoring checks
RUN mkdir -p /monitoring/sensu/
COPY monitoring/sensu.sh /monitoring/sensu.sh
RUN chmod +x /monitoring/sensu.sh

## Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

# Install Tini for init use (reaps defunct processes and forwards signals)
COPY --from=tini /tini /tini

# Switch to the 'docker' user
USER docker
