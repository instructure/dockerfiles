# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `rake generate:appliances/postgres`

# Use a multi-stage build, first one just builds our plugins. They both use same source though
FROM postgres:10
MAINTAINER Instructure

USER root

# install build deps for both decoders, notice the weird version for libsfgcal, that is for
# running a newer version that doesn't require a ton of dependencies (like qt, mesa, x11)
RUN echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-bp.list \
    && apt-get update \
    && apt-get install -f -y --no-install-recommends \
        ca-certificates \
        curl \
        postgresql-server-dev-$PG_MAJOR \
        build-essential \
        pkg-config \
        git \
        libsfcgal1=1.3.1-2~bpo9+1 \
        libproj-dev \
        liblwgeom-dev \
        libprotobuf-c-dev

WORKDIR /

# BUILD wal2json
RUN git clone https://github.com/eulerto/wal2json.git
WORKDIR /wal2json
RUN git checkout  && \
    USE_PGXS=1 make && \
    mkdir -p /plugins/lib/ && \
    mv wal2json.so /plugins/lib/

# BUILD postgres-decoderbufs
WORKDIR /
RUN git clone https://github.com/debezium/postgres-decoderbufs.git
WORKDIR /postgres-decoderbufs
RUN git checkout v0.9.2.Final && \
    make && \
    mkdir -p /plugins/lib/ && \
    cp decoderbufs.so /plugins/lib/ && \
    mkdir -p /plugins/extension/ && \
    cp decoderbufs.control /plugins/extension

FROM postgres:10

# some of the above deps are also needed as runtime deps, notice the weird version for libsfgcal, that is for
# running a newer version that doesn't require a ton of dependencies (like qt, mesa, x11)
# we also clean up after ourselves here
RUN echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-bp.list \
    && apt-get update \
    && apt-get install -f -y --no-install-recommends \
        libsfcgal1=1.3.1-2~bpo9+1 \
        libproj-dev \
        liblwgeom-dev \
        libprotobuf-c-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy over the
COPY --from=0 --chown=postgres:postgres /plugins/lib/* /usr/lib/postgresql/$PG_MAJOR/lib/
COPY --from=0 --chown=postgres:postgres /plugins/extension/* /usr/share/postgresql/$PG_MAJOR/extension/

# common settings
ENV MAX_CONNECTIONS 500
ENV WAL_KEEP_SEGMENTS 256
ENV MAX_WAL_SENDERS 100
ENV MAX_REP_SLOTS 4

# master/slave settings
ENV REPLICATION_ROLE master
ENV REPLICATION_PASSWORD ""
ENV REPLICATION_PLUGIN decoderbufs
ENV REPLICATION_SLOT_NAME debezium

# slave settings
ENV POSTGRES_MASTER_SERVICE_HOST localhost
ENV POSTGRES_MASTER_SERVICE_PORT 5432

# copy in our scripts
COPY initdb/* /docker-entrypoint-initdb.d/

