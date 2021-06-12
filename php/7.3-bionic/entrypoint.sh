#!/bin/bash

DIR=/entrypoint.d

if [[ -d "$DIR" ]]; then
  /bin/run-parts --verbose --regex '\.(sh|py|php)$' "$DIR"
fi

exec "$@"
