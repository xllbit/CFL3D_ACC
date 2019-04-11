cd CFL3D
cp ../bin/cfl3d_mpi .
mpirun -np 16 ./cfl3d_mpi <case.inp
