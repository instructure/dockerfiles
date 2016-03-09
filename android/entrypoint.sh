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
    # aa\n bb =>
    # a
    # b
    IDRSA="${IDRSA//\\n /
}"
    echo "$IDRSA" > "$HOME/.ssh/id_rsa"
    unset IDRSA
fi

# Add Google cloud key to the container
if [ -z "$GCLOUDKEY" ]; then
    echo >&2 'error: missing required GCLOUDKEY environment variable.'
    echo >&2 '       -e GCLOUDKEY=...'
    exit 1
else
    GCLOUDKEY="${GCLOUDKEY//\\n /
}"
    echo "$GCLOUDKEY" | base64 -d  > "$HOME/.ssh/gcloudkey.json"
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

# Pull instance ID from EC2 meta-data.
INSTANCE_ID=$(curl -fs http://169.254.169.254/latest/meta-data/instance-id/)
if [ $? == 0 ]; then
    export EXECUTOR_ID="$INSTANCE_ID"
else
    export EXECUTOR_ID="unknown_instance"
fi

# Access as "%(ENV_EXECUTOR_ID)s" in supervisord config
if [ -z "$EXECUTOR_ID" ]; then
    echo >&2 'error: EXECUTOR_ID not set!'
    exit 1
fi

# Start Jenkins CLI via supervisord conf
exec /usr/local/bin/supervisord -c "$HOME/supervisord.conf"
