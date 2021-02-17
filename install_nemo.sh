conda deactivate
export APPROOT=$PWD/nemo
mkdir -p $APPROOT/build
mkdir -p $APPROOT/opt
export MODULEPATH=$APPROOT/modules:$MODULEPATH
cd $APPROOT
git clone https://github.com/William-Mou/module_file.git
mv module_file/modules modules
sed -i "s|\$APPROOT|$APPROOT|g" $APPROOT/modules/*

cd $APPROOT/build
wget http://mirror.ossplanet.net/gnu/gcc/gcc-7.5.0/gcc-7.5.0.tar.gz
tar -xvf gcc-7.5.0.tar.gz
cd gcc-7.5.0
./contrib/download_prerequisites
cd ..
mkdir objdir
cd objdir
$PWD/../gcc-7.5.0/configure --prefix=$APPROOT/opt/gcc-7.5.0 --enable-languages=c,c++,fortran,go
make -j $(nproc)
make install

cd $APPROOT/build
module load gcc-7.5.0-t
wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
tar -xvf boost_1_72_0.tar.gz
cd boost_1_72_0 
CC=gcc CXX=g++ ./bootstrap.sh --prefix=$APPROOT/opt/boost --without-libraries=python
./b2 install 

cd $APPROOT/build
module load gcc-7.5.0-t
wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz
tar -zxvf mpich-3.1.4.tar.gz
cd mpich-3.1.4
CC=gcc CXX=g++ FC=gfortran ./configure --prefix=$APPROOT/opt/mpich-3.1.4  --with-tm=/opt/bin/pbs
make -j $(nproc) install 

cd $APPROOT/build
module load gcc-7.5.0-t
module load mpich-3.1.4-t
wget https://nchc.dl.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz
tar -xvf zlib-1.2.11.tar.gz
cd zlib-1.2.11
CC=mpicc CXX=mpicxx ./configure --prefix=$APPROOT/opt/zlib-1.2.11
make -j $(nproc)
make install 
module load gcc-7.5.0-t
module load zlib-1.2.11-t
module load mpich-3.1.4-t

cd $APPROOT/build
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.21/src/hdf5-1.8.21.tar.bz2
tar -xvf hdf5-1.8.21.tar.bz2
cd hdf5-1.8.21
CC=mpicc CXX=mpicxx \
./configure --enable-parallel --enable-fortran \
--with-zlib=$APPROOT/opt/zlib-1.2.11 \
--prefix=$APPROOT/opt/hdf5-1.8.21 \
--enable-shared --enable-hl
make -j $(nproc)
make install 

cd $APPROOT/build
module load gcc-7.5.0-t
module load zlib-1.2.11-t
module load mpich-3.1.4-t
module load hdf5-1.8.21-t
wget -q https://parallel-netcdf.github.io/Release/pnetcdf-1.12.0.tar.gz 
tar xf pnetcdf-1.12.0.tar.gz
cd pnetcdf-1.12.0
CC=mpicc CXX=mpicxx \
./configure MPICC=mpicc MPICXX=mpicxx MPIF90=mpif90 --prefix=$APPROOT/opt/pnetcdf-1.12.0 
make -j $(nproc)
make install 

cd $APPROOT/build/
module load gcc-7.5.0-t
module load zlib-1.2.11-t
module load mpich-3.1.4-t
module load hdf5-1.8.21-t
module load pnetcdf-1.12.0-t
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.3.tar.gz 
tar -xvf netcdf-c-4.7.3.tar.gz
cd netcdf-c-4.7.3
CC=mpicc CXX=mpicxx \
CPPFLAGS="-I$APPROOT/opt/hdf5-1.8.21/include -I$APPROOT/opt/pnetcdf-1.12.0/include -I$APPROOT/zlib-1.2.11/include" \
LDFLAGS="-L$APPROOT/opt/hdf5-1.8.21/lib -L$APPROOT/opt/pnetcdf-1.12.0/lib -L$APPROOT/opt/zlib-1.2.11/lib"  \
./configure --enable-pnetcdf \
--enable-parallel-tests \
--disable-dap --disable-shared \
--prefix=$APPROOT/opt/netcdf-c-4.7.3 
make -j $(nproc)
make install

cd $APPROOT/build/
module load gcc-7.5.0-t
module load zlib-1.2.11-t
module load mpich-3.1.4-t
module load hdf5-1.8.21-t
module load pnetcdf-1.12.0-t
module load netcdf-c-4.7.3-t
wget https://github.com/Unidata/netcdf-fortran/archive/v4.4.5.tar.gz
tar -xvf v4.4.5.tar.gz
cd netcdf-fortran-4.4.5
CC=mpicc CXX=mpicxx FC=mpifort \
CPPFLAGS="-I$APPROOT/opt/hdf5-1.8.21/include -I$APPROOT/opt/pnetcdf-1.12.0/include -I$APPROOT/zlib-1.2.11/include -I$APPROOT/opt/netcdf-c-4.7.3/include" \
LDFLAGS="-L$APPROOT/opt/hdf5-1.8.21/lib -L$APPROOT/opt/pnetcdf-1.12.0/lib -L$APPROOT/opt/zlib-1.2.11/lib -L$APPROOT/opt/netcdf-c-4.7.3/lib"  \
./configure --prefix=$APPROOT/opt/netcdf-fortran-4.4.5 
make -j $(nproc)
make install 

cd $APPROOT/opt/
module load gcc-7.5.0-t
module load zlib-1.2.11-t
module load mpich-3.1.4-t
module load hdf5-1.8.21-t
module load pnetcdf-1.12.0-t
module load netcdf-c-4.7.3-t
module load netcdf-fortran-4.4.5-t
svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/xios-2.5 xios-2.5
cd xios-2.5 
mv $APPROOT/module_file/arch-GCC_LINUX.env $APPROOT/opt/xios-2.5/arch/arch-GCC_LINUX.env
sed -i "s|\$APPROOT|$APPROOT|g" $APPROOT/opt/xios-2.5/arch/arch-GCC_LINUX.env
sed -i "s|-lnetcdff -lnetcdf|-Wl,--unresolved-symbols=ignore-in-object-files -lnetcdff -lnetcdf|g" $APPROOT/opt/xios-2.5/arch/arch-GCC_LINUX.path
./make_xios -job $(nproc) --arch GCC_LINUX

cd $APPROOT/opt/
module load gcc-7.5.0-t
module load zlib-1.2.11-t
module load mpich-3.1.4-t
module load hdf5-1.8.21-t
module load pnetcdf-1.12.0-t
module load netcdf-c-4.7.3-t
module load netcdf-fortran-4.4.5-t
svn co --non-interactive --trust-server-cert https://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/release-4.0 nemo-4.0
mv $APPROOT/module_file/arch-linux_gfortran.fcm $APPROOT/opt/nemo-4.0/arch/arch-linux_gfortran.fcm 
sed -i "s|\$APPROOT|$APPROOT|g" $APPROOT/opt/nemo-4.0/arch/arch-linux_gfortran.fcm 
cd $APPROOT/opt/nemo-4.0/
./makenemo -m linux_gfortran -r GYRE_PISCES -n hpcx_linux_gfortran_gyre_pisces -j $(nproc)
sed -i "s/nn_GYRE     =     1 /nn_GYRE     =     25 /g"  $APPROOT/opt/nemo-4.0/cfgs/hpcx_linux_gfortran_gyre_pisces/EXP00/namelist_cfg
sed -i "s/ln_bench    = .false. /ln_bench    = .true. /g"  $APPROOT/opt/nemo-4.0/cfgs/hpcx_linux_gfortran_gyre_pisces/EXP00/namelist_cfg
sed -i "s|\$APPROOT|$APPROOT|g" $APPROOT/module_file/NTHU_NEMO.pbs
