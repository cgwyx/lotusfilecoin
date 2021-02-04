# build container stage
FROM golang:latest AS build-env
#FROM golang:1.15.6-buster AS build-env
#FROM golang:1.15.5-buster AS build-env

# branch or tag of the lotus version to build
ARG BRANCH=v1.5.0-pre3
#ARG BRANCH=interopnet
#ARG BRANCH=master

#RUN echo "Building lotus from branch $BRANCH"
########
#RUN apt-get update -y && \
#    apt-get install sudo curl git mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config -y
########

########
RUN apt-get update -y && \
    apt-get install gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev clang opencl-headers wget -y
RUN go env -w GOPROXY=https://goproxy.cn
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
RUN echo "export PATH=~/.cargo/bin:$PATH" >> ~/.bashrc
#######

WORKDIR /

RUN git clone -b $BRANCH https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make clean &&\
    make all &&\
    make install


# runtime container stage
FROM nvidia/opencl:runtime-ubuntu16.04
#FROM nvidia/opencl:devel-ubuntu18.04
#FROM nvidia/opencl:runtime-ubuntu18.04
#FROM nvidia/cudagl:10.2-devel-ubuntu18.04
#FROM apicciau/opencl_ubuntu:latest

# Instead of running apt-get just copy the certs and binaries that keeps the runtime image nice and small
#RUN apt-get update -y && \
    #apt-get install sudo ca-certificates mesa-opencl-icd ocl-icd-opencl-dev clinfo -y && \
    #rm -rf /var/lib/apt/lists/*
RUN apt-get update -y && \
    apt-get install clinfo -y
    
COPY --from=build-env /lotus /lotus
COPY --from=build-env /etc/ssl/certs /etc/ssl/certs
#COPY LOTUS_VERSION /VERSION

COPY --from=build-env /lib/x86_64-linux-gnu/libdl.so.2 /lib/libdl.so.2
COPY --from=build-env /lib/x86_64-linux-gnu/libutil.so.1 /lib/libutil.so.1 
COPY --from=build-env /usr/lib/x86_64-linux-gnu/libOpenCL.so.1.0.0 /lib/libOpenCL.so.1
COPY --from=build-env /lib/x86_64-linux-gnu/librt.so.1 /lib/librt.so.1
COPY --from=build-env /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/libgcc_s.so.1

#COPY config/config.toml /root/config.toml
#COPY scripts/entrypoint /bin/entrypoint

RUN ln -s /lotus/lotus /usr/bin/lotus && \
    ln -s /lotus/lotus-miner /usr/bin/lotus-miner && \
    ln -s /lotus/lotus-worker /usr/bin/lotus-worker

VOLUME ["/root","/var"]


# API port
EXPOSE 1234/tcp

# API port
EXPOSE 2345/tcp

# API port
EXPOSE 3456/tcp

# P2P port
EXPOSE 1347/tcp

# ipfs port
EXPOSE 4567/tcp


ENV IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/

ENV FIL_PROOFS_MAXIMIZE_CACHING=1

ENV FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1

ENV FIL_PROOFS_USE_GPU_TREE_BUILDER=1


WORKDIR /lotus


CMD ["lotus", "daemon", "&"]
#ENTRYPOINT ["/bin/entrypoint"]
#CMD ["-d"]

