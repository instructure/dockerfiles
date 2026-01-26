# Introduction

Your one-stop-shop for Instructure official Docker/Node love. If you need node
in Docker but don't need web services (we will have
`instructure/node-passenger` for that) you're in the right place. Drop your
app in (we suggest /usr/src/app) and start hacking.

## GPG Signatures

We check the signatures on the binaries we download.  The list of signatures is here:

https://github.com/nodejs/node#release-team

## Slim Images

Node images from 14 on are built on a "slim" base image, which means that NPM
packages that use native extensions will need to install more apt packages,
such as `node-gyp`. If your app doesn't need any native extensions, you are
ready to rock!

## Yarn Installation

Yarn is included in all Node images and is installed via `npm install -g yarn`.

This approach avoids dependency on external apt repositories and GPG signing keys
that can expire, and is more reliable than Corepack which depends on `repo.yarnpkg.com`.

## Private NPM Repository

All Node images include a convenient wrapper for installing NPM packages from
a private repository. Credentials should **only** be specified using docker
image build arguments, not environment variables. In order to build an image
that uses private packages, add build arguments to your Dockerfile like so:

```Dockerfile
ARG NPM_PRIVATE_SCOPE
ARG NPM_PRIVATE_REGISTRY
ARG NPM_PRIVATE_USERNAME
ARG NPM_PRIVATE_PASSWORD
ARG NPM_PRIVATE_EMAIL

COPY package.json .
RUN npm-private install
```

The `npm-private` script is a wrapper around `npm`, and supports any commands or
arguments you would use with `npm`. This script will temporarily configure your
credentials with NPM, run the command, and promptly remove the credentials,
ensuring they are not saved in the final docker image.

You should always pass in your credentials with `docker build` like so:

```sh
docker build \
  --build-arg NPM_PRIVATE_SCOPE="scope" \
  --build-arg NPM_PRIVATE_REGISTRY="//registry.npmjs.org/" \
  --build-arg NPM_PRIVATE_USERNAME="bpetty" \
  --build-arg NPM_PRIVATE_PASSWORD="my-secret-token" \
  --build-arg NPM_PRIVATE_EMAIL="bpetty@instructure.com"
```

Or, in development, you will likely want to pass them in through a local Docker
Compose override that pulls them from environment itself:

```yml
  web:
    build:
      args:
        NPM_PRIVATE_SCOPE: "${NPM_PRIVATE_SCOPE}"
        NPM_PRIVATE_REGISTRY: "${NPM_PRIVATE_REGISTRY}"
        NPM_PRIVATE_USERNAME: "${NPM_PRIVATE_USERNAME}"
        NPM_PRIVATE_PASSWORD: "${NPM_PRIVATE_PASSWORD}"
        NPM_PRIVATE_EMAIL: "${NPM_PRIVATE_EMAIL}"
```

You may also wish to secure those values locally using vaulted:
* https://github.com/miquella/vaulted/
