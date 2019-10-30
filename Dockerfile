FROM golang:1.13.3-alpine


RUN apt-get install bzr git jq

RUN git clone https://github.com/filecoin-project/lotus.git &&\
    cd lotus &&\
    make &&\
    make install

CMD ["/bin/bash"]




