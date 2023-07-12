#!/bin/bash
# Clear the directory
rm -rfv !("run.sh")
# Calculate the total energy changing the box dimension.
for celldm in 3.40 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05; do
# Make input file for the SCF calculation.
cat > celldm.$celldm.in << EOF
&CONTROL
 calculation = 'scf',
 prefix = 'cu3zn1',
 etot_conv_thr = 0.0001,
 forc_conv_thr = 0.001,
 pseudo_dir = '../../',
 /
&SYSTEM
 ibrav = 0,
 nat = 4,
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
Zn   0.000000   0.000000   0.000000 1 1 1
Cu   0.500000   0.500000   0.000000 1 1 1
Cu   0.000000   0.500000   0.500000 1 1 1
Cu   0.500000   0.000000   0.500000 1 1 1
K_POINTS automatic
6 6 6 0 0 0
EOF
# Run SCF calculation.
mpirun -np 4 pw.x < celldm.$celldm.in > celldm.$celldm.out
# Print the total volume and total energy.
grep -ioP 'unit-cell volume\D*\K\d[\d.]*' celldm.$celldm.out | tr '\n' ' ' >> ev.data; echo "-" | tr -d '\n' >> ev.data
grep -ioP 'total energy\D*\K\d[\d.]*' celldm.$celldm.out | tail -1 >> ev.data
# End of for loop
done
