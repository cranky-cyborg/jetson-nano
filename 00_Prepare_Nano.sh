#!/bin/bash
 
echo "
The purpose of this script is to remove unnecessary Ubuntu packages, unnecessary
to run ML/AI/CNN/CUDA and others. and make general changes that will make the
development life easy.

NOTE: this is an Interactive script, that needs attention"

assume_yes=false
if [[ $1 =~ ^-[Aa]$ ]]
then
	echo "-a used: Assuming Yes to all prompts"
	assume_yes=true
fi
echo "Step 1: Remove sudo command from asking password again for '${USER}'"
echo "        This change is for Command line only"
#echo "        Enter (Y)es to confirm, or (N)o to skip : "
while true; do
  if [ $assume_yes == true ]
  then
  	yn="y"
  else
  	read -p "        Enter (Y)es to confirm, or (N)o to skip : " yn
  fi
  
  case $yn in
    [Yy]* ) echo " 
${USER} ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
      break;;
    [Nn]* ) exit;;
    * ) echo "         >> Invalid Input, try again!";;
  esac
done

#-------------------------------------------------------------------------
echo "Step 2: Remove Libre Office suite, Email-client, Games, "
echo "        Music players,  Non-english fonts & Utilities. "
echo " Utilities - (Todo, Yelp, scan, backup, onboard, xterm, shotwell,
   Bit-torrent,)"
while true; do
  if [ $assume_yes == true ]
  then
  	asn="a"
  else
  	read -p "        Enter (A)ll to remove all, or (S)elective to selectively
  remove, or (N)o to remove nothing : " asn
  fi
  
  case $asn in
    [AaSs]* ) echo "Lets select : "
      if [[ $asn =~ ^[Ss]$ ]]
      then
 #       read -p "   >> Remove Python2               [Y/N] : " ynPy
        read -p "   >> Remove Libre Office suite    [Y/N] : " ynLibre
        read -p "   >> Remove Email-client          [Y/N] : " ynEmail
        read -p "   >> Remove All Games & Music     [Y/N] : " ynGames
        read -p "   >> Remove Bit-torrent clients   [Y/N] : " ynBittorrent
        read -p "   >> Remove Non-english fonts     [Y/N] : " ynFonts
        read -p "   >> Remove Utilities             [Y/N] : " ynUtils
      fi
	break;;
    [Nn]* ) exit;;
    * ) echo "         >> Invalid Input, try again!";;
  esac
done

  # remove python
#  if [[ $asn =~ ^[Aa]$ || $ynPy =~ ^[Yy]$ ]]
#  then
#    sudo apt-get remove -y python2* python libpython2* python-dev python-minimal
#  fi

  # remove Libre Office suite
  if [[ $asn =~ ^[Aa]$ || $ynLibre =~ ^[Yy]$ ]]
  then
    sudo apt remove -y libreoffice-writer libreoffice-impress libreoffice-math libreoffice-calc libreoffice-base-core libreoffice-core libreoffice-common libdjvulibre21 libdjvulibre-text uno-libs3
  fi

  # remove Email-client
  if [[ $asn =~ ^[Aa]$ || $ynEmail =~ ^[Yy]$ ]]
  then
    sudo apt remove -y thunderbird
  fi

  # remove All Games
  if [[ $asn =~ ^[Aa]$ || $ynGames =~ ^[Yy]$ ]]
  then
    sudo apt remove -y aisleriot compton gnome-mahjongg gnome-mines gnome-sudoku rhythmbox lxmusic
  fi

  # remove Non-english fonts
  if [[ $asn =~ ^[Aa]$ || $ynFonts =~ ^[Yy]$ ]]
  then
    sudo apt remove -y fonts-lohit-beng-bengali fonts-lohit-deva fonts-lohit-gujr fonts-lohit-guru fonts-lohit-knda fonts-lohit-mlym fonts-lohit-orya fonts-lohit-taml fonts-lohit-taml-classical fonts-lohit-telu
  fi

  # remove Utilities
  if [[ $asn =~ ^[Aa]$ || $ynUtils =~ ^[Yy]$ ]]
  then
    sudo apt remove -y gpicview xterm simple-scan shotwell deja-dup gnome-todo yelp onboard leafpad transmission-common
  fi

echo "Cleaning-up orphaned packages"
sudo apt -y autoremove

#-------------------------------------------------------------------------
echo "Step 3: Update and download Ubuntu's Package Library"
echo "        This step requires internet connectivity and take 45 to 60mins"
echo " "
#read -p " Please press any key to continue... : "

sudo apt update --yes 
sudo apt upgrade --yes --download-only

echo "DeepStream: Install dependencies from repositories"
echo "  dependencies are libssl, libjansson, nvidia-jetpack and multiple gstreamer libraries
"
#removing nvidia-container-csv-tensorrt as there is an issue installing nvidia-container, this package will be reinstalled.
sudo apt remove --yes nvidia-container-csv-tensorrt

