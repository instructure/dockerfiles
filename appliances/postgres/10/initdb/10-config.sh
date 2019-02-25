#!/bin/bash
set -e

if [ -n "$REPLICATION_USER" ]; then
  echo [*] configuring $REPLICATION_ROLE instance

  echo "max_connections = $MAX_CONNECTIONS" >> "$PGDATA/postgresql.conf"

  # We set master replication-related parameters for both slave and master,
  # so that the slave might work as a primary after failover.
  echo "wal_level = logical" >> "$PGDATA/postgresql.conf"
  echo "wal_keep_segments = $WAL_KEEP_SEGMENTS" >> "$PGDATA/postgresql.conf"
  echo "max_wal_senders = $MAX_WAL_SENDERS" >> "$PGDATA/postgresql.conf"
  echo "max_replication_slots = $MAX_REP_SLOTS" >> "$PGDATA/postgresql.conf"
  # slave settings, ignored on master
  echo "hot_standby = on" >> "$PGDATA/postgresql.conf"

  echo "host replication $REPLICATION_USER 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
  if [ -n "$REPLICATION_DB" ];
    then echo "host $REPLICATION_DB $REPLICATION_USER 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf";
  fi
else
  echo [*] Not configuring replication, as no user is set
fi
