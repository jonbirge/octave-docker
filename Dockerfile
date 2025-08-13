#### Build image
FROM ubuntu:latest AS build
ARG SRC_VER=octave-10.2.0

# Deal with Ubuntu's tzdata package stupidity
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update
RUN apt-get -y install wget gcc g++ gfortran make libblas-dev liblapack-dev libpcre3-dev libarpack2-dev \
  libcurl4-gnutls-dev libreadline-dev gnuplot-nox libhdf5-dev llvm-dev libqhull-dev \
  zlib1g-dev autoconf automake bison flex gperf gzip libtool perl rsync tar libsundials-dev \
  texinfo libqrupdate-dev

# Download octave release
ENV SRC=${SRC_VER}
ENV TARBALL=${SRC}.tar.gz
RUN wget http://ftp.gnu.org/gnu/octave/${TARBALL} && tar zxf ${TARBALL}

# Compile and install
WORKDIR ${SRC}
ENV CFLAGS="-O2 -pipe"
RUN ./configure --without-qt --disable-java --disable-docs --without-opengl --without-freetype
RUN make -j 8
RUN make install


#### Deployment image
FROM ubuntu:latest

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
