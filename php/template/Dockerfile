<%= generation_message -%>
FROM <%= base_image %>
LABEL maintainer=Instructure

ENV PHP_VERSION=<%= version.sub(/-.+\z/, '') %>

USER root
COPY entrypoint.sh /entrypoint.sh

RUN /bin/bash -c 'source /etc/lsb-release \
 && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/php.list \
 && echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu $DISTRIB_CODENAME main" >> /etc/apt/sources.list.d/php.list' \
 && curl "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x4f4ea0aae5267a6c" | apt-key add - \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
        php${PHP_VERSION} \
        php${PHP_VERSION}-cli \
<% if version != '7.3-focal' -%>
        python3-jinja2 \
<% end -%>
 # clean up apt's mess
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Update some defaults to be a bit more sane
RUN ln -s /etc/php/${PHP_VERSION} /etc/php/current \
<% if version != '7.3-focal' -%>
 && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
<% end -%>
 && mkdir -p /usr/src/app /var/run/php /entrypoint.d/ \
 && chown docker:docker /usr/src/app \
 && chown docker:docker /var/run/php \
 && chown -R docker:docker /entrypoint.d

WORKDIR /usr/src/app

USER docker

ENTRYPOINT ["/entrypoint.sh"]
