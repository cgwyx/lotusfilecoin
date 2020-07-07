FROM archlinux:latest

RUN pacman -Syu --noconfirm opencl-icd-loader &&\
    pacman -Syu --noconfirm go gcc git bzr jq pkg-config opencl-icd-loader opencl-headers base-devel

RUN git clone https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make clean all &&\
    make install &&\
    make build bench

VOLUME ["/home","/root","/var"]


# API port
EXPOSE 1234/tcp

# P2P port
EXPOSE 1347/tcp

# API port
EXPOSE 2345/tcp

# API port
EXPOSE 3456/tcp

ENV IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/

ENV FIL_PROOFS_MAXIMIZE_CACHING=1

ENV FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1

ENV FIL_PROOFS_USE_GPU_TREE_BUILDER=1

WORKDIR /lotus

#ENTRYPOINT ["./lotus", "daemon", "&"]

CMD ["./lotus", "daemon", "&"]
#CMD ["/bin/sh"]
#CMD [ "/bin/sh", "-c", "lotus daemon >> /home/lotus.log &" ]
#CMD [ "./lotus","daemon",">>","/home/lotus.log","&" ]




