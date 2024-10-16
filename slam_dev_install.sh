# tbb
sudo apt install libtbb-dev

# yaml-cpp
sudo apt-get install libyaml-cpp-dev

# Ceres (include glog, eigen)
sudo apt-get install -y cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
CERES_VERSION="2.0.0"
git clone https://ceres-solver.googlesource.com/ceres-solver
cd ceres-solver
git checkout tags/${CERES_VERSION}
mkdir build && cd build
cmake ..
make

# Sophus
git clone https://github.com/strasdat/Sophus

# TODO: Pangolin 
