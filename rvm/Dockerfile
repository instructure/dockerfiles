FROM instructure/core:focal
MAINTAINER Instructure

USER root
RUN apt-get update \
 && apt-get install -y \
      autoconf \
      automake \
      bison \
      g++ \
      gawk \
      imagemagick \
      libbz2-dev \
      libcurl4-openssl-dev \
      libevent-dev \
      libffi-dev \
      libgdbm-dev \
      libglib2.0-dev \
      libgmp-dev \
      libjpeg-dev \
      libmagickcore-dev \
      libmagickwand-dev \
      libmysqlclient-dev \
      libncurses-dev \
      libncurses5-dev \
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      make \
      patch \
      sqlite3 \
      zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app

USER docker

# Install RVM
RUN set -ex && \
  for key in \
     409B6B1796C275462A1703113804BB82D39DC0E3 \
     7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
  ; do \
      gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$key" || \
      gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done

RUN curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail stable \
 && echo 'bundler' >> /home/docker/.rvm/gemsets/global.gems \
 && echo 'rvm_silence_path_mismatch_check_flag=1' >> ~/.rvmrc

SHELL ["/bin/bash", "-lc"]
CMD ["/bin/bash", "-l"]

# Install Rubies
RUN rvm install 2.6.10 \
  && rvm alias create 2.6 ruby-2.6.10 \
  && rvm install 2.7.8 \
  && rvm alias create 2.7 ruby-2.7.8 \
  && rvm install 3.0.6 \
  && rvm alias create 3.0 ruby-3.0.6 \
  && rvm install 3.1.4 \
  && rvm alias create 3.1 ruby-3.1.4 \
  && rvm use --default 3.1.4 \
  && rvm install 3.2.2 \
  && rvm alias create 3.2 ruby-3.2.2 \
  && rvm use --default 3.2.2
WORKDIR /usr/src/app
