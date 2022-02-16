#!/bin/bash

rm -f testfig.png
docker run -d \
  --name octave-test \
  --mount type=bind,source="$(pwd)",target=/test \
  jonbirge/octave:latest
  "cd /test && octave-cli testfig.m"

[ -f testfig.png ] && exit 0
exit 1
