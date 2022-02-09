FROM alpine

RUN  apk update \
  && apk upgrade \
  && apk add --update --no-cache openjdk11 curl \
  && rm -rf /var/cache/apk/*

RUN curl -sSLO https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.14.7.jar

EXPOSE 9324

ADD /elasticmq.conf /elasticmq/elasticmq.conf

CMD [ "java", "-Djava.net.preferIPv4Stack=true", "-Dconfig.file=/elasticmq/elasticmq.conf", "-jar", "elasticmq-server-0.14.7.jar" ]