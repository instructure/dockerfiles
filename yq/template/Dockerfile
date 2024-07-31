<%= from_image(base_image) %>
LABEL maintainer="Instructure"

ENV YQ_VERSION="<%= version %>"

RUN apk update && \
    apk add --no-cache "yq~${YQ_VERSION}"

ENTRYPOINT ["yq"]
