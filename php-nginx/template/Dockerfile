<%= generation_message %>
<% flavor = version.end_with?('slim') ? 'slim' : 'fat' -%>
FROM instructure/php:<%= version %>
LABEL maintainer=Instructure

ENV DD_AGENT_MAJOR_VERSION=7
ENV DD_TRACE_AGENT_VERSION=0.41.1
ARG DD_TRACER_AGENT_URL=https://github.com/DataDog/dd-trace-php/releases/download/${DD_TRACE_AGENT_VERSION}/datadog-php-tracer_${DD_TRACE_AGENT_VERSION}_amd64.deb

USER root

RUN /bin/bash -c 'source /etc/lsb-release \
 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/nginx.list \
 && echo "deb-src http://ppa.launchpad.net/nginx/stable/ubuntu $DISTRIB_CODENAME main" >> /etc/apt/sources.list.d/nginx.list' \
 && curl "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xb96f2300ad11cbee" | apt-key add - \
 && curl "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x00a6f0a3c300ee8c" | apt-key add - \
 && echo "deb https://apt.datadoghq.com/ stable $DD_AGENT_MAJOR_VERSION" > /etc/apt/sources.list.d/datadog.list \
 && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A2923DFF56EDA6E76E55E492D3A80E30382E94DE \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
        php${PHP_VERSION}-cgi \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-curl \
        nginx \
        python3-pip \
        python3-yaml \
        datadog-agent \
 && pip3 install supervisor setuptools \
 && apt-get purge --yes --autoremove python3-pip \
 # delete default php-fpm pool
 && rm -f /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
 && chown -R docker:docker /opt/datadog-agent /etc/datadog-agent /var/log/datadog \
 && rm /lib/systemd/system/datadog-agent*service

RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm \
 && mkdir -p /usr/src/nginx/conf.d /usr/src/nginx/location.d \
 && mkdir -p /usr/src/nginx/main.d /usr/src/nginx/server.d \
 && mkdir -p /usr/src/php/fpm /usr/src/php/conf.d /var/log/php \
 && mkdir -p /usr/src/supervisor \
 && mkdir -p /var/lib/nginx/body /var/lib/fastcgi \
 && chown -R docker:docker /usr/src/nginx /usr/src/php /usr/src/supervisor /var/run/php /var/log/nginx /var/lib/nginx \
 && mkdir -p /usr/src/app

# install datadog php tracer
RUN cd /tmp && curl -L ${DD_TRACER_AGENT_URL} > datadog-php-tracer_amd64.deb \
 && dpkg -i datadog-php-tracer_amd64.deb \
 && rm datadog-php-tracer_amd64.deb

COPY --chown=docker:docker entrypoint.d/ /entrypoint.d/
COPY --chown=docker:docker supervisor/ /usr/src/supervisor/

USER docker

# for some reason this prevents ddtrace from installing correctly if ran before the ddtrace installation
ENV PHP_INI_SCAN_DIR=:/usr/src/php/conf.d

CMD ["supervisord", "--configuration", "/usr/src/supervisor/supervisord.conf"]
