# <img src="https://user-images.githubusercontent.com/14217455/97767279-84a86100-1af1-11eb-92db-52edf709cb1f.png" width="100" valign="middle" alt="HiCOPS"/> hicops-tutorials
Walk-through tutorials for [HiCOPS](https://github.com/hicops/hicops) ([Docs](https://hicops.github.io)) installation, instrumentation, integration and execution.


# Quick Setup (no instrumentation support)

* Install/load the following packages along with other common Python packages.   

```bash
mpi, cmake, python, py-pip, py-numpy, py-pandas, py-openpyxl, py-datetime, py-argparse, py-matplotlib, py-math, py-subprocess32, py-shutil, py-filecmp, simple-slurm
```  

**Note:** If you run into a Python's `ImportError` while using HiCOPS, simply install that package by running:   

```bash
$ pip install <package-name>
```

* Clone the default HiCOPS' GitHub repository     

```bash
$ git clone https://github.com/hicops/hicops
```

For GPU-Accelerated HiCOPS, clone:

```bash
$ git clone https://github.com/mhaseeb123/hicops
$ cd hicops ; git checkout -b gpu-hicops
$ git fetch --all
$ git pull --set-upstream origin/gpu-hicops gpu-hicops ; git pull
```

For SGCI-supported HiCOPS, clone:

```bash
$ git clone https://github.com/mhaseeb123/hicops
$ cd hicops ; git checkout -b sgci
$ git fetch --all
$ git pull --set-upstream origin/sgci sgci ; git pull
```

* Assuming that HiCOPS has been cloned into `$HICOPS_DIR`, use CMake to configure and install HiCOPS like as follows:   

```bash
$ cd $HiCOPS_DIR ; mkdir build-no-inst; cd build-no-inst
$ cmake .. -DCMAKE_INSTALL_PREFIX=../install-no-inst -DUSE_MPI=ON && make install -j 8
```

* Export HiCOPS installation paths to your system paths to use it from anywhere   

```bash
$ cd $HiCOPS_DIR/install-no-inst
$ export hicops_PATH=$PWD 

$ export PATH=${hicops_PATH}/bin:${hicops_PATH}/tools/dbtools:${hicops_PATH}/tools/ms2prep:${hicops_PATH}/bin/tools:$PATH
$ export LD_LIBRARY_PATH=$hicops_PATH/lib:$LD_LIBRARY_PATH
```
```

# Full Setup

## Environment Setup (Supercomputer)

* Most supercomputers come with several essential software and packages compiled specifically for their system settings. These packages are often provided via a package manager, most commonly, Lmod. Since HiCOPS is built using `MPI` and `CUDA`, we will provide their system packages to the `packages.yaml` file. Apart from MPI, the recommended system packages to provide, *if available*, include: `mpip, papi, perl, ncurses, curl`. If one or more of these packages are not available by default, they will automatically be installed as explained later. Using Lmod, you can see the available modules on your supercomputer by running:   

```bash
$ module avail
```

### Example (Setting up MPI on SDSC Expanse)
Running `module avail` on SDSC Expanse revealed that the system has the `openmpi/4.0.4` MPI package installed. Therefore, we will add an entry for `openmpi` in the `packages.yaml` file right under the `mpi` entry like this:   

```yaml
packages:
  mpi:
    buildable: False
  openmpi:
    buildable: False # this package will never be reinstalled and taken from the system module
    externals:
    - spec: "openmpi@4.0.4"
      modules:
      - openmpi/4.0.4
```

**Note:** Setting `buildable: False` is required for `MPI` (and MPI-related) packages, `curl`, and in some cases `CUDA`-related packages to ensure only these system default packages are used.

* Once the `packages.yaml` is all set with system packages, run the following bash script to automatically install all required packages on your supercomputer via `Spack`. `Spack` itself will be installed at `$WORKING_DIR/spack`    

```bash
source ./setup-env-hpc.sh [WORKING_DIR] [(optional) COMPILER: e.g. gcc@8.4.0, gcc@10.2.0, intel@10.2]] # run without any args to see help
```

* Once the installation is complete, run `module avail` again to see all the newly installed packages under a new subsection. For instance:    

```bash
$ module avail
.
.
.
----------------------------------------------------------------------------------------- /home/hicops/repos/spack/share/spack/modules/linux-rocky8-zen2 -----------------------------------------------------------------------------------------
   bzip2-1.0.8-gcc-10.2.0-p7pyqr6          libffi-3.3-gcc-10.2.0-44wrz3l              pkgconf-1.8.0-gcc-10.2.0-qoshsyz            py-openpyxl-3.0.3-gcc-10.2.0-ifa5gae            python-3.8.12-gcc-10.2.0-aw4rhia          
   cmake-3.18.2-gcc-10.2.0-r5ab7lw         libiberty-2.33.1-gcc-10.2.0-7e4q3wu        py-argparse-1.4.0-gcc-10.2.0-55m6xmo        py-packaging-21.0-gcc-10.2.0-snivqqc            qhull-2020.2-gcc-10.2.0-lu6llmy           
   cuda-10.2-gcc-10.2.0-wf4yemz               libiberty-2.37-gcc-10.2.0-w6eacpx          py-certifi-2021.10.8-gcc-10.2.0-tofhg6y     py-pillow-8.0.0-gcc-10.2.0-pzqbsjc              readline-8.1-gcc-10.2.0-s3cope2           
   expat-2.4.1-gcc-10.2.0-qlg33ty          libjpeg-turbo-2.1.0-gcc-10.2.0-ft6kcw6     py-cppy-1.1.0-gcc-10.2.0-ulimker            py-pip-21.1.2-gcc-10.2.0-yssuqqg                sqlite-3.36.0-gcc-10.2.0-rhsfmfn          
   freetype-2.11.0-gcc-10.2.0-dgxzzoq      libmd-1.0.3-gcc-10.2.0-aa4a3m6             py-cycler-0.10.0-gcc-10.2.0-64cfpo4         py-pyparsing-2.4.7-gcc-10.2.0-di3ftip           util-linux-uuid-2.36.2-gcc-10.2.0-pyzqbni 
   gdbm-1.21-gcc-10.2.0-fdw7oos            libmd-1.0.4-gcc-10.2.0-3shnkkc             py-cython-0.29.24-gcc-10.2.0-vb3eh4j        py-python-dateutil-2.8.2-gcc-10.2.0-xtyniau     xz-5.2.5-gcc-10.2.0-fw6lna7               
   gettext-0.21-gcc-10.2.0-rwrgw73         libpng-1.6.37-gcc-10.2.0-34ctsc6           py-et-xmlfile-1.0.1-gcc-10.2.0-llx4jna      py-setuptools-58.2.0-gcc-10.2.0-s7zywen         zlib-1.2.11-gcc-10.2.0-mi7anth            
   gotcha-1.0.3-gcc-10.2.0-ncynvks         nasm-2.15.05-gcc-10.2.0-lixxuae            py-jdcal-1.3-gcc-10.2.0-rhhkkir             py-setuptools-scm-6.3.2-gcc-10.2.0-3wovec3  
   intel-tbb-2020.3-gcc-10.2.0-jptb53w     openssl-1.1.1l-gcc-10.2.0-jgp74iz          py-kiwisolver-1.3.2-gcc-10.2.0-gsbxoqb      py-six-1.16.0-gcc-10.2.0-s66z7et            
   libbsd-0.11.3-gcc-10.2.0-7e7gjsr        openssl-1.1.1l-gcc-10.2.0-vjisbt2          py-mpi4py-3.0.3-gcc-10.2.0-bvgazap          py-subprocess32-3.5.4-gcc-10.2.0-2bsks4i    
   libbsd-0.11.5-gcc-10.2.0-7kg35s7        openssl-1.1.1m-gcc-10.2.0-vc67utm          py-numpy-1.21.3-gcc-10.2.0-m7ebgua          py-tomli-1.2.1-gcc-10.2.0-ih5srud           

