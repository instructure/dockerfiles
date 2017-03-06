FROM openjdk:8-jre-alpine

RUN apk add --no-cache curl
RUN curl -sSLO https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.13.2.jar

CMD [ "/usr/bin/java", "-Dnode-address.host=*", "-jar", "elasticmq-server-0.13.2.jar" ]
EXPOSE 9324
