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
    echo >&2 '       -e IDRSA=...'
    exit 1
else
    echo "$IDRSA" > "$SSH_KEY"
    unset IDRSA
    chmod 600 $SSH_KEY
fi

# Install repo
mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

# Build candroid
CANDROID_REPOS=/tmp/candroid_repos
mkdir $CANDROID_REPOS
cd $CANDROID_REPOS
repo init -u ssh://hudson@gerrit.instructure.com:29418/android-repo -m default.xml
repo sync -d
cd candroid
./gradlew :candroid:clean :candroid:assembleDebug :candroid:assembleDebugAndroidTest -PskipAdb --stacktrace
rm -rf $CANDROID_REPOS

# Remove ssh key so it's not saved in the image
rm -rf $SSH_KEY
