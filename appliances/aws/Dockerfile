FROM alpine:3.9

RUN apk --verbose --upgrade --no-cache add \
      python \
      py-pip \
      groff \
      less \
      mailcap \
 && pip install --upgrade \
      awscli==1.16.145 s3cmd==2.0.2 python-magic \
 && apk --purge del py-pip

VOLUME /root/.aws

VOLUME /project
WORKDIR /project

