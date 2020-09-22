FROM instructure/core:bionic-slim

VOLUME /to-sign

USER root
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
