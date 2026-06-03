# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:corretto`

ARG ROOT_PATH=instructure
FROM --platform=${TARGETPLATFORM} ${ROOT_PATH}/core:resolute

MAINTAINER Instructure

USER root
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN wget -O- https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" > /etc/apt/sources.list.d/corretto.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends java-25-amazon-corretto-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER docker
