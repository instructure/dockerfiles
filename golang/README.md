# golang

`GOPATH` is set to `/go`, and a `SRCPATH` env var is available, set to `/go/src`.

Make sure to ADD your source into a dir under `SRCPATH` named after your app, or
you'll run into problems finding dependencies. Specifically, don't use
`/usr/local/src`.

## example

```
FROM instructure/golang:1.18

RUN mkdir -p $SRCPATH/myapp
WORKDIR $SRCPATH/myapp

USER root
COPY . .
RUN chown -R docker:docker .
USER docker
RUN go install .

CMD myapp
```
