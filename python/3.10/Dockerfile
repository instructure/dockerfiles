# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:python`

FROM instructure/core:bionic
MAINTAINER Instructure Engineering
USER root

ARG PYTHON_VERSION=3.10.4
ARG PYTHON_MAJOR_MINOR_VERSION=3.10
ARG PIP_VERSION=20.1
ARG PGP_KEY_ID=A035C8C19219BA821ECEA86B64E628F8D684696D

RUN apt-get update && apt-get install -y zlib1g-dev libncurses5-dev libffi-dev libsqlite3-dev\
                                         libgdbm-dev libnss3-dev libssl-dev libreadline-dev

RUN cd /tmp && \
      curl -fsSLO https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz && \
      curl -fsSLO https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz.asc && \
      gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${PGP_KEY_ID} || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys ${PGP_KEY_ID} && \
      gpg --verify Python-${PYTHON_VERSION}.tar.xz.asc Python-${PYTHON_VERSION}.tar.xz && \
      tar -xf Python-${PYTHON_VERSION}.tar.xz && \
      rm Python-${PYTHON_VERSION}.tar.xz && \
      cd Python-${PYTHON_VERSION} && \
      ./configure --enable-optimizations && \
      make altinstall

RUN pip${PYTHON_MAJOR_MINOR_VERSION} install --upgrade pip==${PIP_VERSION} && pip install pipenv

WORKDIR /usr/src/app/

RUN chown docker:docker .

USER docker

RUN pipenv --python ${PYTHON_MAJOR_MINOR_VERSION}

COPY pip-private pipenv-private /usr/local/bin/
