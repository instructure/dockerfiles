FROM instructure/core:latest
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

USER docker
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 \
    && /bin/bash -l -c "curl -L get.rvm.io | bash -s -- --autolibs=read-fail stable" \
    && echo "bundler" >> /home/docker/.rvm/gemsets/global.gems \
    && /bin/bash -l -c "rvm install 2.1" \
    && /bin/bash -l -c "rvm install 2.2" \
    && /bin/bash -l -c "rvm install 2.3" \
    && /bin/bash -l -c "rvm install 2.4" \

WORKDIR /usr/src/app
