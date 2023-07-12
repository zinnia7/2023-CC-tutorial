#!/bin/bash
# Clear the directory
rm -rfv !("run.sh")
# Convergence test of the k-points.
for kpoints in 8 10 12 14 16 18 20 24 28 32 40 48; do
# Make input file for the SCF calculation.
cat > kpoints.$kpoints.in << EOF
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
 ecutrho = 320.
 /
&ELECTRONS
  conv_thr= 1e-8
/
ATOMIC_SPECIES
  Al 26.981539 Al.pbe-n-kjpaw_psl.1.0.0.UPF

ATOMIC_POSITIONS (alat)
  Al 0.00 0.00 0.00

K_POINTS (automatic)
  $kpoints $kpoints $kpoints 0 0 0
EOF
# Run SCF calculation.
mpirun -np 4 pw.x < kpoints.$kpoints.in > kpoints.$kpoints.out
# pw.x < kpoints.$kpoints.in > kpoints.$kpoints.out
# Write the number of k-points and total energies in calc-kpoints.dat.
awk '/!/ {printf"%d %s\n",'$kpoints',$5}' kpoints.$kpoints.out >> calc-kpoints.dat
# End of for loop
done
