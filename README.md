# osp-docker
This is a docker container for running the Open Satellite Project's xritdemod and goesdump on a Linux host.

Building the container:
`cd osp-docker/ && docker build -t osp-docker .`

Running the container:
`docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/osp-docker:/root/run -p 8090:8090 -it osp-docker screen -c .osp-screenrc`
where "~/osp-docker" is the path to the directory of this repository.

(Optional) Running the container within a GNU screen session:
`screen -mS osp-docker /bin/bash -c 'docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/osp-docker:/root/run -p 8090:8090 -it osp-docker screen -c .osp-screenrc'`

Stopping the container:
`docker stop $(docker ps -a -q)` (stops all docker containers on host)

Configuration:
Edit the xritdecoder.cfg and xritdemod.cfg files as you would normally. Restart the docker container after edits are made.
