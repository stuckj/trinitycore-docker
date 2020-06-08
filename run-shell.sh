#!/bin/bash

set -e

BASEDIR=/home/trinitycore

docker run -it --rm \
  -v ${PWD}/data:${BASEDIR}/data \
  -v ${PWD}/WorldofWarcraft-3.3.5a:${BASEDIR}/WorldofWarcraft-3.3.5a \
  -v ${PWD}/etc/authserver.conf:${BASEDIR}/etc/authserver.conf \
  -v ${PWD}/etc/worldserver.conf:${BASEDIR}/etc/worldserver.conf \
  trinitycore \
  /bin/bash
