<%= generation_message %>
<% flavor = version.end_with?('slim') ? 'slim' : 'fat' -%>
FROM <%= base_image %> AS nginx-build

ARG NGINX_VERSION=1.18.0
ARG HTTP_SHIBBOLETH_VERSION=2.0.1
ARG HEADERS_MORE_VERSION=0.33

USER root

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
       build-essential \
       checkinstall \
       wget \
       libssl-dev \
       libpcre3-dev \
       zlib1g-dev

WORKDIR /usr/build

RUN wget -O ./nginx.tar.gz "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    && tar -xzvf ./nginx.tar.gz

RUN wget -O ./headersmore.tar.gz "https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v${HEADERS_MORE_VERSION}.tar.gz" \
    && tar -xzvf ./headersmore.tar.gz

RUN wget -O ./shibboleth.tar.gz "https://github.com/nginx-shib/nginx-http-shibboleth/archive/refs/tags/v${HTTP_SHIBBOLETH_VERSION}.tar.gz" \
    && tar -xzvf ./shibboleth.tar.gz

WORKDIR /usr/build/nginx-${NGINX_VERSION}

# Aside from the modules, the rest of the configs are the same as the prebuild ubuntu one
RUN ./configure --add-module=/usr/build/headers-more-nginx-module-${HEADERS_MORE_VERSION} \
    --add-module=/usr/build/nginx-http-shibboleth-${HTTP_SHIBBOLETH_VERSION} \
    --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-BUo7Uw/nginx-1.18.0=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid \
    --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-compat --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module \
    --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module \
    --with-http_gunzip_module --with-http_gzip_static_module --with-http_sub_module

RUN make

RUN mkdir -p /var/tmp \ 
    && echo "Nginx with shibboleth and headers-more" > description-pak \
    && checkinstall \
       --default \
       --install=no \
       --nodoc \
       --pkgname=nginx \
       --pkgversion=$VERSION \
       --type=debian \
       make install \
    && mv ./nginx_1.18.0-1_amd64.deb /usr/build/nginx.deb

# -----------------------------------------------------------------------------------------

FROM instructure/php:<%= version %>
LABEL maintainer=Instructure

ENV DD_AGENT_MAJOR_VERSION=7
ENV DD_TRACE_AGENT_VERSION=0.41.1
ARG DD_TRACER_AGENT_URL=https://github.com/DataDog/dd-trace-php/releases/download/${DD_TRACE_AGENT_VERSION}/datadog-php-tracer_${DD_TRACE_AGENT_VERSION}_amd64.deb

USER root

RUN echo "deb https://apt.datadoghq.com/ stable $DD_AGENT_MAJOR_VERSION" > /etc/apt/sources.list.d/datadog.list \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A2923DFF56EDA6E76E55E492D3A80E30382E94DE \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
       php${PHP_VERSION}-cgi \
       php${PHP_VERSION}-fpm \
       php${PHP_VERSION}-curl \
       python3-pip \
       python3-yaml \
       datadog-agent \
       libcurl4 \
       libshibsp-plugins \
       libsaml10 \
       libshibsp8 \
       libxmltooling8 \
       shibboleth-sp2-utils \
    && pip3 install supervisor setuptools \
    && apt-get purge --yes --autoremove python3-pip \
    # delete default php-fpm pool
    && rm -f /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
    && chown -R docker:docker /opt/datadog-agent /etc/datadog-agent /var/log/datadog \
    && rm /lib/systemd/system/datadog-agent*service

RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm \
    && mkdir -p /usr/src/nginx/conf.d /usr/src/nginx/location.d /usr/src/nginx/main.d \
    && mkdir -p /usr/src/php/fpm /usr/src/php/conf.d /var/log/php \
    && mkdir -p /usr/src/supervisor \
    && mkdir -p /var/log/nginx /var/lib/nginx/body /var/lib/fastcgi \
    && chown -R docker:docker /usr/src/nginx /usr/src/php /usr/src/supervisor /var/run/php /var/log/nginx /var/lib/nginx \
    && mkdir -p /usr/src/app

# install datadog php tracer
RUN cd /tmp && curl -L ${DD_TRACER_AGENT_URL} > datadog-php-tracer_amd64.deb \
    && dpkg -i datadog-php-tracer_amd64.deb \
    && rm datadog-php-tracer_amd64.deb

# install nginx from the build stage
COPY --from=nginx-build /usr/build/nginx.deb /tmp/nginx.deb
RUN dpkg -i /tmp/nginx.deb \ 
    && ln -s /usr/share/nginx/sbin/nginx /usr/sbin/nginx \ 
    && rm -rf /tmp/nginx.deb

COPY --chown=docker:docker entrypoint.d/ /entrypoint.d/
COPY --chown=docker:docker supervisor/ /usr/src/supervisor/

USER docker

# for some reason this prevents ddtrace from installing correctly if ran before the ddtrace installation
ENV PHP_INI_SCAN_DIR=:/usr/src/php/conf.d

CMD ["supervisord", "--configuration", "/usr/src/supervisor/supervisord.conf"]
