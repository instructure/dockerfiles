FROM instructure/core:xenial
MAINTAINER Instructure

USER root
RUN apt-get update \
 && apt-get install -y \
      autoconf \
      automake \
      bison \
      gawk \
      sqlite3 \
      make \
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
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app

USER docker

# Install RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys \
      409B6B1796C275462A1703113804BB82D39DC0E3 \
      7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail stable \
 && echo 'bundler' >> /home/docker/.rvm/gemsets/global.gems \
 && echo 'rvm_silence_path_mismatch_check_flag=1' >> ~/.rvmrc

SHELL ["/bin/bash", "-lc"]
CMD ["/bin/bash", "-l"]

# Install Rubies
RUN rvm install 2.3.8 \
 && rvm alias create 2.3 ruby-2.3.8 \
 && rvm install 2.4.6 \
 && rvm alias create 2.4 ruby-2.4.6 \
 && rvm install 2.5.5 \
 && rvm alias create 2.5 ruby-2.5.5 \
 && rvm install 2.6.3 \
 && rvm alias create 2.6 ruby-2.6.3 \
 && rvm use --default 2.6.3

WORKDIR /usr/src/app
