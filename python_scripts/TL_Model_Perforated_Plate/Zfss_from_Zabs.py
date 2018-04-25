import numpy as np
from matplotlib import pyplot as plt

radii = [2.75,2.95,3.15,3.35]
radii = [8.8,9,9.2,9.4,9.6]
#data = [np.loadtxt("absorber_%.2f.txt" %r, delimiter=",") for r in radii]
data = [np.loadtxt("absorber_3.35_%s.txt" %r, delimiter=",") for r in radii]

f = data[0][:,0]
Zabs = [d[:,5] + 1j*d[:,6] for d in data] # Impedance of the absorber
epsD = 4.4 - 1j*0.0489/(2*np.pi*f*8.85e-12)
Zd = 1j*377/np.sqrt(epsD)*np.tan(2*np.pi*f*np.sqrt(epsD)/3e8*0.4e-3)

Zfss = [(1/Z-1/Zd)**(-1) for Z in Zabs]

f /= 1e9
for i, Z in enumerate(Zfss):
    plt.plot(f, np.real(Z), label="Re(Z), R=%.2f" %radii[i])
    plt.plot(f, np.imag(Z), label="Im(Z), R=%.2f" %radii[i])
plt.xlim([2,8])
plt.ylim([-80,40])
plt.legend()
plt.show()
