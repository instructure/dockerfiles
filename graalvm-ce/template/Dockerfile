<%= generation_message %>
FROM instructure/core:<%= distro %>

USER root

ENV GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-<%= graal_version %>/graalvm-ce-java<%= java_version %>-linux-amd64-<%= graal_version %>.tar.gz \
    GRAALVM_PKG_SHA256=<%= package_sha %> \
    JAVA_HOME=/opt/graalvm-ce-java<%= java_version %>-<%= graal_version %>

COPY gu-wrapper.sh /usr/local/bin/gu

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

RUN curl -fsSL --retry 3 -o graal.tar.gz $GRAALVM_PKG \
    && echo "$GRAALVM_PKG_SHA256 graal.tar.gz" | sha256sum -c - \
    && tar -C /opt/ -xzf graal.tar.gz \
    && rm graal.tar.gz \
    && chown -R docker:docker $JAVA_HOME \
    && ln -sf /tmp /var/tmp \
    && gu link

RUN echo 'docker ALL=(ALL) NOPASSWD: SETENV: /usr/bin/update-alternatives' >> /etc/sudoers
USER docker
