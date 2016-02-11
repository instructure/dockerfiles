FROM instructure/java:7

WORKDIR /home/docker
ENV DATADIR /var/lib/dynamo

USER root
RUN mkdir $DATADIR && chown docker:docker $DATADIR
USER docker

RUN /usr/bin/curl -L http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest | /bin/tar xz

EXPOSE 8000
VOLUME $DATADIR

COPY entrypoint.sh /home/docker/entrypoint.sh

ENTRYPOINT ["/home/docker/entryppoint.sh", "-dbPath /opt/dynamo/"]
