FROM ubuntu:latest

# Deal with Ubuntu's tzdata package stupidity
ENV DEBIAN_FRONTEND=noninteractive

# Updating the packages and installing cron
RUN apt-get update && \
  apt-get install -yq --no-install-recommends octave fig2dev
