#!/bin/bash

die() { echo "ERROR: $@" >&2; exit 1; }

for f in /to-sign/*; do
    if [[ $f == "/to-sign/*" ]]; then
        echo "INFO: No files were found to sign in /to-sign. Exiting."
        exit 0
    else
        break
    fi
done

if [[ -z $GPG_PRIVATE_KEY ]]; then
    die "You must specify your private key via GPG_PRIVATE_KEY"
fi

if [[ -z $GPG_PASSPHRASE ]]; then
    die "You must specify your passphrase via GPG_PASSPHRASE"
fi

echo Importing private key:
# import private key
echo "$GPG_PRIVATE_KEY" > ~/private-key.pem
if ! gpg --import --batch --yes ~/private-key.pem; then
    die "Unable to import private key into GPG"
fi

echo
echo Getting key fingerprint...
fingerprint=$( gpg --list-keys --with-colons |awk -F: '$1=="fpr" {print $10}' |head -n 1 )
if [[ -z $fingerprint ]]; then
    die "Could not get fingerprint for imported key"
fi

for f in /to-sign/*; do
    if [[ -f $f ]]; then
        file_uid=$( stat -c %u "$f" )
        file_gid=$( stat -c %g "$f" )
        signed_file="${f}.asc"
        if ! gpg --batch --passphrase "$GPG_PASSPHRASE" --pinentry-mode loopback --local-user "$fingerprint" --output "$signed_file" --detach-sign "$f"; then
            die "Unable to sign file '$f'"
        fi
        chown "$file_uid:$file_gid" "$signed_file"
        echo Signed $f
    fi
done
