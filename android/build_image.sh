#!/bin/bash --login
set -e
# Don't use set -x because the private env vars will be expanded.
# Must be login shell to source /etc/profile

# Override home dir
HOME=/home/docker
SSH="$HOME/.ssh"
SSH_KEY="$SSH/id_rsa"
IDRSA=$1

if [ ! -d "$SSH" ]; then
    mkdir -p "$SSH"
fi

if [ -z "$IDRSA" ]; then
    echo >&2 'error: missing required IDRSA build argument'
    echo >&2 '       --build-arg IDRSA==...'
    exit 1
else
    echo "$IDRSA" > "$SSH_KEY"
    unset IDRSA
    chmod 600 $SSH_KEY
fi

if [ -z "$REPO_INIT" ]; then
    echo >&2 'error: missing required REPO_INIT build argument'
    echo >&2 '       --build-arg REPO_INIT==...'
    exit 1
fi

if [ -z "$ANDROID_PROJECT_NAME" ]; then
    echo >&2 'error: missing required ANDROID_PROJECT_NAME build argument'
    echo >&2 '       --build-arg ANDROID_PROJECT_NAME==...'
    exit 1
fi

# Install repo
mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

# Build android
ANDROID_REPOS=/tmp/android_repos
mkdir $ANDROID_REPOS
cd $ANDROID_REPOS
repo init -u $REPO_INIT
repo sync -d
cd $ANDROID_PROJECT_NAME
./gradlew :$ANDROID_PROJECT_NAME:clean \
          :$ANDROID_PROJECT_NAME:assembleDebug \
          :$ANDROID_PROJECT_NAME:assembleDebugAndroidTest \
          --no-daemon -PskipAdb --stacktrace
rm -rf $ANDROID_REPOS

# Remove ssh key so it's not saved in the image
rm -rf $SSH_KEY
