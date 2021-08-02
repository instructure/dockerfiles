<%= generation_message %>
FROM <%= base_image %>
MAINTAINER Instructure Engineering
USER root

ARG PYTHON_VERSION=<%= python_version %>
ARG PYTHON_MAJOR_MINOR_VERSION=<%= python_build_version %>
ARG PIP_VERSION=<%= pip_version %>
ARG PGP_KEY_ID=<%= python_pgp_key_id %>

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
