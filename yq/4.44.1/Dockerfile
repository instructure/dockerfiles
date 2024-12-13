FROM --platform=${TARGETPLATFORM} alpine:3.20
LABEL maintainer="Instructure"

ENV YQ_VERSION="4.44.1"

RUN apk update && \
    apk add --no-cache "yq~${YQ_VERSION}"

ENTRYPOINT ["yq"]
