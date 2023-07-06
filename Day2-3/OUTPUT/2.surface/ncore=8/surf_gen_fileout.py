#!/usr/bin/env python

from ase import io
from ase.build.general_surface import surface


atoms = io.read('./CONTCAR',index=-1) 
slab = surface(lattice = atoms, indices = (1,1,1), layers = 5)
slab = slab.repeat((2, 2, 1))
slab.center(vacuum=10, axis=2)

io.write('POSCAR', slab, 'vasp')