```

* Load all newly installed modules using Lmod by running:   

```bash
$ module load <list of modules>
```

**Note:** A good trick is to put the above load command in your `$HOME/.bashrc` file so all modules are automatically loaded at SSH. 


## Environment Setup (Non-Supercomputer/Shared-Memory Computer)

* Run the following bash script to install all required packages using `Spack` and bundling them in an environment. `Spack` itself will be installed at `$WORKING_DIR/spack`    

```bash
source ./setup-env.sh [WORKING_DIR] [SPACK_ENV_NAME] [(optional) COMPILER: e.g. gcc@8.4.0, gcc@10.2.0, intel@10.2]] # Run without parameters to see the help.
```

* Once the `Spack` environment is setup, simply activate it by running:   

```bash
source ./activate.sh [WORKING_DIR] [SPACK_ENV_NAME]
```

## HiCOPS and Timemory Installation

* Run the following bash script after setting up (or activating/loading) your environment to install the timemory and hicops (both with and without instrumentation support)   

```bash
source install-hicops.sh [WORKING_DIR] # run without parameters to see help
```
* The above script will install the following:   
1. timemory at `$WORKING_DIR/timemory/install-auto`  
2. hicops (no instrumentation) at `$WORKING_DIR/hicops/install-no-inst`   
3. hicops (instrumentation) at `$WORKING_DIR/hicops/install-inst`    

* Export HiCOPS and timemory installation paths to your system paths to use them   

```bash
$ export PATH=$WORKING_DIR/timemory/build-auto:$PATH
$ export LD_LIBRARY_PATH=$WORKING_DIR/timemory/build-auto:$LD_LIBRARY_PATH
$ export PYTHONPATH=$WORKING_DIR/timemory/build-auto:$PYTHONPATH
$ export CMAKE_PREFIX_PATH=$HOME/repos/timemory/install-auto:$CMAKE_PREFIX_PATH

