# Introduction

Dockerfile for building Instructure's Android apps with
Jenkins and Google's [Cloud Test Lab](https://developers.google.com/cloud-test-lab/).

## Build

```
docker build \
 --build-arg IDRSA="$DOCKER_HUDSON_IDRSA" \
 android/
```

## Run

Run with entrypoint script.

```
docker run -e IDRSA="$DOCKER_HUDSON_IDRSA" \
 -e GCLOUDKEY="$GCLOUDKEY" \
 -e GCLOUDUSER="$GCLOUDUSER" \
 -e EXECUTOR_ID="$EXECUTOR_ID" \
 -t 87669bda639e
```

For a bash shell run:

```
docker run -e IDRSA="$DOCKER_HUDSON_IDRSA" \
 -e GCLOUDKEY="$GCLOUDKEY" \
 -e GCLOUDUSER="$GCLOUDUSER" \
 -e EXECUTOR_ID="$EXECUTOR_ID" \
 -ti 87669bda639e /bin/bash
```

## Overview

- Builds on `instructure/core`.
- Installs Android SDK, Google Cloud SDK.
- Gradle is installed from the gradle wrapper.
- The android app is built once to ensure we've downloaded all the dependencies (via [sdk-manager-plugin](https://github.com/JakeWharton/sdk-manager-plugin))
- The SSH key is added via a build arg and then removed in `build_image.sh`
- [tini](https://github.com/krallin/tini) is used to start the entry script.
- supervisor is used to keep the jenkins cli jar running (as is done in the [cloudbees jenkins docker repo](https://github.com/harniman/jenkins-enterprise))
- Jenkins CLI stdout is [redirected to supervisor stdout](http://stackoverflow.com/a/26897648) in supervisord.conf
- Credentials are passed to the container via environment variables.
