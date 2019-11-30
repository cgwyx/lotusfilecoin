FROM archlinux:latest


RUN pacman -Syu opencl-icd-loader &&\
    pacman -Syu go gcc git bzr jq pkg-config opencl-icd-loader opencl-headers

RUN git clone https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make clean all &&\
    make install

WORKDIR /lotus

CMD ["/bin/bash"]




