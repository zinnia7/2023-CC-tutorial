#!/opt/anaconda3/2021.11/envs/catlearn/bin/python3

from ase.io import read
from ase.optimize import BFGS
from ase.calculators.vasp import Vasp
import shutil
import copy
from catlearn.optimize.mlneb import MLNEB

""" Example to run ML-NEB using the VASP calculator.
    Make sure you have set a single-point calculation (for VASP nsw=0).
    The trajectory files for the initial and final end-points are located
    in the 'optimized_structures' directory.
    
"""

# Set calculator
ase_calculator = Vasp()
#ase_calculator.read_incar('INCAR')
ase_calculator.read_kpoints('KPOINTS')
ase_calculator.read_potcar('POTCAR')

# Optimize initial state
slab = read('./optimized_structures/initial.traj')
slab.set_calculator(copy.deepcopy(ase_calculator))
qn = BFGS(slab, trajectory='initial.traj')
qn.run(fmax=0.5)
shutil.copy('./initial.traj', './optimized_structures/initial.traj')

# Optimize final state:
slab = read('./optimized_structures/final.traj')
slab.set_calculator(copy.deepcopy(ase_calculator))
qn = BFGS(slab, trajectory='final.traj')
qn.run(fmax=0.5)
shutil.copy('./final.traj', './optimized_structures/final.traj')

####### CatLearn NEB:

neb_catlearn = MLNEB(start='initial.traj', end='final.traj',
                     ase_calc=copy.deepcopy(ase_calculator), n_images=8,
                     interpolation='idpp', restart=False )

neb_catlearn.run(fmax=0.2)
