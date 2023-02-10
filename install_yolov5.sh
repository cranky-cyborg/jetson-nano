#!/bin/bash

cd ~

sudo apt update

sudo apt install -y python3-pip 
python3 -m pip install --upgrade pip

#depencencies needed for Docker to run RTSP client
sudo apt install -y  python3-testresources gstreamer-1.0 gstreamer1.0-dev python3-gi python3-gst-1.0 libgirepository1.0-dev libcairo2-dev gir1.2-gstreamer-1.0 gir1.2-gst-rtsp-server-1.0 libcanberra-gtk-module libcanberra-gtk3-module
#other dependencies
sudo apt install -y libfreetype6-dev tensorrt

#install DeepStream

#this is for latest DeepSteam 6.2
#sudo apt install -y libssl1.1 libjansson4 libyaml-cpp-dev

#for deepstream 6.0.1
sudo apt install -y libssl1.0.0 libjansson4=2.11-1

sudo apt install -y libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 


# -- install kafka
git clone https://github.com/edenhill/librdkafka.git
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a
./configure
make
sudo make install

sudo mkdir -p /opt/nvidia/deepstream/deepstream-6.0/lib

sudo cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-6.0/lib

sudo apt update
sudo apt install --reinstall nvidia-l4t-gstreamer
sudo apt install --reinstall nvidia-l4t-multimedia
sudo apt install --reinstall nvidia-l4t-core


# install deepstream (package)

sudo apt install /media/${USER}/drivers/deepstream-6.0_6.0.1-1_arm64.deb


#time to yolo v5

git clone https://github.com/pawangonnakuti/yolov5-jetson-nano.git yolov5

cd yolov5

#cp requirements.txt requirements.txt.bkup

#sed -i 's/^torch>=1.7.0/#torch>=1.7.0/' requirements.txt
#sed -i 's/^torchvision>=0.8.1/#torchvision>=0.8.1/' requirements.txt



python3 -m pip install -r requirements.txt

cd ~

#install PyTorch
sudo apt-get install -y libopenblas-base libopenmpi-dev libjpeg-dev zlib1g-dev libpng-dev

export OPENBLAS_CORETYPE=ARMV8 | tee -e ~/.bashrc

wget https://nvidia.box.com/shared/static/fjtbno0vpo676a25cgvuqc1wty0fkkg6.whl -O torch-1.10.0-cp36-cp36m-linux_aarch64.whl

python3 -m pip install torch-1.10.0-cp36-cp36m-linux_aarch64.whl

sudo apt install -y 

#install TorchVision
sudo apt install -y libjpeg-dev zlib1g-dev
git clone --branch v0.11.1 https://github.com/pytorch/vision torchvision
cd torchvision
sudo python3 setup.py install 





#build deepSteam-yolo
cd ~
git clone https://github.com/marcoslucianops/DeepStream-Yolo


cp DeepStream-Yolo/utils/gen_wts_yoloV5.py yolov5

cd yolov5
wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5s.pt

#other pt files 
wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5s6.pt
wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5n.pt
wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5n6.pt

python3 gen_wts_yoloV5.py -w yolov5s.pt -s 1280

cp yolov5s.cfg ~/DeepStream-Yolo
cp yolov5s.wts ~/DeepStream-Yolo

cd ~/DeepStream-Yolo
CUDA_VER=10.2 make -C nvdsinfer_custom_impl_Yolo

# if you change the pt file from yolov5s.pt to something else.
# you will need to change config_infer_primary_yoloV5.txt file as per below
#> [property]
#> ...
#> custom-network-config=yolov5s.cfg
#> model-file=yolov5s.wts
#> ...


# edit the Edit the deepstream_app_config file
#> ...
#> [primary-gie]
#> ...
#> config-file=config_infer_primary_yoloV5.txt

# Change the video source in deepstream_app_config file. Here a default video file is loaded as you can see below

#> ...
#> [source0]
#> ...
#> uri=file:///opt/nvidia/deepstream/deepstream/samples/streams/sample_1080p_h264.mp4


# run the inference

deepstream-app -c deepstream_app_config.txt
