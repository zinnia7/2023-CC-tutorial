from ase.thermochemistry import IdealGasThermo
from ase.parallel import paropen
from ase import io

### INPUT PARAMETER ###
temperature=573 # in K
pressure=101325 # in Pa
geometry='linear' # 'monoatomic', 'linear' or 'nonlinear'
symmetrynumber=2 # integer
spin=0 # total electronic spin: 0 for all electrons paired, 0.5 for free radical with a single unpaired, 1 for triplet (e.g., O2)

atoms = io.read('./CONTCAR')

with open("OUTCAR", "r") as f:
    lines = f.readlines()

vib_energies = []
for line in lines:
    if "f  =" in line:
        energy = float(line.split()[9]) / 1000
        vib_energies.append(energy)

### ASE part ###
thermo = IdealGasThermo(vib_energies=vib_energies,
                        atoms=atoms,
                        geometry=geometry,
                        symmetrynumber=symmetrynumber,
                        spin=spin)
thermo.get_gibbs_energy(temperature=temperature, pressure=pressure)

