FROM ubuntu:latest

MAINTAINER harry@doverobinson.me

#set up build dir and general deps
RUN mkdir /usr/src/osp-build && \
apt-get update && \
apt-get --no-install-recommends -y install build-essential cmake software-properties-common apt-utils unzip git wget tzdata screen

#compile xritdemod
WORKDIR /usr/src/osp-build
RUN git clone https://github.com/opensatelliteproject/xritdemod.git && \
cd xritdemod/ && \
add-apt-repository ppa:myriadrf/drivers -y && \
add-apt-repository ppa:myriadrf/gnuradio -y && \
apt-get update && \
apt-get --no-install-recommends -y install libairspy-dev libusb-1.0-0-dev libhackrf-dev libhackrf0 && \
make libcorrect && \
make libcorrect-install && \
make libSatHelper && \
make libSatHelper-install && \
make librtlsdr && \
make librtlsdr-install && \
make && \
make test

#prepare goesdump
WORKDIR /usr/src/osp-build/
RUN git clone https://github.com/opensatelliteproject/goesdump.git && \
cd goesdump && \
git clone https://github.com/opensatelliteproject/decompressor.git && \
cd decompressor && \
apt-get --no-install-recommends -y install libaec0 libaec-dev && \
mkdir build && \
cd build && \
cmake .. && \
make && \
make install && \
ldconfig

#install mono and compile goesdump
WORKDIR /usr/src/osp-build/goesdump
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
echo "deb http://download.mono-project.com/repo/debian xenial main" | tee /etc/apt/sources.list.d/mono-xamarin.list && \
apt-get update && \
apt-get --no-install-recommends -y install monodevelop mono-complete nuget && \
wget http://www.monogame.net/releases/v3.5.1/monogame-sdk.run && \
chmod +x monogame-sdk.run && \
echo -en "y\ny\n" | ./monogame-sdk.run && \
nuget restore goesdump.sln && \
mdtool build goesdump.sln -c:"Release|x86"

#set up goesdump-web and executables
WORKDIR /root/
RUN mkdir goesdump && \
cd goesdump && \
cp -r /usr/src/osp-build/goesdump/goesdump/bin/Release/* . && \
chmod +x goesdump.exe && \
wget https://github.com/opensatelliteproject/goesdump/releases/download/1.0.2-beta/goesdump-web.zip && \
unzip goesdump-web.zip && \
mv build web && \
cd .. && \
mkdir xritdemod && \
cd xritdemod && \
cp /usr/src/osp-build/xritdemod/decoder/build/xritDecoder . && \
cp /usr/src/osp-build/xritdemod/demodulator/build/xritDemodulator . && \
chmod +x *

#where .osp-screenrc and .cfg files are to be made available
WORKDIR /root/run/