$ export timemory_PATH=$WORKING_DIR/timemory/install-auto

$ export hicops_inst_PATH=$WORKING_DIR/hicops/install-inst
$ export hicops_noinst_PATH=$WORKING_DIR/hicops/install-no-inst

$ # export hicops with or without instrumentation by running either 
$ export hicops_PATH=$hicops_inst_PATH 
$ # or 
$ export hicops_PATH=$hicops_noinst_PATH 

$ export PATH=${hicops_PATH}/bin:${hicops_PATH}/tools/dbtools:${hicops_PATH}/tools/ms2prep:${hicops_PATH}/bin/tools:$PATH
$ export LD_LIBRARY_PATH=$hicops_PATH/lib:$LD_LIBRARY_PATH
```


# When launching a new terminal

## Quick Setup
* Make sure that all essential packages are loaded into your environment
* Export HiCOPS' paths

```bash
$ export hicops_noinst_PATH=$WORKING_DIR/hicops/install-noinst
$ export hicops_PATH=$hicops_noinst_PATH 

$ export PATH=${hicops_PATH}/bin:${hicops_PATH}/tools/dbtools:${hicops_PATH}/tools/ms2prep:${hicops_PATH}/bin/tools:$PATH
$ export LD_LIBRARY_PATH=$hicops_PATH/lib:$LD_LIBRARY_PATH
```
## Full Setup

* Setup Spack by running the following:   

```bash
$ export PATH=${SPACK_DIR}/spack/bin:$PATH
$ source ${SPACK_DIR}/spack/share/spack/setup-env.sh
```

* Load all installed packages.

**Supercomputer:** Load all installed and system packages by running:    

```bash
$ module load <list of packages>
```

**Shared-Mem Computer:** Activate the Spack environment by running:   

```bash
$ spack activate env [SPACK_ENV_NAME]
```

* Export timemory and HiCOPS paths.   

```bash
$ export PATH=$WORKING_DIR/timemory/build-auto:$PATH
$ export LD_LIBRARY_PATH=$WORKING_DIR/timemory/build-auto:$LD_LIBRARY_PATH
$ export PYTHONPATH=$WORKING_DIR/timemory/build-auto:$PYTHONPATH
$ export CMAKE_PREFIX_PATH=$HOME/repos/timemory/install-auto:$CMAKE_PREFIX_PATH

$ export timemory_PATH=$WORKING_DIR/timemory/install-auto

$ export hicops_inst_PATH=$WORKING_DIR/hicops/install-inst
$ export hicops_noinst_PATH=$WORKING_DIR/hicops/install-no-inst

$ # export hicops with or without instrumentation by running either 
$ export hicops_PATH=$hicops_inst_PATH 
$ # or 
$ export hicops_PATH=$hicops_noinst_PATH 

$ export PATH=${hicops_PATH}/bin:${hicops_PATH}/tools/dbtools:${hicops_PATH}/tools/ms2prep:${hicops_PATH}/bin/tools:$PATH
$ export LD_LIBRARY_PATH=$hicops_PATH/lib:$LD_LIBRARY_PATH
```


# HiCOPS Examples
TBA
