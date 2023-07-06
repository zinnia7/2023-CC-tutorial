#!/usr/bin/env python

from ase import io
from ase.build.general_surface import surface



atoms = io.read('./CONTCAR',index=-1) 
slab = surface(lattice = atoms, indices = (1,1,1), layers = 4)
slab = slab.repeat((1, 1, 1))
slab.center(vacuum=10, axis=2)
#slab.set_pbc((1, 1, 0))

io.write('POSCAR', slab, 'vasp')

#view(slab)


