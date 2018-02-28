import numpy as np

class SlabStructure:
    def __init__(self, Z, l, k):
        """ Initialze a slab structure of stacked impedance
            surfaces with different thicknesses
            Z0 | Z1 | Z2 | ... | ZN-1 | ZN
                 l1 | l2 | ... | lN-1  
        """
        self.Z = Z
        self.M = len(Z) - 1 # number of interfaces 
        self.l = l
        self.k = k
        self.rho = (Z[1:,:]-Z[0:-1,:]) / (Z[1:,:]+Z[0:-1,:])
        assert Z.shape[0]-2 == l.shape[0] == k.shape[0]
    
    def build_gamma(self):
        """ Get the scattering coefficient of the
            stacked structure by recursion
        """
        rho = self.rho 
        phase = self.k*self.l
        GammaM = rho[-1,:]
        for i in range(rho.shape[0]-2, -1, -1):
            print("i=%i" %i)
            phasefactor = np.exp(2j*phase[i,:])
            GammaM = (rho[i,:] + GammaM*phasefactor) / (1 + rho[i,:]*GammaM*phasefactor )
        return GammaM
        



if __name__ == "__main__":
    from matplotlib import pyplot as plt
    tand1 = 0.02
    eps1 = 4.4
    epsFR4 = eps1*(1 + tand1*1j)
    eps2 = 9
    tand2 = 0.111
    epsRubber = eps2*(1 + tand2*1j)
    eps = np.array([epsFR4])[:,np.newaxis]
    f = (np.linspace(0,20,1000)*1e9)[np.newaxis,:]
    Zlist = np.array([376.73,1/np.sqrt(epsFR4), 0])[:,np.newaxis]
    l = np.array([3.58e-3])[:,np.newaxis]
    k = np.sqrt(eps)*2*np.pi*f/3e8
    slabstack = SlabStructure(Zlist, l, k)
    R = slabstack.build_gamma()
    print(R.shape)
    plt.plot(f[0,:]/1e9, 20*np.log10(np.abs(R)))
    plt.xlabel("f [GHz]")
    plt.ylabel("$20\log|S_{11}|)$")
    plt.show()
