<%= generation_message %>
FROM instructure/java:<%= java_version %>

USER root

#
# Clojure
#
ENV LEIN_VERSION <%= lein_version %>
ENV LEIN_INSTALL /usr/local/bin/

WORKDIR /tmp

# Download the whole repo as an archive
RUN mkdir -p $LEIN_INSTALL \
  && wget --quiet https://github.com/technomancy/leiningen/archive/$LEIN_VERSION.tar.gz \
  && echo "Comparing archive checksum ..." \
  && echo "<%= package_sha %> *$LEIN_VERSION.tar.gz" | sha1sum -c - \

  && mkdir ./leiningen \
  && tar -xzf $LEIN_VERSION.tar.gz  -C ./leiningen/ --strip-components=1 \
  && mv leiningen/bin/lein-pkg $LEIN_INSTALL/lein \
  && rm -rf $LEIN_VERSION.tar.gz ./leiningen \

  && chmod 0755 $LEIN_INSTALL/lein \

  # Download and verify Lein stand-alone jar
  && wget --quiet https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip \
  && wget --quiet https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip.asc \

  && (gpg --keyserver pool.sks-keyservers.net --recv-key <%= recv_key %> \
  || gpg --keyserver keyserver.ubuntu.com --recv-key <%= recv_key %>) \
  && echo "Verifying Jar file signature ..." \
  && gpg --verify leiningen-$LEIN_VERSION-standalone.zip.asc \

  # Put the jar where lein script expects
  && rm leiningen-$LEIN_VERSION-standalone.zip.asc \
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar \

  && apt-get update \

  # Install the unlimited JCE policy to allow for stronger encryption
  && apt-get install -y --no-install-recommends --force-yes oracle-java8-unlimited-jce-policy \

  # Some REPLs (e.g., Figwheel) necessitate a readline wrapper.
  && apt-get install -y rlfe && rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1

USER docker