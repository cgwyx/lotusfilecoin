FROM golang:1.15.6 AS builder
#FROM golang:1.15.6 AS builder-deps
MAINTAINER https://github.com/cgwyx/ https://hub.docker.com/u/cgwyx

RUN apt-get update && apt-get install -y ca-certificates build-essential clang ocl-icd-opencl-dev ocl-icd-libopencl1 jq libhwloc-dev

ARG RUST_VERSION=nightly
#ENV XDG_CACHE_HOME="/tmp"

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN wget "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

WORKDIR /

ARG BRANCH=v1.4.1

RUN git clone --recursive -b $BRANCH https://github.com/filecoin-project/lotus.git && \
    cd lotus &&\
    make clean &&\
    make all &&\
    make install


FROM nvidia/opencl:devel-ubuntu18.04
#FROM nvidia/opencl:runtime-ubuntu18.04
#FROM nvidia/cudagl:10.2-devel-ubuntu18.04
#FROM apicciau/opencl_ubuntu:latest

RUN apt-get update -y && \
    apt-get install clinfo -y

COPY --from=builder /etc/ssl/certs                           /etc/ssl/certs
COPY --from=builder /lib/x86_64-linux-gnu/libdl.so.2         /lib/
COPY --from=builder /lib/x86_64-linux-gnu/librt.so.1         /lib/
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1      /lib/
COPY --from=builder /lib/x86_64-linux-gnu/libutil.so.1       /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libltdl.so.7   /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libnuma.so.1   /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libhwloc.so.5  /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /lib/

COPY --from=builder /lotus /lotus

RUN ln -s /lotus/lotus /usr/bin/lotus && \
    ln -s /lotus/lotus-miner /usr/bin/lotus-miner && \
    ln -s /lotus/lotus-worker /usr/bin/lotus-worker

#chmod u+x /lotus

VOLUME ["/root","/var"]


# API port
EXPOSE 1234/tcp

# API port
EXPOSE 2345/tcp

# API port
EXPOSE 3456/tcp

# P2P port
EXPOSE 1347/tcp


ENV IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/

ENV FIL_PROOFS_MAXIMIZE_CACHING=1

ENV FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1

ENV FIL_PROOFS_USE_GPU_TREE_BUILDER=1


WORKDIR /lotus


CMD ["lotus", "daemon", "&"]

