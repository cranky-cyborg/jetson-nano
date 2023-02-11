#!/bin/bash

sudo apt update
#install DeepStream

#this is for latest DeepSteam 6.2
#sudo apt install -y libssl1.1 libjansson4 libyaml-cpp-dev

#for deepstream 6.0.1
sudo apt install -y libssl1.0.0 libjansson4=2.11-1

sudo apt install -y libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 

# (Deepsteam)-- install kafka
git clone https://github.com/edenhill/librdkafka.git
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a
./configure
make
sudo make install

# copy the files to the deepstream folder
sudo mkdir -p /opt/nvidia/deepstream/deepstream-6.0/lib
sudo cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-6.0/lib

# Installing latest NVIDIA BSP packages
sudo apt install --reinstall nvidia-l4t-gstreamer
sudo apt install --reinstall nvidia-l4t-multimedia
sudo apt install --reinstall nvidia-l4t-core

# install deepstream from package (approx 600mb)

sudo apt install /deepstream-6.0.1/deepstream-6.0_6.0.1-1_arm64.deb
