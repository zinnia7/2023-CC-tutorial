#!/bin/bash
# Convergence test of cut -off energy.
# Set a variable ecutrho from three times, four times, ..., eight times of the ecutwfc.
for ecutrho in 80 120 160 200 240 280 320 360 400; do
# Make input file for the SCF calculation.
# ecutwfc is assigned based on the previous trial
cat > ecutrho.$ecutrho.in << EOF
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
 ecutwfc = 40.
 ecutrho = $ecutrho
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
mpirun -np 4 pw.x < ecutrho.$ecutrho.in > ecutrho.$ecutrho.out
# Write cut-off (rho) and total energies in calc-ecutrho.dat.
awk '/!/ {printf"%d %s\n",'$ecutrho',$5}' ecutrho.$ecutrho.out >> calc-ecutrho.dat
# End of for loop
done