FROM archlinux:latest

RUN pacman -Syu --noconfirm opencl-icd-loader &&\
    pacman -Syu --noconfirm go gcc git bzr jq pkg-config opencl-icd-loader opencl-headers base-devel

RUN git clone https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make clean all &&\
    make install

VOLUME ["/home","/root","/var"]

EXPOSE 1234/tcp
EXPOSE 8080/tcp

ENV IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/

WORKDIR /lotus

CMD ["./lotus","daemon"]
#CMD ["/bin/sh"]
#CMD [ "/bin/sh", "-c", "lotus daemon >> /home/lotus.log &" ]
#CMD [ "./lotus","daemon",">>","/home/lotus.log","&" ]




