# jetson-nano

packages needed for Docker container to support RTSP client

> sudo apt update

> sudo apt upgrade

> sudo apt install tensorrt python3-testresources python3-pip gstreamer-1.0 gstreamer1.0-dev python3-gi python3-gst-1.0 libgirepository1.0-dev libcairo2-dev gir1.2-gstreamer-1.0 gir1.2-gst-rtsp-server-1.0 libcanberra-gtk-module libcanberra-gtk3-module

> python3 -m pip install --upgrade pip

> python3 -m pip install scikit-build

# wifi driver (https://github.com/RinCat/RTL88x2BU-Linux-Driver)

>wget https://github.com/RinCat/RTL88x2BU-Linux-Driver/archive/master.zip

>unzip master.zip

>cd RTL88x2BU-Linux-Driver-master

>make

>sudo make install

>sudo modprobe 88x2bu rtw_switch_usb_mode=1

>sudo chmod 666 /var/run/docker.sock

# remove LibreOffice
 
> sudo apt remove libreoffice-writer libreoffice-impress libreoffice-math libreoffice-calc libreoffice-base-core libreoffice-core libreoffice-common libdjvulibre21 libdjvulibre-text 


# remove games

> sudo apt remove aisleriot compton gnome-mahjongg gnome-mines gnome-sudoku leafpad thunderbird ibus-table transmission-common rhythmbox lxmusic 


> sudo apt remove fonts-lohit-beng-bengali fonts-lohit-deva fonts-lohit-gujr fonts-lohit-guru fonts-lohit-knda fonts-lohit-mlym fonts-lohit-orya fonts-lohit-taml fonts-lohit-taml-classical fonts-lohit-telu

> sudo apt autoremove

# setup swap / zram to be specific

> sudo apt install zram-config

# docker config

> sudo usermod -aG docker ${USER}
> sudo chmod 666 /var/run/docker.sock



