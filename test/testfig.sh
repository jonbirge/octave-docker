#!/bin/bash

rm -f testfig.png
docker run \
  -w /test \
  --name octave-test \
  --mount type=bind,source="$(pwd)",target=/test \
  jonbirge/octave:latest \
  octave-cli testfig.m
docker rm octave-test

[ -f testfig.png ] && exit 0
exit 1
