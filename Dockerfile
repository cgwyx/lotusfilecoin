FROM golang:1.13.2-stretch


RUN apt -y update &&\
    apt -y install mesa-opencl-icd ocl-icd-opencl-dev &&\
    add-apt-repository ppa:longsleep/golang-backports &&\
    apt -y update &&\
    apt -y install gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev

RUN git clone https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make clean all &&\
    make install

WORKDIR /lotus

CMD ["/bin/bash"]




