# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:graalvm-ce`

FROM instructure/core:focal

USER root

ENV GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.0.0.2/graalvm-ce-java17-linux-amd64-22.0.0.2.tar.gz \
    GRAALVM_PKG_SHA256=4f743e0ed3d974b7d619ca2ed6014554e8c12e5ebbb38b9bc9e820b182169bd4 \
    JAVA_HOME=/opt/graalvm-ce-java17-22.0.0.2

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
