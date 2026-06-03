# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:node-passenger-sigsci`

ARG ROOT_PATH=instructure
FROM --platform=${TARGETPLATFORM} ${ROOT_PATH}/node-passenger:22
LABEL org.opencontainers.image.authors="Instructure"

ENV NGINX_STOPWAITSECS=10

USER root

RUN curl -fsSL https://apt.security.fastly.com/release/gpgkey \
  | gpg --dearmor -o /usr/share/keyrings/sigsci.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/sigsci.gpg] https://apt.security.fastly.com/release/ubuntu/ jammy main" \
  > /etc/apt/sources.list.d/sigsci.list

RUN apt-get update \
  && NGINX_VER="$(/usr/sbin/nginx -v 2>&1 | sed -E 's#.*nginx/([0-9.]+).*#\1#')" \
  && echo "Detected nginx core version: ${NGINX_VER}" \
  && apt-get install -y --no-install-recommends \
  supervisor \
  sigsci-agent \
  "nginx-module-fastly-nxd=${NGINX_VER}*" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint /usr/src/entrypoint
COPY supervisord/* /usr/src/supervisord/
COPY sigsci-agent-wrapper /usr/local/bin/sigsci-agent-wrapper
COPY main.d/* /usr/src/nginx/main.d/
COPY conf.d/* /usr/src/nginx/conf.d/

RUN mkdir -p /usr/src/supervisord/conf.d \
  && chown docker:docker -R /usr/src/nginx /usr/src/supervisord \
  && chgrp docker /var/run \
  && chmod g+w /var/run

USER docker

EXPOSE 80
ENTRYPOINT ["/tini", "--"]
CMD ["/usr/src/entrypoint"]
