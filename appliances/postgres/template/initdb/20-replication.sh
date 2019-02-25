#!/bin/bash
set -e

if [ -n "$REPLICATION_USER" ]; then
  if [ $REPLICATION_ROLE = "master" ]; then
      psql -U postgres -c "CREATE ROLE $REPLICATION_USER WITH REPLICATION PASSWORD '$REPLICATION_PASSWORD' LOGIN"
      # we grant REPLICATION_USER superuser for testing to drop and create schemas easily
      # also, this is temporary, as we will be extracing most of this into a shared docker image
      psql -U postgres -c "ALTER USER $REPLICATION_USER WITH SUPERUSER"


      if [ -n "$REPLICATION_DB" ] && [ -n "$REPLICATION_SLOT_NAME" ]; then
        echo "creating logical replication slot on $REPLICATION_DB named $REPLICATION_SLOT_NAME with $REPLICATION_PLUGIN"
        echo "must restart to do so..."
        pg_ctl -D "$PGDATA" -m fast -w stop
        pg_ctl -D "$PGDATA" \
             -o "-c listen_addresses=''" \
             -w start
        psql -U postgres -c "CREATE DATABASE $REPLICATION_DB" || true
        psql -d "$REPLICATION_DB" -U postgres -c "SELECT * FROM pg_create_logical_replication_slot('$REPLICATION_SLOT_NAME', '$REPLICATION_PLUGIN');"
      fi

  elif [ $REPLICATION_ROLE = "slave" ]; then
      # stop postgres instance and reset PGDATA,
      # confs will be copied by pg_basebackup
      pg_ctl -D "$PGDATA" -m fast -w stop
      # make sure standby's data directory is empty
      rm -r "$PGDATA"/*

      pg_basebackup \
           --write-recovery-conf \
           --pgdata="$PGDATA" \
           --xlog-method=fetch \
           --username=$REPLICATION_USER \
           --host=$POSTGRES_MASTER_SERVICE_HOST \
           --port=$POSTGRES_MASTER_SERVICE_PORT \
           --progress \
           --verbose

      # useless postgres start to fullfil docker-entrypoint.sh stop
      pg_ctl -D "$PGDATA" \
           -o "-c listen_addresses=''" \
           -w start
  fi

  echo [*] $REPLICATION_ROLE instance configured!
else
  echo [*] Not configuring replication, as no user is set
fi
