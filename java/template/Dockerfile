<%= generation_message %>
FROM instructure/core

ENV JAVA_VERSION=<%= version %>

USER root

RUN echo oracle-java$JAVA_VERSION-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y --no-install-recommends --force-yes oracle-java${JAVA_VERSION}-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/oracle* && \
    rm -rf /usr/lib/jvm/java-${JAVA_VERSION}-oracle/src.zip

USER docker
