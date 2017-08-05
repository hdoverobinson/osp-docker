# osp-docker
docker container for Open Satellite Project xritdemod and goesdump

screen -mS osp-docker /bin/bash -c 'docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/osp-docker:/root/run -p 8090:8090 -it osp-build screen -c .osp-screenrc'
