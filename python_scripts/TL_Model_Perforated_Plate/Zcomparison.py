# compare the impedance of a metamaterial layer when calculated from S11
# and directly from the simulation
import numpy as np
from matplotlib import pyplot as plt

data = np.loadtxt("slab_0.4_3.35.txt", delimiter=",") # 0.4 mm FR4 file with increasing meshing
#data = np.loadtxt("slab_4_2.25.txt", delimiter=",") # 4 mm FR4 file 


f = data[:,0] # in GHz
D = 76.817*1e-3 # 0.4 mm fr4 thickness
#D = (77.7258-4.5)*1e-3 # 4 mm fr4 thickness
S11 = (data[:,1] + 1j*data[:,2])*np.exp(4j*np.pi*f/3e8*D)
Z = (data[:,5] + 1j*data[:,6])*np.exp(4j*np.pi*f/3e8*D)
epsFR4 = 4.4 -1j*0.048957/(2*np.pi*f*8.8542e-12)
lz = 4e-4 # 0.4 mm FR4
#lz = 4e-3 # 4 mm FR4
Zslab = 1j*377/np.sqrt(epsFR4)*np.tan(2*np.pi*f/3e8*np.sqrt(epsFR4)*lz)


plt.plot(f/1e9, np.real((1+S11)/(1-S11))*377, "b-", label="Re(Z) from S")
plt.plot(f/1e9, np.imag((1+S11)/(1-S11))*377, "r-", label="Im(Z) from S")
plt.plot(f/1e9, np.real(Z), "bo", markersize=2,label="Re(Z)")
plt.plot(f/1e9, np.imag(Z), "ro", markersize=2,label="Im(Z)")
plt.plot(f/1e9, np.real(Zslab), "c-", label="Re(Z) analytic")
plt.plot(f/1e9, np.imag(Zslab), "m-", label="Im(Z) analytic")

plt.legend()
plt.xlim([2,8])
plt.ylim([-2,160])
plt.show()

