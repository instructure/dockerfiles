<%= generation_message %>
<%= from_image(base_image) %>

MAINTAINER Instructure

USER root
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
<% if base_image == 'core:resolute' -%>
RUN wget -O- https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" > /etc/apt/sources.list.d/corretto.list
<% else -%>
RUN wget -O- https://apt.corretto.aws/corretto.key | apt-key add - && \
    add-apt-repository 'deb https://apt.corretto.aws stable main'
<% end -%>
ADD https://apt.corretto.aws/dists/stable/InRelease /tmp/corretto-InRelease
RUN apt-get update && \
    apt-get install -y --no-install-recommends java-<%= java_version %>-amazon-corretto-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER docker
