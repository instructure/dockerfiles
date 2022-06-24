<%= generation_message %>
<%= from_image(base_image) %>
MAINTAINER Instructure

<% ruby_major = version.split('.').take(2).join('.').split('-')[0] -%>
<% ppa = ruby_major >= '3.0' ? 'ppa:instructure/ruby' : 'ppa:brightbox/ruby-ng' -%>
ENV RUBY_MAJOR <%= ruby_major %>
ENV BUNDLER_VERSION <%= bundler_version %>
ENV RUBYGEMS_VERSION <%= rubygems_version %>

USER root
RUN mkdir -p /usr/src/app
RUN chown docker:docker /usr/src/app

<% if base_distro == 'focal' -%>
RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

<% end -%>
RUN apt-add-repository -y <%= ppa %> \
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
 && apt-add-repository -y --remove <%= ppa %> \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

<% if ruby_major < '3.0' %>
RUN gem update  --no-document --system $RUBYGEMS_VERSION \
 && gem install --no-document -i /var/lib/gems/$RUBY_MAJOR.0 bundler -v $BUNDLER_VERSION
<% else %>
# On newer rubygems-integration the deb-installed rubygems cannot be updated outside apt's processes
# so only try to upgrade the bundler version
RUN gem install --no-document -i /var/lib/gems/$RUBY_MAJOR.0 bundler -v $BUNDLER_VERSION
<% end %>
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
