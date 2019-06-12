#!/bin/sh

set -e

case "$1" in
    *.tmp)
      envsubst < $1 > /conf/config.yml
      set -- start.sh ;;
esac

exec "$@"