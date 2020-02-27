# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:clojure`

FROM instructure/java:11

USER root

#
# Clojure
#
ENV LEIN_VERSION 2.9.1
ENV LEIN_INSTALL /usr/local/bin/

WORKDIR /tmp

# Download the whole repo as an archive
RUN \
  set -xe; \
  mkdir -p $LEIN_INSTALL \
  && curl -Ls https://github.com/technomancy/leiningen/archive/$LEIN_VERSION.tar.gz \
          --output /tmp/$LEIN_VERSION.tar.gz \
          --create-dirs \
  && echo "Comparing archive checksum ..." \
  && echo "a4c239b407576f94e2fef5bfa107f0d3f97d0b19c253b08860d9609df4ab8b29 /tmp/$LEIN_VERSION.tar.gz" | sha256sum -c - \
  && mkdir -p /tmp/leiningen \
  && tar -xzf /tmp/$LEIN_VERSION.tar.gz  -C /tmp/leiningen/ --strip-components=1 \
  && mv /tmp/leiningen/bin/lein-pkg $LEIN_INSTALL/lein \
  && chmod 0755 $LEIN_INSTALL/lein \
  # Download and verify Lein stand-alone jar
  && curl -Ls https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip \
          --output /tmp/leiningen-$LEIN_VERSION-standalone.zip \
          --create-dirs \
  && echo "Comparing archive checksum ..." \
  && echo "ea7c831a4f5c38b6fc3926c6ad32d1d4b9b91bf830a715ecff5a70a18bda55f8 /tmp/leiningen-$LEIN_VERSION-standalone.zip" | sha256sum -c - \
  # Put the jar where lein script expects
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar \
  && apt-get update \
  # Some REPLs (e.g., Figwheel) necessitate a readline wrapper.
  && apt-get install -y rlfe \
  && apt-get autoremove \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* /tmp/* \
  && find /var/log -type f -exec truncate --no-create --size=0 {} \;

ENV PATH $PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1

USER docker
