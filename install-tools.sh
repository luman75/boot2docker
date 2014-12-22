#!/bin/sh
set -e
dir=`dirname "$0"`
cd "$dir"

set -x
cp tools/docker-bash $ROOTFS/usr/local/bin/
cp tools/docker-ssh $ROOTFS/usr/local/bin/
cp tools/baseimage-docker-nsenter $ROOTFS/usr/local/bin/
mkdir -p $ROOTFS/usr/local/share/baseimage-docker
cp image/insecure_key $ROOTFS/usr/local/share/baseimage-docker/
chmod 644 $ROOTFS/usr/local/share/baseimage-docker/insecure_key
