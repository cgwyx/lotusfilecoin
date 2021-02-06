# lotusfilecoin
1.lotus daemon  
docker run -d --restart=always --name lotusdocker --gpus all --net host --privileged \
-e BELLMAN_CUSTOM_GPU="GeForce GTX 1660:1408" \
-v /media/p300/lotusmaster/:/root/ -v /media/p300/lotusv28/:/var/tmp/ \
cgwyx/lotusfilecoin:opencl

2.lotus mining  
docker exec -d lotusdocker lotus-storage-miner run
