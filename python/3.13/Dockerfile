# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:python`

FROM instructure/core:jammy
MAINTAINER Instructure Engineering
USER root

ARG PYTHON_VERSION=3.13.2
ARG PYTHON_MAJOR_MINOR_VERSION=3.13
ARG PIP_VERSION=25.2
ARG PGP_KEY_ID=A821E680E5FA6305

RUN apt-get update && apt-get install -y zlib1g-dev libncurses5-dev libffi-dev libsqlite3-dev\
                                         libgdbm-dev libnss3-dev libssl-dev libreadline-dev\
                                         xz-utils build-essential

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
