# This Dockerfile is ported from https://github.com/yurymuski/curl-http3 
# Switch from Ubuntu 20.04 to Alpine Linux 

# Use multi-stage builds to minimize final image size
FROM alpine:latest AS builder

# Original maintainer
LABEL maintainer="Yury Muski <muski.yury@gmail.com>"
LABEL version="v0.0.1"
LABEL admin="zoonderkins"

WORKDIR /opt

ARG CURL_VERSION=curl-8_1_2
ARG QUICHE_VERSION=0.17.2

# Install necessary build dependencies
RUN apk add --no-cache build-base git autoconf libtool cmake go curl rust cargo perl autoconf automake libtool file nasm pkgconfig;

# Clone quiche
RUN git clone --recursive https://github.com/cloudflare/quiche

# Build quiche
RUN cd quiche && \
    git checkout $QUICHE_VERSION && \
    cargo build --package quiche --release --features ffi,pkg-config-meta,qlog && \
    mkdir quiche/deps/boringssl/src/lib && \
    ln -vnf $(find target/release -name libcrypto.a -o -name libssl.a) quiche/deps/boringssl/src/lib/

# Clone curl
RUN git clone https://github.com/curl/curl
RUN cd curl && \
    git checkout $CURL_VERSION && \
    autoreconf -fi && \
    ./configure LDFLAGS="-Wl,-rpath,/opt/quiche/target/release" --with-openssl=/opt/quiche/quiche/deps/boringssl/src --with-quiche=/opt/quiche/target/release && \
    make && \
    make DESTDIR="/alpine/" install

# Create the final stage and copy the build artifacts from the previous stage
FROM alpine:latest
RUN apk add --no-cache curl libgcc libstdc++

COPY --from=builder /alpine/usr/local/ /usr/local/
COPY --from=builder /opt/quiche/target/release /opt/quiche/target/release

# Add /usr/local/lib to the dynamic linker search directory
ENV LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /opt
# add httpstat script
RUN curl -s https://raw.githubusercontent.com/b4b4r07/httpstat/master/httpstat.sh >httpstat.sh && chmod +x httpstat.sh

CMD ["curl"]
