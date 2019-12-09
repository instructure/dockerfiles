# Graalvm-ce

These are base docker images for building graalvm applications. See https://www.graalvm.org/docs/getting-started/ for more information on what graalvm can do.

The resulting image is rather large due to graalvms included binaries
- JVM
- JavaScript Engine & Node.js Runtime
- LLVM Engine
- Developer Tools

# Installing other languages
One of the main benefits of graalvm is it's ability for language interoperability. An example `Dockerfile` adding `truffleruby` may look like

```
FROM instructure/graalvm-ce:19.3.0-java11 as build
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends zlib1g-dev libxml2-dev libssl-dev build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/
USER docker
RUN gu install ruby \
    && $JAVA_HOME/languages/ruby/lib/truffle/post_install_hook.sh

FROM instructure/graalvm-ce:19.3.0-java11
COPY --from=build --chown=docker:docker $JAVA_HOME/ $JAVA_HOME/
USER docker
RUN gu link
```
