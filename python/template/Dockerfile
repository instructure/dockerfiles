<%= generation_message %>
FROM <%= base_image %>
MAINTAINER Instructure Engineering
USER root

ARG PYTHON_VERSION=<%= python_version %>
ARG PYTHON_MAJOR_MINOR_VERSION=<%= python_build_version %>
ARG PIP_VERSION=<%= pip_version %>

RUN apt-get update && apt-get install -y zlib1g-dev libncurses5-dev libffi-dev libsqlite3-dev\
                                         libgdbm-dev libnss3-dev libssl-dev libreadline-dev

RUN cd /tmp && \
      curl -fsSLO https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz && \
      curl -fsSLO https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz.asc && \
      curl -fsSLO https://www.python.org/static/files/pubkeys.txt && \
      gpg --import pubkeys.txt && \
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
