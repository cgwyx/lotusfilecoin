FROM archlinux:latest

RUN pacman -Syu --noconfirm opencl-icd-loader &&\
    pacman -Syu --noconfirm go gcc git bzr jq pkg-config opencl-icd-loader opencl-headers base-devel

RUN git clone https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make clean all &&\
    make install

WORKDIR /lotus

CMD ["/bin/bash"]




