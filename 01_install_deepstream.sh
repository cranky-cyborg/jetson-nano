#!/bin/bash

cd ~
sudo apt update

echo "Installing DeepStreem 6.0.1"
echo " NOTE: Deepsteam v6.0.1 (approx 680MB) will need to be manually downloaded from NVidia website"
echo "       link - https://developer.nvidia.com/deepstream_6.0.1/deepstream-6.0_6.0.1-1_arm64.deb"
echo " Once download, please the file in folder '/deepstream-6.0.1' "
echo "----------------------------------------------------------------------------------------------"
echo " - Install package supporting DeepStream install"

#for deepstream 6.0.1
sudo apt install -y libssl1.0.0 libjansson4=2.11-1
sudo apt install -y libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 
sudo apt install -y nvidia-jetpack
#for DeepSteam 6.2
#sudo apt install -y libssl1.1 libjansson4 libyaml-cpp-dev

echo " - Install Apache Kafka from source"

cd ~

# Clone librdkafka from github
git clone https://github.com/edenhill/librdkafka.git
cd librdkafka
# we need a specific version of this repo.
# i didn't do the research as to why, and the implications of not doing it
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a

# run the config, Note: ignore any warning/disables, as long as the command doesn't fail
./configure

# make and install
make
sudo make install

# Create the deepstream folder
# copy the files to the deepstream folder
sudo mkdir -p /opt/nvidia/deepstream/deepstream-6.0/lib
sudo cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-6.0/lib

echo "Installing latest NVIDIA packages"

# Installing latest NVIDIA packages (reinstall specifically)
sudo apt install --reinstall nvidia-l4t-gstreamer
sudo apt install --reinstall nvidia-l4t-multimedia
sudo apt install --reinstall nvidia-l4t-core

echo "Install DeepStream package, from folder /deepsteam-6.0.1"
# install deepstream from package (approx 600mb)

sudo apt install /deepstream-6.0.1/deepstream-6.0_6.0.1-1_arm64.deb
