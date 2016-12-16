FROM instructure/java:8
MAINTAINER Instructure Shared Services Org - Analytics team
USER root

RUN echo 'deb https://dl.bintray.com/sbt/debian /' > /etc/apt/sources.list.d/sbt.list &&\
    apt-get update && \
    apt-get install -y --force-yes sbt=0.13.13 && \
    apt-get clean autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app
WORKDIR /usr/src/app

COPY sbt-private /usr/local/bin
USER docker
RUN sbt