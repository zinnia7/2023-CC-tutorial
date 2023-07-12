#!/bin/bash
# Clear the directory
rm -rfv !("run.sh")
# Calculate the total energy changing the box dimension.
for celldm in 6.60 6.65 6.70 6.75 6.80 6.85 6.90 6.95 7.00 7.05 7.10 7.15 7.20 7.25 7.30; do
# Make input file for the SCF calculation.
cat > celldm.$celldm.in << EOF
&CONTROL
 calculation = 'scf',
 prefix = 'cu1zn0',
 etot_conv_thr = 0.0001,
 forc_conv_thr = 0.001,
 pseudo_dir = '../../'
 /
&SYSTEM
 ibrav = 2, ! fcc
 celldm(1) = $celldm,
 nat = 1,
 ntyp = 1,
 ecutwfc = 80,
 ecutrho = 640,
 occupations = 'smearing',
 degauss = 0.01,
 smearing = 'gauss',
 /
&ELECTRONS
 electron_maxstep = 100,
 conv_thr = 1e-5,
 mixing_beta = 0.7,
 /
ATOMIC_SPECIES
Cu 63.546 Cu.pbe-dn-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS angstrom
Cu   0.000000   0.000000   0.000000 0 0 0
K_POINTS automatic
8 8 8 0 0 0
EOF
# Run SCF calculation.
mpirun -np 4 pw.x < celldm.$celldm.in > celldm.$celldm.out
# Print the total volume and total energy.
grep -ioP 'unit-cell volume\D*\K\d[\d.]*' celldm.$celldm.out | tr '\n' ' ' >> ev.data; echo "-" | tr -d '\n' >> ev.data
grep -ioP 'total energy\D*\K\d[\d.]*' celldm.$celldm.out | tail -1 >> ev.data
# End of for loop
done
