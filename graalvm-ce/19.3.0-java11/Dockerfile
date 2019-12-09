# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:graalvm-ce`

FROM instructure/core:bionic

USER root

ENV GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0/graalvm-ce-java11-linux-amd64-19.3.0.tar.gz \
    GRAALVM_PKG_SHA256=238c5c21bb4aa292caf95b2aca592ce8c1be2f036d93af48cd865f67d558f907 \
    JAVA_HOME=/opt/graalvm-ce-java11-19.3.0

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
