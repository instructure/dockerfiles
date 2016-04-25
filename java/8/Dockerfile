FROM instructure/core

ENV JAVA_VERSION=8

USER root

RUN echo oracle-java$JAVA_VERSION-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y --force-yes oracle-java$JAVA_VERSION-installer
USER docker
