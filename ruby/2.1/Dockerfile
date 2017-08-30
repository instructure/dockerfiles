# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:ruby`

FROM instructure/core:latest
MAINTAINER Instructure

ENV RUBY_MAJOR 2.1
ENV BUNDLER_VERSION 1.15.3
ENV RUBYGEMS_VERSION 2.6.13

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

# https://imagetragick.com/ mitigation
RUN sed -i '/<\/policymap>/i\
  <!-- ImageTragick Mitigation -->\n\
  <policy domain="coder" rights="none" pattern="EPHEMERAL" />\n\
  <policy domain="coder" rights="none" pattern="URL" />\n\
  <policy domain="coder" rights="none" pattern="HTTPS" />\n\
  <policy domain="coder" rights="none" pattern="MVG" />\n\
  <policy domain="coder" rights="none" pattern="MSL" />\n\
  <policy domain="coder" rights="none" pattern="TEXT" />\n\
  <policy domain="coder" rights="none" pattern="SHOW" />\n\
  <policy domain="coder" rights="none" pattern="WIN" />\n\
  <policy domain="coder" rights="none" pattern="PLT" />' /etc/ImageMagick/policy.xml

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

