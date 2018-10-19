# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:java`

FROM instructure/core:bionic

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-11-jre && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/oracle*

USER docker
