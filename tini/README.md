# Tini

This is an image to pull down and verify the `tini` binary before
consuming it in a multi-stage build.

## Build ARGS
- TINI\_VERSION: Defaults to v0.16.1

## Consuming
The intended use is to consume this as a external multi-stage dependency
without introducing any artifacts.

For example:

```Dockerfile
ARG TINI_VERSION=v0.16.1
FROM instructure/tini:${TINI_VERSION} as tini

FROM ...

COPY --from=tini /tini /usr/local/bin/tini
...

```

