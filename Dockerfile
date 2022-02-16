#### Stage dependencies
FROM ubuntu:latest AS stage

# Deal with Ubuntu's tzdata package stupidity
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update
RUN apt-get -y install wget gcc g++ gfortran make libblas-dev liblapack-dev libpcre3-dev libarpack2-dev \
  libcurl4-gnutls-dev libreadline-dev gnuplot-nox libhdf5-dev llvm-dev libqhull-dev \
  zlib1g-dev autoconf automake bison flex gperf gzip libtool perl rsync tar libsundials-dev \
  texinfo libqrupdate-dev

# Download octave release
ENV SRC=octave-6.4.0
ENV TARBALL=${SRC}.tar.gz
RUN wget https://ftpmirror.gnu.org/octave/${TARBALL} && tar zxf ${TARBALL}


#### Compile from source
FROM stage AS build

WORKDIR ${SRC}
ENV CFLAGS="-O2 -pipe"
RUN ./configure --without-qt --disable-java --disable-docs --without-opengl --without-freetype
RUN make -j 4
RUN make install


#### Production image
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
