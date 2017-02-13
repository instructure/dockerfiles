# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:java`

FROM instructure/core

USER root

ENV JAVA_HOME /usr/jdk1.8.0_121

RUN curl --junk-session-cookies \
         --location \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/server-jre-8u121-linux-x64.tar.gz" | \
    tar -xz -C /usr/ && \
    ln -s $JAVA_HOME /usr/java && \
    rm -rf $JAVA_HOME/man

USER docker
