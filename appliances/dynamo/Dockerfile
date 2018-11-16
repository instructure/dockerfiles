FROM instructure/java:11-jre

WORKDIR /home/docker
ENV DATADIR /var/lib/dynamo

USER root
RUN mkdir $DATADIR && chown docker:docker $DATADIR
USER docker

RUN /usr/bin/curl -L http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz | /bin/tar xz

EXPOSE 8000
VOLUME $DATADIR

COPY entrypoint.sh /home/docker/entrypoint.sh

# Configure a sane default Java heap size (that can be overridden).
ENV JAVA_OPTS "-Xmx256m"

ENTRYPOINT ["/home/docker/entrypoint.sh", "-dbPath /var/lib/dynamo"]
