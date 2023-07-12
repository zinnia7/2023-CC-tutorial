#!/bin/bash
# Clear the directory
rm -rfv !("run.sh")
# Convergence test of cut -off energy.
# Set a variable ecut from 20 to 80 Ry.
for ecut in 6 8 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80; do
# Make input file for the SCF calculation.
# ecutwfc is assigned by variable ecut.
cat > ecut.$ecut.in << EOF
&CONTROL
 calculation = 'scf',
 prefix = 'al',
 etot_conv_thr = 0.0001,
 forc_conv_thr = 0.001,
 pseudo_dir = '../../pseudo'
/
&SYSTEM
 ibrav = 2,
 celldm(1) = 7.63075,
 nat = 1,
 ntyp = 1,
 occupations = 'smearing',
 smearing = 'gauss',
 degauss = 0.01,
 ecutwfc = ${ecut}
 /
&ELECTRONS
  conv_thr= 1e-8
/
ATOMIC_SPECIES
  Al 26.981539 Al.pbe-n-kjpaw_psl.1.0.0.UPF

ATOMIC_POSITIONS (alat)
  Al 0.00 0.00 0.00

K_POINTS (automatic)
  14 14 14 0 0 0
EOF
# Run SCF calculation.
mpirun -np 4 pw.x <ecut.$ecut.in> ecut.$ecut.out
# Write cut-off and total energies in calc-ecut.dat.
awk '/!/ {printf"%d %s\n",'$ecut',$5}' ecut.$ecut.out >> calc-ecut.dat
# End of for loop
done