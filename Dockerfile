#### Build image
FROM jonbirge/octave-base AS build
ARG SRC_VER=octave-8.2.0

# Download octave release
ENV SRC=${SRC_VER}
ENV TARBALL=${SRC}.tar.gz
RUN wget https://ftpmirror.gnu.org/octave/${TARBALL} && tar zxf ${TARBALL}

# Compile and install
WORKDIR ${SRC}
ENV CFLAGS="-O2 -pipe"
RUN ./configure --without-qt --disable-java --disable-docs --without-opengl --without-freetype
RUN make -j 12
RUN make install


#### Production image
FROM ubuntu:kinetic

# Runtime dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install libblas-dev liblapack-dev libpcre3-dev libarpack2-dev \
  libcurl4-gnutls-dev libreadline-dev gnuplot-nox libhdf5-dev libqhull-dev \
  zlib1g-dev libsundials-dev libqrupdate-dev

# Copy in from build
COPY --from=build /usr/local /usr/local

# Copy in octave helper functions
COPY src/* /usr/local/share/octave/site/m/
RUN mkdir /test
COPY test/* /test
