FROM ubuntu:latest

# Deal with Ubuntu's tzdata package stupidity
ENV DEBIAN_FRONTEND=noninteractive

# Install packages and pare dependencies safely
RUN apt-get update && \
  apt-get install -y octave fig2dev && \
  apt-get remove -y gnome-shell libgtk-3-common && \
  apt-get autoremove -y && \
  apt-get clean

# Replace figure() with version that automatically hides figure
