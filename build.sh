#!/bin/sh

#cd cgns_src
#./configure --prefix=../cgns
#make install
#make distclean

#cd ../cgns/include
#cp *.h ../
#cd ../lib
#cp *.* ../

cd cfl3dv6/build
./Install #-cgnsdir=../../cgns 

#make cfl3d_seq
#cp cfl/seq/cfl3d_seq ../../bin

make cfl3d_mpi
cp cfl/mpi/cfl3d_mpi ../../bin

#make splitter
#cp split/seq/splitter ../../bin

#make cfl3dcmplx_seq
#cp cflcmplx/seq/cfl3dcmplx_seq ../../bin

#make cfl3dcmplx_mpi
#cp cflcmplx/mpi/cfl3dcmplx_mpi ../../bin

#make precfl3d
#cp precfl/seq/precfl3d ../../bin

#make ronnie
#cp ron/seq/ronnie ../../bin

#make preronnie
#cp preron/seq/preronnie ../../bin

#make cfl3d_tools
#cp tools/seq/* ../../bin

#make scruball

cd ../../bin
rm *.F *.a *.o *.inp makefile*