sudo apt install --yes --download-only \
 build-essential cmake pkg-config zlib1g-dev \
 libjpeg-dev libjpeg8-dev libjpeg-turbo8-dev libpng-dev libtiff-dev \
 libavcodec-dev libavformat-dev libswscale-dev libglew-dev \
 libgtk-3-dev libcanberra-gtk3* \
 libxvidcore-dev libx264-dev libgtk-3-dev \
 libtbb2 libtbb-dev libdc1394-22-dev libxine2-dev \
 gstreamer1.0-tools libv4l-dev v4l-utils qv4l2 \
 libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev \
 libavresample-dev libvorbis-dev libxine2-dev libtesseract-dev \
 libfaac-dev libmp3lame-dev libtheora-dev libpostproc-dev \
 libopencore-amrnb-dev libopencore-amrwb-dev \
 libopenblas-dev libopenblas-base libopenmpi-dev libatlas-base-dev libblas-dev \
 liblapack-dev liblapacke-dev libeigen3-dev gfortran \
 libhdf5-dev protobuf-compiler \
 libprotobuf-dev libgoogle-glog-dev libgflags-dev \
 python3-dev python3-numpy python3-pip python3-venv \
 libfreetype6-dev tensorrt zlib1g-dev  \
 libssl1.0.0 libjansson4=2.11-1 libssl-dev liblz4-dev libsasl2-dev \
 libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
 gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 \
 nvidia-jetpack nvidia-container nvidia-container-csv-tensorrt zram-config nano

echo "Step 4: remove TP-link wifi kernel drivers for Kernel Upgrade"
echo "        Note: Drivers will need to be recompiled."
echo " "
if [ $assume_yes == true ]
then
    ynMod="y"
else
    read -p "   >> Remove Kernel Module 88x2bu  [Y/N] : " ynMod
fi

if [[ $ynMod =~ ^[Yy]$ ]]
  then
    if [ -f /drivers/install-RTL88x2BU.sh 
    then
    cd ~/drivers/RTL88x2BU-Linux-Driver-master/
    sudo modprobe -r 88x2bu
    sudo rmmod 88x2bu
    sudo make uninstall
    sudo make clean
    #sudo rm -f /lib/modules/4.9.253-tegra/kernel/drivers/net/wireless/88x2bu.ko
    
    cd ~
    rm -rf ~/drivers/RTL88x2BU-Linux-Driver-master
    fi
fi

echo "Step 5: Upgrade Ubuntu Kernel, Firmware and other packages"
echo "        Note: Kernel / Firmware upgrade is interactive"
echo "        Note: Docker package upgrade is interactive"
echo " "
if [ $assume_yes == false ]
then
  read -p " Please press any key to continue... : "
fi

sudo apt install --yes --assume-yes --no-download --ignore-missing \
 build-essential cmake pkg-config zlib1g-dev \
 libjpeg-dev libjpeg8-dev libjpeg-turbo8-dev libpng-dev libtiff-dev \
 libavcodec-dev libavformat-dev libswscale-dev libglew-dev \
 libgtk-3-dev libcanberra-gtk3* \
 libxvidcore-dev libx264-dev libgtk-3-dev \
 libtbb2 libtbb-dev libdc1394-22-dev libxine2-dev \
 gstreamer1.0-tools libv4l-dev v4l-utils qv4l2 \
 libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev \
 libavresample-dev libvorbis-dev libxine2-dev libtesseract-dev \
 libfaac-dev libmp3lame-dev libtheora-dev libpostproc-dev \
 libopencore-amrnb-dev libopencore-amrwb-dev \
 libopenblas-dev libopenblas-base libopenmpi-dev libatlas-base-dev libblas-dev \
 liblapack-dev liblapacke-dev libeigen3-dev gfortran \
 libhdf5-dev protobuf-compiler \
 libprotobuf-dev libgoogle-glog-dev libgflags-dev \
 python3-dev python3-numpy python3-pip python3-venv \
 libfreetype6-dev tensorrt zlib1g-dev  \
 libssl1.0.0 libjansson4=2.11-1 libssl-dev liblz4-dev libsasl2-dev \
 libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
 gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 \
 nvidia-jetpack nvidia-container nvidia-container-csv-tensorrt zram-config nano

sudo apt upgrade --yes --assume-yes --no-download --ignore-missing

sudo apt autoremove --yes

sudo apt clean

echo "Step 6: Permission changes are required to run Docker service ( know workaround )"
echo " "

sudo usermod -aG docker ${USER} 
sudo chmod 666 /var/run/docker.sock

echo "Step 7: Increasing Swap Space (by 4 times)"
echo " "

#increase zram multiplier from /2 to *2 (i.e. from 2GB to 8GB, for 4GB model/ram).
sudo sed -i 's|totalmem / 2|totalmem * 2|g' /usr/bin/init-zram-swapping

echo "Step 8: The system will now reboot"
echo " "
if [ $assume_yes == true ]
then
  ynReboot="y"
else
  read -p "   >> Reboot operating system      [Y/N] : " ynReboot
fi

if [[ $ynReboot =~ ^[Yy]$ ]]
then
  sudo reboot
fi
