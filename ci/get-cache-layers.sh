#!/bin/bash

pushd $1 > /dev/null

readarray -t MANIFEST_DIGESTS < <( cat index.json | jq -r '.manifests[].digest' )
OUTPUT=()

for manifestDigest in "${MANIFEST_DIGESTS[@]}"; do
  manifestPath=${manifestDigest/:/\/}

  readarray -t manifestLayers < <( cat "blobs/${manifestPath}" | jq -r '.layers[] | .digest' | sort -)
  OUTPUT+=(${manifestLayers[@]})
done

SORTED_OUTPUT=( $(sort <<< "${OUTPUT[@]}") )

for outputLine in "${SORTED_OUTPUT[@]}"; do
  echo "${outputLine}"
done

popd > /dev/null
