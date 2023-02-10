#!/bin/bash

cd ~

sudo apt update

sudo apt install -y python3-pip
pip3 install --upgrade pip

git clone https://github.com/ultralytics/yolov5

cd yolov5

cp requirements.txt requirements.txt.bkup

sed -i 's/^torch>=1.7.0/#torch>=1.7.0/' requirements.txt
sed -i 's/^torchvision>=0.8.1/#torchvision>=0.8.1/' requirements.txt

sudo apt install -y libfreetype6-dev

python3 -m pip install -r requirements.txt

cd ~

#install PyTorch
sudo apt-get install -y libopenblas-base libopenmpi-dev

wget https://nvidia.box.com/shared/static/fjtbno0vpo676a25cgvuqc1wty0fkkg6.whl -O torch-1.10.0-cp36-cp36m-linux_aarch64.whl

python3 -m pip install torch-1.10.0-cp36-cp36m-linux_aarch64.whl

sudo apt install -y libjpeg-dev zlib1g-dev

#install TorchVision
sudo apt install -y libjpeg-dev zlib1g-dev
git clone --branch v0.11.1 https://github.com/pytorch/vision torchvision
cd torchvision
sudo python3 setup.py install 

#install DeepStream
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
