#! /bin/sh

mkdir optimized_structures

#cp /home/skkim/reforming/mlneb/INCAR0 ./
#cp /home/skkim/reforming/mlneb/run_mlneb.py ./
cp initial/CONTCAR optimized_structures/initial.traj
cp final/CONTCAR optimized_structures/final.traj
cp ./initial/KPOINTS ./
cp ./initial/POTCAR ./
cp ./initial/vdw_kernel.bindat ./
cp ./initial/INCAR ./INCAR0


~/script/trans_format.py optimized_structures/initial.traj vasp optimized_structures/initial.traj traj
~/script/trans_format.py optimized_structures/final.traj vasp optimized_structures/final.traj traj


