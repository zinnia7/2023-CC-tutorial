#!/bin/bash

# queue request
#$ -q all.q

# pe request
#$ -pe mpi_64 64

# Job name 
#$ -N S_P_DFT

#$ -S /bin/bash

#$ -V

#$ -cwd

# needs in 
#   $NSLOTS          
#       the number of tasks to be used
#   $TMPDIR/machines 
#       a valid machiche file to be passed to mpirun 
#   enables $TMPDIR/rsh to catch rsh calls if available

echo "Got $NSLOTS slots."
cat $TMPDIR/machines


#######################################################
# module environments.
module purge
module load sge/8.1.8 intel/2019u5 vasp/5.4.4-intel-vtst-beef
#######################################################

 export OMP_NUM_THREADS=1

 cd $SGE_O_WORKDIR

 time mpirun -machinefile $TMPDIR/machines -n $NSLOTS vasp_std > stdout.log

