FROM --platform=${TARGETPLATFORM} openjdk:11-jre

#RUN apk add --no-cache curl
RUN curl -sSLO https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-1.5.7.jar

EXPOSE 9324

ADD /elasticmq.conf /elasticmq/elasticmq.conf

CMD [ "/usr/local/openjdk-11/bin/java", "-Djava.net.preferIPv4Stack=true", "-Dconfig.file=/elasticmq/elasticmq.conf", "-jar", "elasticmq-server-1.5.7.jar" ]
