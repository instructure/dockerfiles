FROM instructure/core:latest
MAINTAINER Instructure

USER root
ENV DEBIAN_FRONTEND noninteractive
ARG IDRSA

# Install ssh client, Java, and Android SDK 32 bit deps
#
# Android deps:      libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1
# Google cloud deps: wget unzip python openssh-client python-openssl
# supervisord:       python-pip
#
# https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile
# http://stackoverflow.com/a/19623295
RUN set -x \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && add-apt-repository -y ppa:webupd8team/java \
 && apt-get update -qq \
 && apt-get install -y -qq --no-install-recommends openssh-client oracle-java8-installer \
                    libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 \
                    unzip python openssh-client python-openssl python-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# *************************** from cloud-sdk-docker ***************************
# https://developers.google.com/cloud-test-lab/command-line
# https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/Dockerfile

ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN curl -o google-cloud-sdk.zip -fsSL https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip \
 && unzip google-cloud-sdk.zip \
 && rm google-cloud-sdk.zip \
 && google-cloud-sdk/install.sh \
    --usage-reporting=false \
    --path-update=true \
    --bash-completion=true \
    --rc-path=/.bashrc \
    --additional-components beta

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json
RUN chown docker:docker -R /google-cloud-sdk
ENV PATH /google-cloud-sdk/bin:$PATH
# **************************** end cloud-sdk-docker ****************************

ENV HOME /home/docker

COPY config known_hosts "$HOME/.ssh/"
COPY build_image.sh root_build_image.sh /
RUN ./root_build_image.sh

USER docker
RUN ./build_image.sh "$IDRSA"

# Clean up build images
USER root
RUN rm /root_build_image.sh /build_image.sh

# ************************************ tini ************************************
# https://github.com/krallin/tini
ENV TINI_VERSION v0.9.0

# Verify tini signature
USER root
RUN curl -o /usr/local/bin/tini -fsSL https://github.com/krallin/tini/releases/download/"$TINI_VERSION"/tini \
 && curl -o /usr/local/bin/tini.asc -fsSL https://github.com/krallin/tini/releases/download/"$TINI_VERSION"/tini.asc \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 \
 && gpg --verify /usr/local/bin/tini.asc \
 && rm /usr/local/bin/tini.asc \
 && chmod a+x /usr/local/bin/tini
# ********************************** end tini **********************************

# cloudbees cli
RUN curl -o /usr/local/bin/jenkins-cli.jar -fsSL https://jenkins.ci.cloudbees.com/jnlpJars/jenkins-cli.jar \
 && chmod a+x /usr/local/bin/jenkins-cli.jar

# install supervisor
RUN pip install -q supervisor \
 && mkdir /var/log/supervisor/ \
 && chown docker:docker -R /var/log/supervisor/
COPY supervisord.conf "$HOME/supervisord.conf"

# Install entrypoint. Creates ssh key on docker run from ENV var
COPY entrypoint.sh /

# Run entrypoint as docker user
USER docker
CMD ["/usr/local/bin/tini", "--", "/entrypoint.sh"]
