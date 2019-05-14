# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:clojure`

FROM instructure/java:11

USER root

#
# Clojure
#
ENV LEIN_VERSION 2.8.1
ENV LEIN_INSTALL /usr/local/bin/

WORKDIR /tmp

# Download the whole repo as an archive
RUN mkdir -p $LEIN_INSTALL \
  && curl -OLs https://github.com/technomancy/leiningen/archive/$LEIN_VERSION.tar.gz \
  && echo "Comparing archive checksum ..." \
  && echo "3e95453428632d198f8772a5cf8e971c4814e811 *$LEIN_VERSION.tar.gz" | sha1sum -c - \
\
  && mkdir ./leiningen \
  && tar -xzf $LEIN_VERSION.tar.gz  -C ./leiningen/ --strip-components=1 \
  && mv leiningen/bin/lein-pkg $LEIN_INSTALL/lein \
  && rm -rf $LEIN_VERSION.tar.gz ./leiningen \
\
  && chmod 0755 $LEIN_INSTALL/lein \
\
  # Download and verify Lein stand-alone jar
  && curl -OLs https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip \
  && curl -OLs https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip.asc \
\
  && (gpg --keyserver pool.sks-keyservers.net --recv-key 2B72BF956E23DE5E830D50F6002AF007D1A7CC18 \
  || gpg --keyserver keyserver.ubuntu.com --recv-key 2B72BF956E23DE5E830D50F6002AF007D1A7CC18) \
  && echo "Verifying Jar file signature ..." \
  && gpg --verify leiningen-$LEIN_VERSION-standalone.zip.asc \
\
  # Put the jar where lein script expects
  && rm leiningen-$LEIN_VERSION-standalone.zip.asc \
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar \
\
  && apt-get update \
\
  # Some REPLs (e.g., Figwheel) necessitate a readline wrapper.
  && apt-get install -y rlfe && rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1

USER docker
