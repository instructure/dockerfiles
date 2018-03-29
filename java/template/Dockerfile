<%= generation_message %>
FROM instructure/core

USER root
<% case flavor
when 'jdk' %>
ENV JAVA_VERSION=<%= version %>

RUN echo oracle-java$JAVA_VERSION-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y --no-install-recommends --force-yes oracle-java${JAVA_VERSION}-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/oracle* && \
    rm -rf /usr/lib/jvm/java-${JAVA_VERSION}-oracle/src.zip
<% when 'jre' %>
ENV JAVA_HOME /usr/jdk1.<%= java_version %>.0_<%= update %>

RUN curl --junk-session-cookies \
         --location \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/<%= java_version %>u<%= update %>-b<%= build %>/<%= checksum %>/server-jre-<%= java_version %>u<%= update %>-linux-x64.tar.gz" | \
    tar -xz -C /usr/ && \
    rm -rf $JAVA_HOME/man

ENV PATH $PATH:$JAVA_HOME/bin

<% end %>
USER docker
