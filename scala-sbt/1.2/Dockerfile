# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:scala-sbt`

FROM instructure/java:8-xenial
MAINTAINER Instructure Shared Services Org - Analytics Team
USER root

RUN echo 'deb https://dl.bintray.com/sbt/debian /' > /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
      --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

ARG SBT_VERSION=1.2.7
RUN apt-get update && \
    apt-get install -y --no-install-recommends bc sbt=$SBT_VERSION && \
    apt-get clean autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.sbt /root/.ivy2

COPY sbt-private /usr/local/bin
RUN chmod 755 /usr/local/bin/sbt-private && \
    mkdir -p /usr/src/app && \
    chown docker:docker /usr/src/app
WORKDIR /usr/src/app
USER docker
