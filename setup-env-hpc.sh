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
    echo "IMPORTANT: Before running this script, make sure to add your MPI system module (from Lmod) along with other "
    echo "           recommended modules to packages.yaml file to ensure correct & faster installation. Please see the "
    echo "           README.md file for more information. "
    echo "                     "

    echo "USAGE: setup-env.sh [WORKING_DIR] [SPACK_ENV_NAME] [optional COMPILER: e.g. gcc@8.4.0, gcc@10.2.0, intel@10.2]"
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

COMPILER=$3
# if not provided
if [ -z "$3" ] ; then
    echo "No compiler provided. Trying to use the latest available"
fi

#
# Clone spack if does not exist
#
if [ ! -d "${WDIR}/spack" ] ; then
    pushd $WDIR
    git clone https://github.com/spack/spack.git
    popd
fi

#
# wait and sync
#
wait
sync

# setup environment
export PATH=$WDIR/spack/bin:$PATH
source $WDIR/spack/share/spack/setup-env.sh

# if compiler not provided
if [ -z $COMPILER ] ; then
    # find all compilers if needed
    spack compiler find
    spack compilers
else
    COMPILER=%$COMPILER
fi

# Copy packages.yaml to Spack
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cp $SCRIPT_DIR/packages.yaml $WDIR/spack/etc/spack/packages.yaml


#
# Function containing required packages
#
function packages() {

    #
    # Timemory dependencies only
    #
    spack install --only dependencies timemory@3.1.0${COMPILER} +mpi +mpip_library +papi +dyninst +python +tools +examples

    #
    # Additional required packages
    #
    spack install cmake${COMPILER}
    spack install py-setuptools-scm${COMPILER}
    spack install py-kiwisolver${COMPILER}
    spack install py-python-dateutil${COMPILER}
    spack install pkgconf${COMPILER}
    spack install py-numexpr${COMPILER}
    spack install py-setuptools${COMPILER}
    spack install py-et-xmlfile${COMPILER}
    spack install py-bottleneck${COMPILER}
    spack install py-jdcal${COMPILER}
    spack install py-pyparsing${COMPILER}
    spack install py-cython${COMPILER}
    spack install py-pandas${COMPILER}
    spack install py-subprocess32${COMPILER}
    spack install py-cycler${COMPILER}
    spack install py-openpyxl${COMPILER}
    spack install py-six${COMPILER}
    spack install py-argparse${COMPILER}
    spack install py-matplotlib${COMPILER}
    spack install py-pytz${COMPILER}
    spack install py-pip${COMPILER}

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

# simple slurm is needed for expanse
pip install simple-slurm

#
# export MPLCONFIGDIR
#
mkdir -p $HOME/mplconfigdir
export MPLCONFIGDIR=$HOME/mplconfigdir
