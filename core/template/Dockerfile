<%= from_image('tini:v0.19.0') %> AS tini
<%= from_image(base_image) %>
MAINTAINER Instructure
<% gnupg2 = ['bionic', 'bionic-slim', 'focal'].include?(version) -%>

ENV DEBIAN_FRONTEND=noninteractive
## Create a 'docker' user
RUN addgroup --gid 9999 docker \
 && adduser --uid 9999 --gid 9999 --disabled-password --gecos "Docker User" docker \
 && usermod -L docker \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        language-pack-en \
        locales \
<%= gnupg2 ? "        gnupg \\\n" : "" -%>
<% if flavor == 'fat' -%>
 && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        psmisc \
        python \
        software-properties-common \
        tzdata \
<% if gnupg2 -%>
 # gnupg2 and dirmngr will attempt to use IPv6 if it's enabled in Docker, even
 # if the container doesn't have an IPv6 address (this is true on Docker Hub).
 && mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
<% end -%>
<% end -%>
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

## Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

# Install Tini for init use (reaps defunct processes and forwards signals)
COPY --from=tini /tini /tini

# Switch to the 'docker' user
USER docker
