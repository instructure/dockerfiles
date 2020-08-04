# Introduction

Your one-stop-shop for Instructure official Docker/python love. If you need python, pip and pipenv
in Docker but don't need web services you're in the right place. Drop your
app in (we suggest /usr/src/app) and start hacking.

## GPG Signatures

We check the signatures on the binaries we download by using a static public file:
https://www.python.org/static/files/pubkeys.txt

## Private PYPI Repository

All pypi libraries include a convenient wrapper for installing via PIP packages from
a private repository. Credentials should **only** be specified using docker
image build arguments, not environment variables. In order to build an image
that uses private packages, add build arguments to your Dockerfile like so:

```Dockerfile
ARG PYPI_PRIVATE_SCOPE
ARG PYPI_PRIVATE_REGISTRY
ARG PYPI_PRIVATE_USERNAME
ARG PYPI_PRIVATE_PASSWORD
ARG PYPI_PRIVATE_EMAIL

COPY Pipfile Pipfile.lock /usr/src/app/
RUN pipenv-private install
```

The `pip-private` script is a wrapper around `pip`, and supports any commands or
arguments you would use with `pip`. This script will temporarily configure your
credentials with PYPI, run the command, and promptly remove the credentials,
ensuring they are not saved in the final docker image.

You should always pass in your credentials with `docker build` like so:

```sh
docker build \
  --build-arg PYPI_PRIVATE_SCOPE="scope" \
  --build-arg PYPI_PRIVATE_REGISTRY="//https://pypi.org//" \
  --build-arg PYPI_PRIVATE_USERNAME="bpetty" \
  --build-arg PYPI_PRIVATE_PASSWORD="my-secret-token" \
  --build-arg PYPI_PRIVATE_EMAIL="bpetty@instructure.com"
```

Or, in development, you will likely want to pass them in through a local Docker
Compose override that pulls them from environment itself:

```yml
  web:
    build:
      args:
        PYPI_PRIVATE_SCOPE: "${PYPI_PRIVATE_SCOPE}"
        PYPI_PRIVATE_REGISTRY: "${PYPI_PRIVATE_REGISTRY}"
        PYPI_PRIVATE_USERNAME: "${PYPI_PRIVATE_USERNAME}"
        PYPI_PRIVATE_PASSWORD: "${PYPI_PRIVATE_PASSWORD}"
        PYPI_PRIVATE_EMAIL: "${PYPI_PRIVATE_EMAIL}"
```

You may also wish to secure those values locally using vaulted:
* https://github.com/miquella/vaulted/
