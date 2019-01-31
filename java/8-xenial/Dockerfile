# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:java`

FROM instructure/core:xenial

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/oracle*

USER docker
