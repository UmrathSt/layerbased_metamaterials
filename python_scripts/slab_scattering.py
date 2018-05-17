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
        assert Z.shape[0]-2 == l.shape[0] == k.shape[0]-2
        self.k = k
        self.l = l
        self.phase = self.k[1:-1,:]*self.l
        self.tau = Z[1:,:]*2/(Z[0:-1,:]+Z[1:,:])
        self.rho = (Z[1:,:]-Z[0:-1,:]) / (Z[1:,:]+Z[0:-1,:])
        self.Gammas = []
        self.tau = []

    def build_gamma(self):
        """ Get the scattering coefficient of the
            stacked structure by recursion
        """
        rho = self.rho 
        phase = self.phase 
        GammaM = rho[-1,:]
        self.Gammas.append(GammaM)
        for i in range(rho.shape[0]-2, -1, -1):
            print("i=%i" %i)
            phasefactor = np.exp(2j*phase[i,:])
            GammaM = (rho[i,:] + GammaM*phasefactor) / (1 + rho[i,:]*GammaM*phasefactor )
            self.Gammas.append(GammaM)
        return GammaM # the left-most scattering coefficient
        
    def build_tau(self):
        """ Get the left to right transmission 
            of the stacked structure
        """
        rho = self.rho 
        phase = self.phase
        tauM = 1
        print("len self.Gammas = ", len(self.Gammas))
        for i in range(len(self.Gammas)-1, 0, -1):
            print("Building tau: i=%i" %i)
            phasefactor = np.exp(2j*phase[i-1,:])
            tauM *= (1 + self.Gammas[i-1]) / (1 + self.Gammas[i]*phasefactor)
            self.tau.append(tauM)
        tauM *= 2*self.k[-1,:]/(self.k[-1,:] + self.k[-2,:])
        self.tau.append(tauM)
        return tauM

        
        


if __name__ == "__main__":
    from matplotlib import pyplot as plt
    mdata = np.loadtxt("S11_f_UCDim_2_lz_3.5_eps_4_tand_1.txt", delimiter=",")
    S11 = mdata[:,1]+1j*mdata[:,2]
    f = mdata[:,0] 
    Nf = len(f) 
    eps1 = 4
    kappa = 1.7802e0
    Z0 = np.ones(Nf)*376.73
    eps = np.zeros((3, Nf), dtype=np.complex128)
    Zlist = np.zeros((3, Nf), dtype=np.complex128)
    eps[0,:] = 1
    eps[1,:] = eps1 + kappa*1j/(2*np.pi*f*8.85e-12)
    eps[2,:] = 100000000 
    Zlist[:,:] = Z0,Z0/np.sqrt(eps[1,:]), Z0*0
    l = np.array([3.5e-3])[:,np.newaxis]
    k = np.sqrt(eps)*2*np.pi*f/3e8
    slabstack = SlabStructure(Zlist, l, k)
    R = slabstack.build_gamma()
    T = slabstack.build_tau()
    plt.plot(f/1e9, 20*np.log10(np.abs(R)),"r-", label="R")
    plt.plot(mdata[:,0]/1e9, 20*np.log10(np.abs(S11)),"m-", label="Rmeas")
#    plt.plot(f/1e9, 20*np.log10(np.abs(T)),"b-", label="T")
    plt.legend(loc="best").draw_frame(False)
    plt.xlabel("f [GHz]")
    plt.ylabel("$20\log|S_{11}|)$")
    plt.ylabel("$|S_{11}|)$")
    plt.ylim([-30,0])
    #plt.show()
    plt.plot(f/1e9, 376.73*((1+R)/(1-R)).imag, "k-", linewidth=2)
    #plt.show()

    N1, N2 = 1400, 1800
    print("f1, f2 = ", f[[N1,N2]])
    missing_phase = np.log(S11[N1]/S11[N2]*R[N2]/R[N1])/(2*np.pi*1j*(f[N1]-f[N2])/3e8)
    print(missing_phase)
    dphi = S11[N1]/(R[N1]*np.exp(2*np.pi*1j*f[N1]*(-1.75e-3)/3e8))
    print("dphi = ", dphi)
