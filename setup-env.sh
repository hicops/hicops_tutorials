#!/bin/bash -le

#
# Automated HiCOPS development environment setup
# Copyrights(C) 2020 PCDS Laboratory
# Muhammad Haseeb and Fahad Saeed
# School of Computing and Information Sciences
# Florida International University (FIU), Miami, FL
# Email: {mhaseeb, fsaeed}@fiu.edu
#

# print usage
function usage() {
    echo "USAGE: setup-env.sh [WORKING_DIR] [SPACK_ENV_NAME]"
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

#
# Environment name
#
SPACK_ENV=$2
# if no environment name is provided
if [ -z "$2" ] ; then 
    echo "ERROR: Please provide a name for the spack environment"
    usage
    exit 0
fi

#
# Clone spack if does not exist
#
if [ ! -d "${WDIR}/spack" ] ; then
    pushd $WDIR
    git clone https://github.com/spack/spack.git
    popd

    # Set the default MPI distribution to mpich
    sed -i "s/openmpi, mpich/mpich, openmpi/g" $WDIR/spack/etc/spack/defaults/packages.yaml

    #
    # Optional
    #

    # Set the $WDIR/spack/etc/spack/defaults/config.yaml
    # build_stage:
    #   - ~/spack-stage
    #   - ~/.spack/stage
    #  # - $spack/var/spack/stage
    
    # Uncomment the following line:
    # build_jobs: 16 (set it acc to your system)
fi

#
# wait and sync
#
wait
sync

# setup environment
export PATH=$WDIR/spack/bin:$PATH
. $WDIR/spack/share/spack/setup-env.sh

# find all compilers
spack compiler find

#
# Function containing packages
#
function packages() {
    #
    # Timemory dependencies only
    #
    spack install --only dependencies timemory@develop%gcc@10.2.0 +mpi +mpip_library +ompt +papi +dyninst +python +python_deps +tools +upcxx +examples +ompt_library   +gotcha

    #
    # HDF5 and GasNet-EX
    #
    spack install hdf5%gcc@10.2.0 +cxx +hl +mpi +shared +szip +threadsafe
    spack install gasnet%gcc@10.2.0 +ibv

    #
    # Additional required packages
    #
    spack install cmake%gcc@10.2.0
    spack install py-setuptools-scm%gcc@10.2.0
    spack install py-kiwisolver%gcc@10.2.0
    spack install py-python-dateutil%gcc@10.2.0
    spack install pkgconf%gcc@10.2.0
    spack install py-numexpr%gcc@10.2.0
    spack install py-setuptools%gcc@10.2.0
    spack install py-et-xmlfile%gcc@10.2.0
    spack install py-bottleneck%gcc@10.2.0
    spack install py-jdcal%gcc@10.2.0
    spack install py-pyparsing%gcc@10.2.0
    spack install py-cython%gcc@10.2.0
    spack install py-pandas%gcc@10.2.0
    spack install py-subprocess32%gcc@10.2.0
    spack install py-cycler%gcc@10.2.0
    spack install py-openpyxl%gcc@10.2.0
    spack install py-six%gcc@10.2.0
    spack install py-argparse%gcc@10.2.0
    spack install py-matplotlib%gcc@10.2.0
    spack install py-pytz%gcc@10.2.0
    spack install py-pip%gcc@10.2.0

    # wait and sync
    sync
    wait
}

#
# Install packages at spack root level
#
packages

#
# Create and activate a spack environment
#
spack env create ${SPACK_ENV}
spack env activate ${SPACK_ENV}

# Add packages to the environment
packages

#
# Load the spack environment again
#
spack env activate ${SPACK_ENV}

#
# export MPLCONFIGDIR
#
mkdir -p $HOME/mplconfigdir
export MPLCONFIGDIR=$HOME/mplconfigdir
