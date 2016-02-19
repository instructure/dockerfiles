#!/bin/bash
set -e
# don't use set -x because the private env vars will be expanded.

HOME=/home/docker

# Add SSH key to the container
if [ -z "$IDRSA" ]; then
    echo >&2 'error: missing required IDRSA environment variable.'
    echo >&2 '       -e IDRSA=...'
    exit 1
else
    echo "$IDRSA" > "$HOME/.ssh/id_rsa"
    unset IDRSA
fi

# Add Google cloud key to the container
if [ -z "$GCLOUDKEY" ]; then
    echo >&2 'error: missing required GCLOUDKEY environment variable.'
    echo >&2 '       -e GCLOUDKEY=...'
    exit 1
else
    echo "$GCLOUDKEY" > "$HOME/.ssh/gcloudkey.json"
    unset GCLOUDKEY
fi

if [ -z "$GCLOUDUSER" ]; then
    echo >&2 'error: missing required GCLOUDUSER environment variable.'
    echo >&2 '       -e GCLOUDUSER=...'
    exit 1
fi

gcloud auth activate-service-account --key-file "$HOME/.ssh/gcloudkey.json" "$GCLOUDUSER"
gcloud auth login "$GCLOUDUSER"

# user@some-project-123456.iam.gserviceaccount.com => some-project-123456
export GCLOUDPROJECT=`echo "$GCLOUDUSER" | sed -nr 's/.*@([^.]+).*/\1/p'`
gcloud config set project "$GCLOUDPROJECT"

# force auto update to new config format by setting a property
gcloud config set component_manager/disable_update_check True

# Executor id (usually a number: 1, 2, 3 etc.)
# Access as "%(ENV_EXECUTOR_ID)s" in supervisord config
if [ -z "$EXECUTOR_ID" ]; then
    echo >&2 'error: missing required EXECUTOR_ID environment variable.'
    echo >&2 '       -e EXECUTOR_ID=...'
    exit 1
fi

# Start Jenkins CLI via supervisord conf
exec /usr/local/bin/supervisord -c "$HOME/supervisord.conf"
