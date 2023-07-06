from ase.thermochemistry import HarmonicThermo
from ase.parallel import paropen
from ase import io

### INPUT PARAMETER ###

temperature = 573 # in K

with open("OUTCAR", "r") as f:
    lines = f.readlines()

vib_energies = []
for line in lines:
    if "f  =" in line:
        energy = float(line.split()[9]) / 1000
        vib_energies.append(energy)

### ASE part ###
thermo = HarmonicThermo(vib_energies=vib_energies)
thermo.get_helmholtz_energy(temperature=temperature, verbose = True)


