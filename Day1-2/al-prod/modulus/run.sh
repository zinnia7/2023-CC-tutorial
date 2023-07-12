#!/bin/bash
# Clear the directory
rm -rfv !("run.sh")
# Calculate the total energy changing the box dimension.
for celldm in 7.40 7.45 7.50 7.55 7.60 7.63075 7.65 7.70 7.75 7.80 7.85 7.90; do
# Make input file for the SCF calculation.
cat > celldm.$celldm.in << EOF
&CONTROL
 calculation = 'scf',
 prefix = 'al',
 etot_conv_thr = 0.0001,
 forc_conv_thr = 0.001,
 pseudo_dir = '../../pseudo'
/
&SYSTEM
 ibrav = 2,
 celldm(1) = $celldm,
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
  32 32 32 0 0 0
EOF
# Run SCF calculation.
mpirun -np 4 pw.x < celldm.$celldm.in > celldm.$celldm.out
# Print the total volume and total energy.
grep -ioP 'unit-cell volume\D*\K\d[\d.]*' celldm.$celldm.out | tr '\n' ' ' >> ev.data; echo "-" | tr -d '\n' >> ev.data
grep -ioP 'total energy\D*\K\d[\d.]*' celldm.$celldm.out | tail -1 >> ev.data
# End of for loop
done
