# gpg-signer

Signs arbitrary files in mounted volume with provided GPG key and passphrase,
and stores the signature files in the same directory using the same uid:gid.

## Usage

Place any files you want signed in a dedicated directory, and mount that
directory as volume `/to-sign` in the container. Provide your GPG private key
via the environment variable `GPG_PRIVATE_KEY`, and the passphrase for using
the key as `GPG_PASSPHRASE`. These are both highly sensitive values, so be
sure to use appropriate secret management.

Example:

    $ docker run --rm -it -v $(pwd)/my-signable-files:/to-sign \
          -e GPG_PRIVATE_KEY -e GPG_PASSPHRASE \
          instructure/gpg-signer

If there are no files provided, the script will exit immediately. Any errors
importing the key or signing the provided files will immediately end the run.

Generated signature files will be named `<original-filename>.asc`.
