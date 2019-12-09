#!/usr/bin/env bash
#
# Script taken from https://github.com/oracle/docker-images/blob/master/GraalVM/CE/19/gu-wrapper.sh and modified.
#

link_languages () {
  # Add new links for newly installed components
  for bin in "$JAVA_HOME/bin/"*; do
    base="$(basename "$bin")";
    if [[ ! -e "/usr/bin/$base" ]]; then
      sudo update-alternatives --install "/usr/bin/$base" "$base" "$bin" 20000;
    fi
  done;

  echo "Refreshed alternative links in /usr/bin/"
}

action="$@"
case "$action" in
  link)
      link_languages
    ;;
  *)
    $JAVA_HOME/bin/gu "${@}"
    RT=$?
    if [ $RT -ne 0 ]; then
      exit $RT
    fi
    if [[ "$@" == *"install"* ]]; then
      link_languages
    fi
    ;;
esac
