# Introduction

This image is a simple specialization of the postgres library images that
adds a few things:

- some logical decoding plugins (decoderbufs and wal2json)
- some startup scripts for setting up replication user and logical replication slot
- the ability to create a secondary instance using physical replication

**NOTE!!** This image is in not intended for production setups. It may work with
some tweaks, but it is intended for development purposes!

## Enable Replication

To enable replication, a single environment variable `$REPLICATION_USER` must be set.

This creates a new user that is able to replicate.

**IMPORTANT** If you are using this image for real, you need to set `$REPLICATION_PASSWORD`, as by default
it creates a user with an empty password!

## Creating a logical replication slot

To automatically create a slot, the `$REPLICATION_DB` env var must be set. It should be
set to the database you want to replicate.

This slot will be named `$REPLICATION_SLOT_NAME` (defaults to `debezium`) and the plugin used is defiend by `$REPLICATION_PLUGIN` (defaults to `decoderbufs`, `wal2json` is also valid)

## Creating a secondary

If you want to create a secondary instance, first create your master, then set the `$REPLICATION_ROLE` to `slave`.

Additionally, you need to point the secondary at the master with the `$POSTGRES_MASTER_SERVICE_HOST` (default: `localhost`) and `$POSTGRES_MASTER_SERVICE_PORT` (default: `5432`) env vars. The `$REPLICATION_USER` and `$REPLICATION_PASSWORD` env vars must match what was passed to the master instance.

## Other options

Some other options are exposed:
- `$MAX_CONNECTIONS` (default: 500), sets the max number of connections
- `$WAL_KEEP_SEGMENTS` (default: 256), the the number of wal segments to retain
- `$MAX_WAL_SENDERS` (default: 100), sets the number of parallel connections that may be used by standby instances
- `$MAX_REP_SLOTS` (default: 4), the maximum number of replication slots that may be created at once


