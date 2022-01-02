FROM ubuntu:latest

# Updating the packages and installing cron
RUN apt-get update && \
  apt-get install -y --no-install-recommends octave fig2dev
