# osp-docker
This is a docker container for the Open Satellite Project's xritdemod and goesdump.

Building the container:
cd osp-docker/
docker build -t osp-docker .

Running the container:
docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/osp-docker:/root/run -p 8090:8090 -it osp-build screen -c .osp-screenrc
where "~/osp-docker" is the path to the directory of this repository.

Run the container within a GNU screen session:
screen -mS osp-docker /bin/bash -c 'docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/osp-docker:/root/run -p 8090:8090 -it osp-build screen -c .osp-screenrc'
