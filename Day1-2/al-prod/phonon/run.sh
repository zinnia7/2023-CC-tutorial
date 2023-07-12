#!/bin/bash
# Phonon Calculation
mpirun -np 2 pw.x < scf.in > scf.out
mpirun -np 2 ph.x < ph.in > ph.out 
mpirun -np 2 q2r.x < q2r.in > q2r.out
mpirun -np 4 matdyn.x < matdyn.in > matdyn.out
plotband.x < al.plotband.in > al.plotband.out
# Now, we are ready to draw the phonon dispersion graph.
