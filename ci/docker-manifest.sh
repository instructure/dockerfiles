#!/bin/bash

EXIT_CODE=0
MANIFEST_RESULT=$(docker manifest "$@" 2>&1) || EXIT_CODE=$?

if [[ $MANIFEST_RESULT =~ (no such manifest) ]]; then
  EXIT_CODE=0
elif [[ $MANIFEST_RESULT =~ (unsupported manifest format) ]]; then
  sleep 10

  EXIT_CODE=0
  MANIFEST_RESULT=$(docker manifest "$@" 2>&1) || EXIT_CODE=$?
fi

if [[ "$EXIT_CODE" = "0" ]]; then
  echo $MANIFEST_RESULT
fi

exit $EXIT_CODE
