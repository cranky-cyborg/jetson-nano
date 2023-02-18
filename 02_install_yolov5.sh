#!/bin/bash

cd ~

sudo apt update

sudo apt install -y python3-pip python3-venv libfreetype6-dev tensorrt libopenblas-base libopenmpi-dev libjpeg-dev zlib1g-dev libpng-dev
python3 -m pip install --upgrade pip

#set environment variable
echo 'export OPENBLAS_CORETYPE=ARMV8' | tee -a ~/.bashrc
export OPENBLAS_CORETYPE=ARMV8

#create Python Virtual Environment
cd ~
python3 -m venv ve-yolov5 --system-site-packages

#activate Py Virtual Env
source ~/ve-yolov5/bin/activate

#update pip and other modules
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools
python3 -m pip install wheel

#update all pip packages
python3 -m pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 python3 -m pip install -U

# yolo v5
git clone https://github.com/pawangonnakuti/yolov5.git yolov5

cd ~/yolov5

# i've edited requirements.txt in my repo, if using any other repo you will need to comment torch ad torchvision
#cp requirements.txt requirements.txt.bkup

#sed -i 's/^torch>=1.7.0/#torch>=1.7.0/' requirements.txt
#sed -i 's/^torchvision>=0.8.1/#torchvision>=0.8.1/' requirements.txt

# install requirements.
python3 -m pip install -r requirements.txt

# make sure there are no errors in the installment.

cd ~

#install PyTorch

wget https://nvidia.box.com/shared/static/fjtbno0vpo676a25cgvuqc1wty0fkkg6.whl -O torch-1.10.0-cp36-cp36m-linux_aarch64.whl

python3 -m pip install torch-1.10.0-cp36-cp36m-linux_aarch64.whl

#install TorchVision (0.11.3 is the latest torchvision, the NVidia website refers to 0.11.1)
git clone --branch v0.11.3 https://github.com/pytorch/vision torchvision
cd ~/torchvision

#below step is going to take some time.
sudo python3 setup.py install 

#build deepSteam-yolo
cd ~
git clone https://github.com/pawangonnakuti/DeepStream-Yolo

cp ~/DeepStream-Yolo/utils/gen_wts_yoloV5.py ~/yolov5

cd ~/yolov5

wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5n.pt

#other pt files
wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5n6.pt
wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5s6.pt
wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5s.pt


python3 gen_wts_yoloV5.py -w yolov5n.pt -s 1280

cp yolov5n.cfg ~/DeepStream-Yolo
cp yolov5n.wts ~/DeepStream-Yolo

cd ~/DeepStream-Yolo
CUDA_VER=10.2 make -C nvdsinfer_custom_impl_Yolo

# if you change the pt file from yolov5s.pt to something else.
# you will need to change config_infer_primary_yoloV5.txt file as per below
#> [property]
#> ...
#> custom-network-config=yolov5s.cfg
#> model-file=yolov5s.wts
#> ...

#if the configuration needs to change then the below script can be used.
#sed -i 's/^custom-network-config=yolov5s.cfg/custom-network-config=yolov5s.cfg/' config_infer_primary_yoloV5.txt
#sed -i 's/^model-file=yolov5s.wts/model-file=yolov5s.wts' config_infer_primary_yoloV5.txt

# edit the Edit the deepstream_app_config file
#> ...
#> [primary-gie]
#> ...
#> config-file=config_infer_primary_yoloV5.txt

#changing the primary inference file to config_infer_primary_yoloV5.txt
sed -i 's/^config-file=config_infer_primary.txt/config-file=config_infer_primary_yoloV5.txt/' deepstream_app_config.txt

# Change the video source in deepstream_app_config file. Here a default video file is loaded as you can see below

#> ...
#> [source0]
#> ...
#> uri=file:///opt/nvidia/deepstream/deepstream/samples/streams/sample_1080p_h264.mp4

#we will not change the source / uri for now, lets just run this.

# run the inference

deepstream-app -c deepstream_app_config.txt
