# jetson-nano

packages needed for Docker container to support RTSP client

> sudo apt update

> sudo apt upgrade

> sudo apt install python3-testresources python3-pip gstreamer-1.0 gstreamer1.0-dev python3-gi python3-gst-1.0 libgirepository1.0-dev libcairo2-dev gir1.2-gstreamer-1.0 gir1.2-gst-rtsp-server-1.0

> python3 -m pip install --upgrade pip

> python3 -m pip install scikit-build

wget https://github.com/RinCat/RTL88x2BU-Linux-Driver/archive/master.zip
unzip master.zip
cd RTL88x2BU-Linux-Driver-master
make
sudo make install
sudo modprobe 88x2bu rtw_switch_usb_mode=1

sudo chmod 666 /var/run/docker.sock
