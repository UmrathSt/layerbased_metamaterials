import numpy as np

f = np.linspace(1,20,191)
data = np.array([np.loadtxt("rcs_PEC_sphere__f_%.2f_GHz.dat" %F, delimiter=",")[1] for F in f])

to_write = np.zeros((len(f), 2))
to_write[:,0] = f
to_write[:,1] = data
header = "monostatic rcs of a R = 25 mm PEC sphere"
np.savetxt("monostatic_rcs_sphere.dat", to_write,delimiter=",",header=header)
