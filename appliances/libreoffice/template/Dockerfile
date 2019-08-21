<%= generation_message %>

FROM instructure/core:<%= ubuntu_version %>

USER root

RUN apt-get clean           \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update          \
  && apt-get install -y      \
  openjdk-11-jdk          \
  ghostscript             \
  libxinerama1            \
  libdbus-glib-1-2        \
  libcairo2               \
  libcups2                \
  libgl1-mesa-dri         \
  libgl1-mesa-glx         \
  libsm6                  \
  fonts-opensymbol        \
  hyphen-fr               \
  hyphen-de               \
  hyphen-en-us            \
  hyphen-it               \
  hyphen-ru               \
  fonts-dejavu            \
  fonts-dejavu-core       \
  fonts-dejavu-extra      \
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
  curl                    \
  --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /tmp/lo \
  && cd /tmp/lo \
  && curl -sSL https://downloadarchive.documentfoundation.org/libreoffice/old/<%= full_version %>/deb/x86_64/LibreOffice_<%= full_version %>_Linux_x86-64_deb.tar.gz | tar xz --strip-components=1 \
  && cd DEBS \
  && dpkg -i *.deb \
  && rm -fr /tmp/lo

# for compat with canvadocs converter, which hardcodes path to soffice
RUN ln -s /opt/libreoffice<%= version %>/program/soffice /usr/bin/soffice
ENV PATH $PATH:/opt/libreoffice<%= version %>/program

USER docker
