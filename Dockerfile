FROM ubuntu:latest

# Deal with Ubuntu's tzdata package stupidity
ENV DEBIAN_FRONTEND=noninteractive

# Updating the packages and installing cron
RUN apt-get update && \
  apt-get install -y octave fig2dev
