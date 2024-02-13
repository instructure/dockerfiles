FROM --platform=$BUILDPLATFORM public.ecr.aws/docker/library/alpine:3 AS helm-builder
WORKDIR /tmp/helm
ARG TARGETOS
ARG TARGETARCH
RUN wget https://get.helm.sh/helm-v3.14.0-$TARGETOS-$TARGETARCH.tar.gz -O helm.tar.gz \
  && tar xvzf helm.tar.gz \
  && mv $TARGETOS-$TARGETARCH/helm /helm \
  && rm helm.tar.gz


FROM --platform=$BUILDPLATFORM public.ecr.aws/docker/library/alpine:3 as kustomize-builder
WORKDIR /tmp/kustomize
ARG TARGETOS
ARG TARGETARCH
RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.3.0/kustomize_v5.3.0_${TARGETOS}_${TARGETARCH}.tar.gz -O kustomize.tar.gz \
  && tar xvzf kustomize.tar.gz \
  && mv kustomize /kustomize \
  && rm kustomize.tar.gz


# Currently only published under amd64, so we compile ourselves :/
FROM --platform=$BUILDPLATFORM public.ecr.aws/docker/library/golang:1.21 AS kube-linter-builder
WORKDIR /src
RUN git clone https://github.com/stackrox/kube-linter.git --branch v0.6.7 --depth 1 . \
  && go mod download
ARG TARGETARCH
ARG TARGETOS
RUN GOARCH=$TARGETARCH GOOS=$TARGETOS CGO_ENABLED=0 scripts/go-build.sh ./cmd/kube-linter \
  && mv bin/$TARGETOS/kube-linter /kube-linter


FROM --platform=$TARGETPLATFORM public.ecr.aws/docker/library/alpine:3

RUN adduser -u9999 -g9999 -D -g "Docker User" docker \
  && apk --no-cache add \
    bash \
    yamllint

COPY bin/* /usr/bin/
COPY --from=kustomize-builder /kustomize /usr/bin/kustomize
COPY --from=helm-builder /helm /usr/bin/helm
COPY --from=kube-linter-builder /kube-linter /usr/bin/kube-linter

WORKDIR /mnt

USER docker
