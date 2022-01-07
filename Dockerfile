FROM ubuntu:latest AS builder

# Deal with Ubuntu's tzdata package stupidity
ENV DEBIAN_FRONTEND=noninteractive

# Install packages and pare dependencies safely
RUN apt-get update

RUN apt-get install -y octave fig2dev

RUN apt-get purge -y gnome-shell && apt-get autoremove -y && apt-get clean


FROM builder

# Copy in offline octave graphics helper functions
COPY src/* /usr/share/octave/site/m/
