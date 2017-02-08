<%= generation_message %>
FROM instructure/ruby-passenger:<%= ruby_version %>
MAINTAINER Instructure

USER root
ENV APP_HOME /usr/src/app/

# install node, postgres client
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' \
    && curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && curl -sL https://deb.nodesource.com/setup_<%= node_version %> | bash - \
    && apt-get install -yqq postgresql-client-9.5 nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && gem update --system \
    && mkdir -p ${APP_HOME}node_modules \
    && mkdir -p ${APP_HOME}tmp \
    && mkdir -p ${APP_HOME}log \
    && mkdir -p ${APP_HOME}public/assets \
    && chown -R docker:docker ${APP_HOME} /home/docker
