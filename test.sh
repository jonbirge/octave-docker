#!/bin/bash

rm -f testfig.png
docker run \
  -w /testing \
  --name octave-test \
  --mount type=bind,source="$(pwd)",target=/testing \
  jonbirge/octave:latest \
  octave-cli /test/testfig.m
docker rm octave-test

[ -f testfig.png ] && exit 0
exit 1
