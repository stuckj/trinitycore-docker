#!/bin/bash

set -e

BASEDIR=/home/trinitycore

docker run -it --rm \
  -v ${PWD}/data:${BASEDIR}/data \
  -v ${PWD}/WorldofWarcraft-3.3.5a:${BASEDIR}/WorldofWarcraft-3.3.5a \
  -v ${PWD}/extract-data-cmd.sh:${BASEDIR}/extract-data-cmd.sh \
  trinitycore \
  ${BASEDIR}/extract-data-cmd.sh
