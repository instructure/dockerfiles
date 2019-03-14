# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:ruby`

FROM instructure/core:xenial
MAINTAINER Instructure

ENV RUBY_MAJOR 2.4
ENV BUNDLER_VERSION 1.17.3
ENV RUBYGEMS_VERSION 2.7.9

USER root
RUN mkdir -p /usr/src/app
RUN chown docker:docker /usr/src/app

RUN apt-add-repository -y ppa:brightbox/ruby-ng \
 && apt-get update \
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
 && apt-add-repository -y --remove ppa:brightbox/ruby-ng \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


RUN gem update --system $RUBYGEMS_VERSION \
 && gem install -i /var/lib/gems/$RUBY_MAJOR.0 bundler -v $BUNDLER_VERSION
ENV BUNDLE_APP_CONFIG /home/docker/.bundle

USER docker
RUN echo 'gem: --no-document' >> /home/docker/.gemrc \
 && mkdir -p /home/docker/.gem/ruby/$RUBY_MAJOR.0/build_info \
             /home/docker/.gem/ruby/$RUBY_MAJOR.0/cache \
             /home/docker/.gem/ruby/$RUBY_MAJOR.0/doc \
             /home/docker/.gem/ruby/$RUBY_MAJOR.0/extensions \
             /home/docker/.gem/ruby/$RUBY_MAJOR.0/gems \
             /home/docker/.gem/ruby/$RUBY_MAJOR.0/specifications
ENV GEM_HOME /home/docker/.gem/ruby/$RUBY_MAJOR.0
ENV PATH $GEM_HOME/bin:$PATH
WORKDIR /usr/src/app

