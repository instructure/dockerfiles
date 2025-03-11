<%= generation_message %>
<%= from_image(base_image) %>
MAINTAINER Instructure

USER root

# Based on https://github.com/libvips/libvips/wiki/Build-for-Ubuntu

RUN \
  # Install build tools
  apt-get update && \
  apt-get install -y \
    build-essential \
    pkg-config \
    ninja-build \
    python3-pip \
    bc \
    wget && \
  pip3 install meson && \

  # Install dependencies
  apt-get install -y \
    libfftw3-dev \
    libopenexr-dev \
    libgsf-1-dev \
    libglib2.0-dev \
    liborc-dev \
    libopenslide-dev \
    libmatio-dev \
    libwebp-dev \
    libjpeg-turbo8-dev \
    libexpat1-dev \
    libexif-dev \
    libtiff5-dev \
    libcfitsio-dev \
    libpoppler-glib-dev \
    librsvg2-dev \
    libpango1.0-dev \
    libopenjp2-7-dev \
    liblcms2-dev \
    libimagequant-dev \
    libheif-dev

# Build libvips
WORKDIR /tmp
RUN \
  curl -L -O https://github.com/libvips/libvips/releases/download/v<%= libvips_version %>/vips-<%= libvips_version %>.tar.xz && \
  tar vxJf vips-<%= libvips_version %>.tar.xz && \
  cd vips-<%= libvips_version %> && \
  meson setup build --libdir=lib --buildtype=release --reconfigure -Dheif=enabled -Dheif-module=enabled && \
  cd build && \
  meson compile && \
  meson test && \
  meson install && \

  # Clean up
  # having yarn install sharp requires at least one of these
  #apt-get remove -y curl automake build-essential && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER docker

