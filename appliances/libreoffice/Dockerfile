FROM ubuntu:15.10

ENV DEBIAN_FRONTEND noninteractive

## Create a 'docker' user
RUN  addgroup --gid 9999 docker \
  && adduser --uid 9999 --gid 9999 --disabled-password --gecos "Docker User" docker \
  && usermod -L docker

RUN apt-get clean           \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get update          \
 && apt-get install -y      \
    ghostscript             \
    libreoffice-writer      \
    ure                     \
    libreoffice-java-common \
    libreoffice-core        \
    libreoffice-common      \
    fonts-opensymbol        \
    hyphen-fr               \
    hyphen-de               \
    hyphen-en-us            \
    hyphen-it               \
    hyphen-ru               \
    fonts-dejavu            \
    fonts-dejavu-core       \
    fonts-dejavu-extra      \
    fonts-droid             \
    fonts-dustin            \
    fonts-f500              \
    fonts-fanwood           \
    fonts-freefont-ttf      \
    fonts-liberation        \
    fonts-lmodern           \
    fonts-lyx               \
    fonts-sil-gentium       \
    fonts-texgyre           \
    fonts-tlwg-purisa       \
    --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER docker
