# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:ruby-node-pg`

FROM instructure/ruby-passenger:2.3
MAINTAINER Instructure

USER root

# install node, postgres client
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' \
    && curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install -yqq postgresql-client-9.5 nodejs \
    && rm -rf /var/lib/apt/lists/*

COPY main.d/* /usr/src/nginx/main.d/
