#!/bin/bash

SRC_VER=octave-10.2.0
docker build --build-arg SRC_VER=${SRC_VER} --tag jonbirge/octave:latest .
docker tag jonbirge/octave:latest jonbirge/octave:${SRC_VER}

