#!/bin/sh

set -e

case "$1" in
    *.tmp)
      envsubst < $1 > /etc/docker/registry/config.yml
      set -- /etc/docker/registry/config.yml
      set -- registry serve "$@" ;;
    *.yaml|*.yml) set -- registry serve "$@" ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
esac

exec "$@"