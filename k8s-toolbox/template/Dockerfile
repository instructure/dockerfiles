FROM --platform=$BUILDPLATFORM alpine:3.18 AS kubectl-builder

ARG KUBECTL_VERSION=<%= kubectl_version %>
ARG TARGETARCH
ARG TARGETOS
RUN wget "https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/$TARGETOS/$TARGETARCH/kubectl" -O kubectl \
  && expected="$(wget "https://dl.k8s.io/v$KUBECTL_VERSION/bin/$TARGETOS/$TARGETARCH/kubectl.sha256" -O -)" \
  && echo "${expected}  kubectl" | sha256sum -c \
  && mv kubectl /kubectl

FROM --platform=$TARGETPLATFORM <%= base_image %>

RUN apk --no-cache add \
    aws-cli \
    bash \
    bind-tools \
    coreutils \
    curl \
    date \
    gawk \
    grep \
    jq \
    less \
    mandoc \
    nmap \
    nmap-ncat \
    openssh-client \
    openssl \
    sed \
    vim \
    wget \
    yq

COPY --from=kubectl-builder /kubectl /bin/kubectl

ENTRYPOINT ["/bin/bash"]
