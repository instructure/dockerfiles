ARG ROOT_PATH=instructure
FROM ${ROOT_PATH}/tini:v0.19.0 AS tini
FROM ubuntu:bionic
MAINTAINER Instructure

ENV DEBIAN_FRONTEND=noninteractive
## Create a 'docker' user
RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com\//http:\/\/us-east-1\.ec2\.archive\.ubuntu\.com\//' /etc/apt/sources.list \
  && sed -i -e 's/http:\/\/ports\.ubuntu\.com\//http:\/\/us-east-1\.ec2\.ports\.ubuntu\.com\//' /etc/apt/sources.list
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
        gnupg \
 && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        psmisc \
        python \
        software-properties-common \
        tzdata \
 # gnupg2 and dirmngr will attempt to use IPv6 if it's enabled in Docker, even
 # if the container doesn't have an IPv6 address (this is true on Docker Hub).
 && mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
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
