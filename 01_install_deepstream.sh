#!/bin/bash


echo "
Jetson-Nano - Script 01 - Install Deepstream

The purpose of this script is to install necessary packages, libraries and 
other tools, that are necessary to install and run Nvidia Deepstream libraries."

echo "Step 0: Do you need to install Wifi drivers?"
read -p " Press (Y)es to install 88x2bu Kernel drivers" yn88x

if [[ $yn88x =~ ^[Yy]$ ]]
then
  cd ~/drivers/RTL88x2BU-Linux-Driver-master
  make
  sudo make install
  sudo modprobe 88x2bu rtw_switch_usb_mode=1
  sleep 15 
fi

echo "Step 1: Download DeepStreem 6.0.1 (Manual Step)"
echo "  NOTE 1: Deepsteam v6.0.1 (approx 680MB) will need to be manually downloaded from NVidia website"
echo "          link - https://developer.nvidia.com/deepstream_6.0.1/deepstream-6.0_6.0.1-1_arm64.deb
"
echo "  NOTE 2: Once download, please move the file to folder '/deepstream-6.0.1' "
echo "----------------------------------------------------------------------------------------------
"

read -p "After the file has been moved to /deepstream-6.0.1 
Please press any key to continue... : "

#Move to home directory and get updates from repository
cd ~
sudo apt update

echo "Step 2: Install dependencies from repositories"
echo "  dependencies are libssl, libjansson, nvidia-jetpack and multiple gstreamer libraries
"
read -p "Please press any key to continue... : "
#Install package dependencies for deepstream 6.0.1
sudo apt install -y libssl1.0.0 libjansson4=2.11-1
sudo apt install -y libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 
sudo apt install -y nvidia-jetpack

#for DeepSteam 6.2 (Note: 6.2 is not supported on Jetson Nano)
#sudo apt install -y libssl1.1 libjansson4 libyaml-cpp-dev

echo "Step 3: Install Apache Kafka from source (github)
"
read -p "Please press any key to continue... : "
cd ~

# Clone librdkafka from github
git clone https://github.com/edenhill/librdkafka.git
cd librdkafka
# we need a specific version of this repo.
# i didn't do the research as to why, or know the implications of not doing it
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a

read -p " Note: Ignore any warnings / disables, as long as the command doesn't fail
Please press any key to run configuration (Apache Kafka) : "

# run the config, Note: ignore any warning/disables, as long as the command doesn't fail
./configure
read -p " Check if the command exited succesfully.
Please press any key to continue... : "
# make and install
make
sudo make install


echo "Step 4: Install nvidia and deepstream package"
read -p "Please press any key to continue... : "
# Create the deepstream folder
# copy the files to the deepstream folder
sudo mkdir -p /opt/nvidia/deepstream/deepstream-6.0/lib
sudo cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-6.0/lib

echo "   Installing latest NVIDIA packages"

# Installing latest NVIDIA packages (reinstall specifically)
sudo apt install --reinstall nvidia-l4t-gstreamer
sudo apt install --reinstall nvidia-l4t-multimedia
sudo apt install --reinstall nvidia-l4t-core

echo "   Install DeepStream package, from folder /deepsteam-6.0.1"
# install deepstream from package (approx 600mb)

sudo apt install /deepstream-6.0.1/deepstream-6.0_6.0.1-1_arm64.deb
echo "Step 5: Testrun deepstream example to ensure succesful installation"
read -p "Please press any key to continue... : "
deepstream-app -c /opt/nvidia/deepstream/deepstream-6.0/samples/configs/deepstream-app/source8_1080p_dec_infer-resnet_tracker_tiled_display_fp16_nano.txt 
echo "Deepstream 6.0.1 Installation completed."
