# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:java`

ARG ROOT_PATH=instructure
FROM ${ROOT_PATH}/core:focal

MAINTAINER Instructure

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-16-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/oracle*

USER docker
