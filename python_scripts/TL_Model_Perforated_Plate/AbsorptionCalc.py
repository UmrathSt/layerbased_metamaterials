# Compare the absorption of a metamaterial absorber when calculated directly
# from an absorber with 0.4 mm FR4 thickness
# and by an impedance calculation where the respective impedance of the metalayer
# is parallel connected to the grounded dielectric slab
import numpy as np
from matplotlib import pyplot as plt

absorber = np.loadtxt("absorber_3.25.txt", delimiter=",")
fss = np.loadtxt("fss_3.25.txt", delimiter=",")

# the analytical formula for a 0.4 mm thick FR4 slab with eps_r = 4.4 and
# a frequency dependend imaginary part such that a constant conductivity
# is emulated in the respective FDTD

f = fss[:,0]
epsFR4 = 4.4 - 1j*0.048957/(2*np.pi*f*8.85e-12)
lz = 0.4e-3 # fr4 thickness
Zslab = 1j*377/np.sqrt(epsFR4)*np.tan(2*np.pi*f/3e8*np.sqrt(epsFR4)*lz)
D = 40.25e-3
phase = np.exp(0j*np.pi*f*D/3e8)
Rfss = (fss[:,1] + 1j * fss[:,2]) * phase
Zfss = 377*(1 + Rfss) / (1 - Rfss)
#Zfss = 1 - 20.j
Zmeta = Zfss*Zslab/(Zfss+Zslab)

plt.plot(f/1e9, np.abs(absorber[:,1]+1j*absorber[:,2])**2, "r-", label="FDTD")
plt.plot(f/1e9, np.abs((Zmeta - 377) / (Zmeta + 377))**2, "b-", label="analytic")
plt.xlabel("f [GHz]")
plt.ylabel("|S11|")
plt.legend()
plt.show()
