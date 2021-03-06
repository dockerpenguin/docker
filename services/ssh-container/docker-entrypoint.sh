#!/bin/sh

if [ -d "/root/.ssh" ]; then
    chown -R root:root /root/.ssh
    chmod 700 /root/.ssh
fi
if [ -f "/root/.ssh/authorized_keys" ]; then
    chmod 644 /root/.ssh/authorized_keys
fi
if [ -f "/root/.ssh/id_rsa" ]; then
    chmod 600 /root/.ssh/id_rsa
fi
if [ -f "/root/.ssh/id_rsa.pub" ]; then
    chmod 644 /root/.ssh/id_rsa.pub
fi

exec "$@"