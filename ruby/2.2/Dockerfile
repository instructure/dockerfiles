FROM instructure/core:latest
MAINTAINER Instructure

ENV RUBY_MAJOR 2.2
ENV BUNDLER_VERSION 1.7.11

USER root
RUN mkdir -p /usr/src/app
RUN chown docker:docker /usr/src/app

RUN apt-add-repository -y ppa:brightbox/ruby-ng
RUN  apt-get update \
  && apt-get install -y \
             ruby$RUBY_MAJOR \
             ruby$RUBY_MAJOR-dev \
             make \
             imagemagick \
             libbz2-dev \
             libcurl4-openssl-dev \
             libevent-dev \
             libffi-dev \
             libglib2.0-dev \
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
USER docker
RUN echo 'gem: --no-rdoc --no-ri' >> /home/docker/.gemrc
ENV GEM_HOME /home/docker/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN  gem install bundler -v $BUNDLER_VERSION \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"
ENV BUNDLE_APP_CONFIG $GEM_HOME
WORKDIR /usr/src/app
