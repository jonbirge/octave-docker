#!/bin/bash

docker build --file Dockerfile_base --tag jonbirge/octave-base .
docker push jonbirge/octave-base
