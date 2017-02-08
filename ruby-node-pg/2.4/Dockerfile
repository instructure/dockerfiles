# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:ruby-node-pg`

FROM instructure/ruby-passenger:2.4
MAINTAINER Instructure

USER root
ENV APP_HOME /usr/src/app/

# install node, postgres client
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' \
    && curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install -yqq postgresql-client-9.5 nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && gem update --system \
    && mkdir -p ${APP_HOME}node_modules \
    && mkdir -p ${APP_HOME}tmp \
    && mkdir -p ${APP_HOME}log \
    && mkdir -p ${APP_HOME}public/assets \
    && chown -R docker:docker ${APP_HOME} /home/docker
