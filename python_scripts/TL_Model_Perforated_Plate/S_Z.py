import numpy as np
from matplotlib import pyplot as plt

d = np.loadtxt("slab_3.35.txt", delimiter=",")
f = d[:, 0]
Z = d[:,5] + 1j*d[:,6]
S11 = d[:,1] + 1j*d[:,2]
phase = np.exp(-2j*np.pi*73.745e-3*f/3e8)
G = S11*phase
Zcalc = 377 * (1+G)/(1-G)
eps = 4.4+1j*0.088/(2*np.pi*f*8.85e-2)
Zan = 377j/np.sqrt(eps)*np.tan(2*np.pi*f*np.sqrt(eps)*0.4e-3/3e8)

plt.plot(f/1e9, np.real(Z), "r-", label="Re(Z) from S")
plt.plot(f/1e9, np.imag(Z), "b-", label="Im(Z) from S")
plt.plot(f/1e9, np.real(Zan), "m-", label="Re(Zan) ")
plt.plot(f/1e9, np.imag(Zan), "c-", label="Im(Zan) ")
#plt.plot(f/1e9, np.real(Zcalc), "r--", label="Re Z")
#plt.plot(f/1e9, np.imag(Zcalc), "b--", label="Im Z")
plt.legend()
plt.show()
