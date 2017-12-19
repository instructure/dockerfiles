# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:java`

FROM instructure/core

USER root

ENV JAVA_HOME /usr/jre1.8.0_151

RUN curl --junk-session-cookies \
         --location \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/server-jre-8u151-linux-x64.tar.gz" | \
    tar -xz -C /usr/ && \
    ln -s $JAVA_HOME /usr/java && \
    rm -rf $JAVA_HOME/man

USER docker
