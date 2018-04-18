# compare the impedance of a metamaterial layer when calculated from S11
# and directly from the simulation
import numpy as np
from matplotlib import pyplot as plt

data = np.loadtxt("fss_2.25.txt", delimiter=",")

f = data[:,0] # in GHz
S11 = data[:,1] + 1j*data[:,2]
Z = data[:,5] + 1j*data[:,6]

plt.plot(f/1e9, np.real((1+S11)/(1-S11)), "b-", label="Re(Z) from S")
plt.plot(f/1e9, np.imag((1+S11)/(1-S11)), "r-", label="Im(Z) from S")
plt.plot(f/1e9, np.real(Z)/377, "bo", markersize=2,label="Re(Z)")
plt.plot(f/1e9, np.imag(Z)/377, "ro", markersize=2,label="Im(Z)")
plt.legend()
plt.xlim([2,8])
plt.ylim([-2,5])
plt.show()

