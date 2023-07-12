#!/bin/bash
# Explore the effect of the smearing functions and energies

# Set a variable sf for the smearing functions.
for sf in fd gauss mp mv; do
# Set a variable se for the smearing energies.
for se in 0.010 0.020 0.030 0.040 0.050; do
# Make input file for the scf calculation.
cat > $sf.$se.in << EOF
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
 smearing = '$sf',
 degauss = $se,
 ecutwfc = 40,
 ecutrho = 320
 /
&ELECTRONS
 conv_thr = 1.0e-6,
 /
&IONS
 /
ATOMIC_SPECIES
  Al 26.981539 Al.pbe-n-kjpaw_psl.1.0.0.UPF

ATOMIC_POSITIONS (alat)
  Al 0.00 0.00 0.00

K_POINTS (automatic)
14 14 14 0 0 0
EOF

# Run pw.x for SCF calculation.
mpirun -np 4 pw.x <$sf.$se.in> $sf.$se.out

# Write the name of the smearing functions, the smearing energies, and total energies.

awk -v var="$sf" '/!/ {printf"%-6s %1.3f %s\n",var,'$se',$5}' $sf.$se.out >> calc-smearing.dat

# End of for sf loop.
done
# End of for se loop.
done
