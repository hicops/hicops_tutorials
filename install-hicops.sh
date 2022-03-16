#!/bin/bash -le

#
# Automated HiCOPS and Timemory Install
# Copyrights(C) 2022 PCDS Laboratory
# Muhammad Haseeb and Fahad Saeed
# School of Computing and Information Sciences
# Florida International University (FIU), Miami, FL
# Email: {mhaseeb, fsaeed}@fiu.edu
#

# print usage
function usage() {
    echo "USAGE: source install-hicops.sh [WORKING_DIR]"
}

#
# Working directory
#
WDIR=$1
# if no working directory is provided
if [ -z "$1" ] ; then 
    echo "ERROR: Please provide the path to working directory"
    usage
    exit 0
fi

# convert relative path to abs path if needed
WDIR=$(cd "$WDIR" && pwd -P)


# go to the working directory
cd $WDIR

#
# Clone timemory if does not exist
#
if [ ! -d "${WDIR}/timemory" ] ; then
    git clone https://github.com/NERSC/timemory.git
fi

# go to timemory directory
pushd $WDIR/timemory

# checkout v3.1.0
git checkout v3.1.0
git submodule update --init
rm -rf build-auto
mkdir -p build-auto
cd build-auto

# configure
cmake .. -DTIMEMORY_USE_MPI=ON -DTIMEMORY_BUILD_MPIP_LIBRARY=ON -DTIMEMORY_USE_GOTCHA=ON -DCMAKE_INSTALL_PREFIX=../install-auto -DCMAKE_CXX_STANDARD=17 -DTIMEMORY_USE_PYTHON=ON -DTIMEMORY_BUILD_TOOLS=ON -DTIMEMORY_USE_PAPI=ON

# install timemory
make install -j 16

# export relevant paths

export PATH=$PWD:$PATH
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
export PYTHONPATH=$PWD:$PYTHONPATH

cd ../install-auto
export CMAKE_PREFIX_PATH=$PWD:$CMAKE_PREFIX_PATH

popd

#
# Clone hicops if does not exist
#
if [ ! -d "${WDIR}/hicops" ] ; then
    git clone https://github.com/hicops/hicops.git
fi

# go to hicops directory
pushd $PWD/hicops
git submodule update --init
rm -rf build-auto-inst
mkdir -p build-auto-inst
cd build-auto-inst

# configure and install with instr
cmake .. -DUSE_MPI=ON -DUSE_TIMEMORY=ON -DUSE_MPIP_LIBRARY=ON -DCMAKE_INSTALL_PREFIX=../install-build-auto-inst 
make install -j 16

cd ..

rm -rf build-auto-no-inst
mkdir -p build-auto-no-inst
cd build-auto-no-inst

# configure and install without instr
cmake .. -DUSE_MPI=ON -DUSE_TIMEMORY=OFF -DUSE_MPIP_LIBRARY=OFF -DCMAKE_INSTALL_PREFIX=../install-build-auto-no-inst 
make install -j 16

popd
