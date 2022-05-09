<%= generation_message %>
<%= from_image(base_image) %>

MAINTAINER Instructure

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-<%= java_version %>-<%= flavor %> && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/oracle*

USER docker
