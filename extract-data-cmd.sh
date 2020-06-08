#!/bin/bash

set -e

PATH=${PATH}:${HOME}/bin
DATA=${HOME}/data

cd ${HOME}/WorldofWarcraft-3.3.5a
mapextractor
cp -r dbc maps ${DATA}

vmap4extractor
mkdir vmaps
vmap4assembler Buildings vmaps
cp -r vmaps ${HOME}/data

mkdir mmaps
mmaps_generator
cp -r mmaps ${HOME}/data
