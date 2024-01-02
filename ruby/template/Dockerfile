<%= generation_message %>
<%= from_image(base_image) %>
MAINTAINER Instructure
<% if cache_bust -%>
ENV CACHE_BUST <%= cache_bust %>
<% end -%>

<% ruby_major = version.split('.').take(2).join('.').split('-')[0] -%>
<% ppa = ((base_distro == 'jammy' || ruby_major >= '3.0') ? ((ruby_major >= '3.0') ? 'ppa:instructure/ruby' : 'ppa:maths22/ruby-testing') : 'ppa:brightbox/ruby-ng') -%>
ENV RUBY_MAJOR <%= ruby_major %>
<% if ruby_major < '3.0' -%>
ENV BUNDLER_VERSION <%= bundler_version %>
<% final_bundler_version = "$BUNDLER_VERSION" -%>
<% else -%>
<% final_bundler_version = bundler_version -%>
<% end -%>
<% if (ruby_major < '3.0' && base_distro != 'jammy') -%>
ENV RUBYGEMS_VERSION <%= rubygems_version %>
<% end -%>

USER root
RUN mkdir -p /usr/src/app
RUN chown docker:docker /usr/src/app

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      software-properties-common \
 && apt-add-repository -y <%= ppa %> \
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
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ \
<% if (ruby_major < '3.0' && base_distro != 'jammy') -%>
 && gem update  --no-document --system $RUBYGEMS_VERSION \
<% end -%>
# On newer rubygems-integration the deb-installed rubygems cannot be updated outside apt's processes
# so only try to upgrade the bundler version
 && gem install --no-document -i /var/lib/gems/$RUBY_MAJOR.0 bundler -v <%= final_bundler_version %>

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
