docker volume create rtorrent-socket
docker volume create rtorrent-downloads
docker volume create rtorrent-config

docker run -it \
--rm \
--name rtorrent \
--mount source=rtorrent-socket,target=/socket \
--mount source=rtorrent-downloads,target=/downloads \
--mount source=rtorrent-config,target=/config \
-e PUID=1000 \
-e PGID=1000 \
-p 6882:6882 \
-p 51415:51415 \
neosar/docker-rtorrent \
/bin/bash
