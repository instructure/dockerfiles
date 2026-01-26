# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:node`

ARG ROOT_PATH=instructure
FROM --platform=${TARGETPLATFORM} ${ROOT_PATH}/core:jammy
LABEL maintainer="Instructure"

USER root

ENV NODE_VERSION 18
ENV NPM_VERSION 10.9.2

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get install -y curl && \
  mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ && \
  npm install -g "npm@$NPM_VERSION" && \
  rm -rf /root/.npm/_cacache && \
  npm cache clean --force

COPY npm-private /usr/local/bin


ENV YARN_VERSION latest

# Install Yarn via npm (more reliable than Corepack which depends on repo.yarnpkg.com)
RUN npm install -g yarn \
  && rm -rf /root/.npm/_cacache \
  && npm cache clean --force

COPY yarn-private /usr/local/bin

USER docker
