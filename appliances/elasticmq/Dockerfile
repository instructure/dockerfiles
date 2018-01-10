FROM openjdk:8-jre-alpine

RUN apk add --no-cache curl
RUN curl -sSLO https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.13.8.jar

EXPOSE 9324

ADD /elasticmq.conf /elasticmq/elasticmq.conf

CMD [ "/usr/bin/java", "-Djava.net.preferIPv4Stack=true", "-Dconfig.file=/elasticmq/elasticmq.conf", "-jar", "elasticmq-server-0.13.8.jar" ]
