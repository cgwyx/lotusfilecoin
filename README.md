# lotusfilecoin
lotus filecoin
docker run -it --name filecoin-lotus -v ~/lotus/init:/root/ -v ~/lotus/proof:/var/tmp/ --entrypoint=/bin/sh cgwyx/lotusfilecoin:latest
