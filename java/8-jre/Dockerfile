# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:java`

FROM instructure/core:trusty

USER root

ENV JAVA_HOME /usr/jdk1.8.0_162

RUN curl --junk-session-cookies \
         --location \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/server-jre-8u162-linux-x64.tar.gz" | \
    tar -xz -C /usr/ && \
    rm -rf $JAVA_HOME/man

ENV PATH $PATH:$JAVA_HOME/bin


USER docker
