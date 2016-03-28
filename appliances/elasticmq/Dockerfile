FROM java:8-jre-alpine
RUN wget -O elasticmq-server-0.9.0.jar https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.9.0.jar
CMD [ "/usr/bin/java", "-Dnode-address.host=*", "-jar", "elasticmq-server-0.9.0.jar" ]
EXPOSE 9324
