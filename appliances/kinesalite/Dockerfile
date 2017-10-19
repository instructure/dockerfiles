FROM instructure/node:6
MAINTAINER Instructure

ENV DATADIR /var/lib/kinesalite

USER root
RUN npm install kinesalite --global
RUN mkdir $DATADIR && chown docker:docker $DATADIR
USER docker

EXPOSE 4567
VOLUME $DATADIR

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh", "--path", "/var/lib/kinesalite"]
