#!/bin/bash
# Clear the directory
rm -rfv !("run.sh")
# Calculate the total energy changing the box dimension.
for celldm in 2.8 2.82 2.84 2.86 2.88 2.9 2.92 2.94 2.96 2.98 3 3.02 3.04 3.06 3.08 3.1 3.15 3.2; do
# Make input file for the SCF calculation.
cat > celldm.$celldm.in << EOF
&CONTROL
 calculation = 'scf',
 prefix = 'cu1zn1',
 etot_conv_thr = 0.0001,
 forc_conv_thr = 0.001,
 pseudo_dir = '../../',
 /
&SYSTEM
 ibrav = 0,
 nat = 2,
 ntyp = 2,
 occupations = 'smearing',
 smearing = 'mp',
 degauss = 0.01,
 ecutwfc = 40,
 ecutrho = 320,
 /
&ELECTRONS
 electron_maxstep = 100,
 conv_thr = 1e-6,
 mixing_beta = 0.7,
 /
CELL_PARAMETERS angstrom
 $celldm 0.000000 0.000000
 0.000000 $celldm 0.000000
 0.000000 0.000000 $celldm
ATOMIC_SPECIES
Cu 63.546 Cu.pbe-dn-kjpaw_psl.1.0.0.UPF
Zn 65.38 Zn.pbe-dnl-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS alat
Cu   0.000000   0.000000   0.000000 1 1 1
Zn   0.500000   0.500000   0.500000 1 1 1
K_POINTS automatic
16 16 16 0 0 0
EOF
# Run SCF calculation.
mpirun -np 4 pw.x < celldm.$celldm.in > celldm.$celldm.out
# Print the total volume and total energy.
grep -ioP 'unit-cell volume\D*\K\d[\d.]*' celldm.$celldm.out | tr '\n' ' ' >> ev.data; echo "-" | tr -d '\n' >> ev.data
grep -ioP 'total energy\D*\K\d[\d.]*' celldm.$celldm.out | tail -1 >> ev.data
# End of for loop
done
