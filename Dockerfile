FROM golang:1.13.2-stretch


RUN apt-get -y update &&\
    apt-get -y install bzr pkg-config gcc git jq

RUN git clone https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make &&\
    make install

CMD ["/bin/bash"]




