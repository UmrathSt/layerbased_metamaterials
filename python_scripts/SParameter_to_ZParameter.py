import numpy as np
from matplotlib import pyplot as plt

def get_Z_from_S(S11, S21):
    numerator = (1-S11**2)**2 + S21**2
    denumerator = (1-S11**2)**2 - S21**2
    return numerator/denumerator

def get_ZM_from_S11(S11, Z0):
    
    numerator = (1-S11**2)**2 + S21**2
    denumerator = (1-S11**2)**2 - S21**2
    return numerator/denumerator



if __name__ == "__main__":
    dat = np.loadtxt("/home/stefan_dlr/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse/SParameters/squares/S11_f_UCDim_20_lz_2_L1_16_L2_0_epsFR4_Lorentz_4.6.txt", delimiter=",")
    S11 = dat[:,1]+dat[:,2]*1j
    S21 = dat[:,3]+dat[:,4]*1j
    f = dat[:,0]/1e9 # converstion to GHz
    Z = get_Z_from_S(S11, S21)
    fig = plt.figure()
    ax1 = fig.add_subplot(121)
    ax2 = fig.add_subplot(122)
    ax1.plot(f, np.abs(Z))
    ax2.plot(f, np.arctan2(np.imag(Z), np.real(Z))/np.pi)
    ax1.set_xlabel("f [GHz]")
    ax1.set_ylabel("|Z| [Ohm]")
    ax2.set_xlabel("f [GHz]")
    ax2.set_ylabel("arg(Z)/$\pi$")
    fig.tight_layout()    
    plt.show()
    fig.tight_layout()    
    plt.show()
