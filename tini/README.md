# Tini

This is an image to pull down and verify the `tini` binary before
consuming it in a multi-stage build.

## Consuming

The intended use is to consume this as a external multi-stage dependency
without introducing any artifacts.

For example:

```Dockerfile
FROM instructure/tini:<TINI_VERSION> as tini

FROM ...

COPY --from=tini /tini /usr/local/bin/tini
...

```
