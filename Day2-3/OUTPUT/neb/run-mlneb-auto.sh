#!/bin/bash
#$ -q all.q
#$ -pe mpi_64 64
#$ -N vf6b33448
#$ -S /bin/bash
#$ -V
#$ -cwd
echo "Got $NSLOTS slots."
cat $TMPDIR/machines
module purge
module load sge/8.1.8 intel/2019u5  vasp/5.4.4-intel-vtst-beef
export OMP_NUM_THREADS=1
cd $SGE_O_WORKDIR
time mpirun -machinefile $TMPDIR/machines -n $NSLOTS vasp_std > stdout.log
