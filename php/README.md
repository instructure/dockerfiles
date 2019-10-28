# instructure/php

Universial(ish) base images for PHP apps without a web server.

## Entrypoint
There is an entrypoint script specified, this script will execute any shell, PHP, or python (version 3) scripts placed in
`/entrypoint.d` with their executable bit(s) set in lexical order according the the locale in the container (defaults to
`en_US.UTF-8`). This is useful for initializing configuration files as a bridge from file based configuration to 
environment variables exclusively. 

*Note*: These scripts are executed as the `docker` user and will be subject to that user's access to the filesystem.
