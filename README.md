# lotusfilecoin
1.lotus daemon  
docker run -d --restart=always --name lotusdocker -e BELLMAN_CUSTOM_GPU="GeForce GTX 750 Ti:640" -v ~/lotus/:/root/ -v ~/lotus/:/var/tmp/ -p "1234:1234"  -p "1235:1235" -p "2345:2345"  cgwyx/lotusfilecoin:latest

2.lotus mining  
docker exec -d lotusdocker lotus-storage-miner run
