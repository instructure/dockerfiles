# Introduction

Dockerfile for building Instructure's Android apps with
Jenkins and Google's [Cloud Test Lab](https://developers.google.com/cloud-test-lab/).

# Configure

Note that you will have to modify the following to work with your projects.

File | Description
---:|:---
`config`         | must be replaced with your own ssh config
`known_hosts`    | must be replaced with your own known_hosts
`build_image.sh` | must be modified unless you're using repo + gradle with debug builds

ENV | Description
---:|:---
`ANDROID_PROJECT_NAME` | Android project name
`REPO_INIT`   | SSH URL to the git repo containing the repo xml file
`IDRSA`       | SSH key to connect to Jenkins
`GCLOUDKEY`   | JSON key to connect to Google cloud
`GCLOUDUSER`  | Google cloud user account
`EXECUTOR_ID` | Suffix to use on the jenkins build node (typically a number)


## Build

```
docker build \
 --build-arg IDRSA="$DOCKER_HUDSON_IDRSA" \
 --build-arg REPO_INIT="$REPO_INIT" \
 --build-arg ANDROID_PROJECT_NAME="$ANDROID_PROJECT_NAME" \
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
