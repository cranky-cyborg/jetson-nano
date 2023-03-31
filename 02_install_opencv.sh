#!/bin/bash

echo "
The purpose of this script is to install OpenCV on Jetson Nano
NOTE: this is an Interactive script, that needs attention and installation will take a few hours

Credit: Adapted from https://qengineering.eu/install-opencv-4.5-on-jetson-nano.html"

# remove old versions or previous builds
cd ~ 
sudo rm -rf opencv*

echo "Step 1: Determine OpenCV version to install"

read -p "Choose an option from below:
      1 ) Install OpenCV version 4.6.0
      2 ) Install OpenCV version 4.7.0
   Please enter 1 or 2, alternatively CTRL+C to cancel: " opCV
if [[ $opCV -eq 1 ]] 
then
  echo "Installing OpenCV 4.6.0"
  # download version 4.6.0
  wget -O opencv.zip https://github.com/opencv/opencv/archive/4.6.0.zip 
  wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.6.0.zip 
  unzip opencv.zip 
  unzip opencv_contrib.zip 
  mv opencv-4.6.0 opencv
  mv opencv_contrib-4.6.0 opencv_contrib
elif [[ $opCV -eq 2 ]] 
then
  echo "Installing OpenCV 4.7.0"
  # download version 4.7.0
  wget -O opencv.zip https://github.com/opencv/opencv/archive/4.7.0.zip 
  wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.7.0.zip 
  unzip opencv.zip 
  unzip opencv_contrib.zip 
  mv opencv-4.7.0 opencv
  mv opencv_contrib-4.7.0 opencv_contrib
else
  echo "unknown option, exiting script"
  exit 1
fi

echo "Step 2: Building and Installing OpenCV"

read -p "Press any key to continue... :"
# clean up the zip files
rm opencv.zip
rm opencv_contrib.zip

# set install dir
cd ~/opencv
mkdir build
cd build

# run cmake
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr \
-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
-D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
-D WITH_OPENCL=OFF \
-D WITH_CUDA=ON \
-D CUDA_ARCH_BIN=5.3 \
-D CUDA_ARCH_PTX="" \
-D WITH_CUDNN=ON \
-D WITH_CUBLAS=ON \
-D ENABLE_FAST_MATH=ON \
-D CUDA_FAST_MATH=ON \
-D OPENCV_DNN_CUDA=ON \
-D ENABLE_NEON=ON \
-D WITH_QT=OFF \
-D WITH_OPENMP=ON \
-D BUILD_TIFF=ON \
-D WITH_FFMPEG=ON \
-D WITH_GSTREAMER=ON \
-D WITH_TBB=ON \
-D BUILD_TBB=ON \
-D BUILD_TESTS=OFF \
-D WITH_EIGEN=ON \
-D WITH_V4L=ON \
-D WITH_LIBV4L=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
-D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D BUILD_EXAMPLES=ON ..

# run make
NO_JOB=6
make -j ${NO_JOB} 

sudo rm -rf /usr/include/opencv4/opencv2
sudo make install
sudo ldconfig

# cleaning (frees 300 MB)
make clean
sudo apt-get update

tmpfile=$(mktemp --suffix=.py) 
cat << EOF > $tmpfile
import cv2
print(cv2.__version__)
EOF

cv_version=$(python3 $tmpfile)
echo "installed OpenCV $cv_version, if no version is shown then the installtion errored out"
