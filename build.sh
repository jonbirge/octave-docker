#!/bin/bash

SRC_VER=octave-6.4.0
docker build --build-arg SRC_VER=${SRC_VER} --tag jonbirge/octave:latest .
docker tag jonbirge/octave:latest jonbirge/octave:${SRC_VER}
docker push jonbirge/octave:${SRC_VER}
