# syntax=docker/dockerfile:1.7

########################
# Build stage
########################
FROM debian:bookworm-slim AS build
ARG SRC_VER=octave-10.2.0
ENV DEBIAN_FRONTEND=noninteractive

# Toolchain & build deps (single RUN, no recommends, cache mounts)
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates wget \
      build-essential gcc g++ gfortran make pkg-config \
      libblas-dev liblapack-dev libpcre3-dev libarpack2-dev \
      libcurl4-gnutls-dev libreadline-dev gnuplot-nox libhdf5-dev \
      llvm-dev libqhull-dev zlib1g-dev autoconf automake bison flex \
      gperf gzip libtool perl rsync tar libsundials-dev texinfo \
      libqrupdate-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Fetch source (quiet) and extract
ARG SRC_SHA256=""
ENV SRC=${SRC_VER} TARBALL=${SRC_VER}.tar.gz
RUN wget -q https://ftp.gnu.org/gnu/octave/${TARBALL} \
 && if [ -n "${SRC_SHA256}" ]; then echo "${SRC_SHA256}  ${TARBALL}" | sha256sum -c -; fi \
 && tar -xzf ${TARBALL}

# Configure, build, and stage-install into /opt/stage
WORKDIR /tmp/${SRC_VER}
ENV CFLAGS="-O2 -pipe" CXXFLAGS="-O2 -pipe" FFLAGS="-O2 -pipe" MAKEFLAGS="-j$(nproc)"
RUN ./configure --without-qt --disable-java --disable-docs --without-opengl --without-freetype \
 && make \
 && make install DESTDIR=/opt/stage

########################
# Runtime stage
########################
FROM debian:bookworm-slim AS runtime
ENV DEBIAN_FRONTEND=noninteractive

# Runtime libraries only (single RUN, no recommends, cache mounts)
# If you later confirm exact non-*-dev runtime libs, swap them in here.
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get install -y --no-install-recommends \
      libblas-dev liblapack-dev libpcre3-dev libarpack2-dev \
      libcurl4-gnutls-dev libreadline-dev gnuplot-nox libhdf5-dev \
      libqhull-dev zlib1g-dev libsundials-dev libqrupdate-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy only what "make install" produced
COPY --from=build /opt/stage/usr/local/ /usr/local/

# Octave helper functions
COPY src/ /usr/local/share/octave/site/m/

# Optional: test files
RUN mkdir -p /test
COPY test/ /test/
