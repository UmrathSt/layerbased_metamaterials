import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--L1", dest="L2", type=float)
parser.add_argument("--L2", dest="L1", type=float)
parser.add_argument("--Rsq1", dest="Rsq1", type=float)
parser.add_argument("--Rsq2", dest="Rsq2", type=float)
args = parser.parse_args()


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
        # building Gamma from right to left
        for i in range(rho.shape[0]-2, -1, -1):
            print("Building Gamma: i=%i" %i)
            phasefactor = np.exp(2j*phase[i,:])
            GammaM = (rho[i,:] + GammaM*phasefactor) / (1 + rho[i,:]*GammaM*phasefactor)
            self.Gammas.append(GammaM)
        self.Gammas.reverse()
        return GammaM # the left-most scattering coefficient
        
    def build_tau(self):
        """ Get the left to right transmission 
            of the stacked structure
        """
        phase = self.phase
        tauM = 1
        print("len self.Gammas = ", len(self.Gammas))
        # the evaluation starts with the left-most transmission coefficient
        lenG = len(self.Gammas)
        for i in range(0, lenG-1):
            print("Building tau: i=%i" %i)
            phasefactor = np.exp(2j*phase[i,:])
            tauM *= (1 + self.Gammas[i]) / (1 + self.Gammas[i+1]*phasefactor)
            tauM *= np.exp(1j*phase[i,:])
            self.tau.append(tauM)
        tauM *= (1 + self.Gammas[-1])
        self.tau.append(tauM)
        return tauM

        
        


if __name__ == "__main__":
    from matplotlib import pyplot as plt
    #mdata = np.loadtxt("S11_f_UCDim_2_lz_3.5_eps_4_tand_1.txt", delimiter=",")
    #S11 = mdata[:,1]+1j*mdata[:,2]
    fmin, fmax = 1, 100
    f = np.linspace(fmin, fmax,500)*1e9 
    Nf = len(f) 
    eps1 = 1 
    eps2 = 1 
    Z0 = np.ones(Nf)*376.73
    eps = np.zeros((4, Nf), dtype=np.complex128)
    Zlist = np.zeros((4, Nf), dtype=np.complex128)
    eps[0,:] = 1
    eps[1,:] = eps1 + 1j/(args.Rsq1*args.L1*2*np.pi*f*8.85e-12) 
    eps[2,:] = eps2 + 1j/(args.Rsq2*args.L2*2*np.pi*f*8.85e-12) 
    eps[3,:] = 56e6j 
    Zlist[:,:] = Z0, Z0/np.sqrt(eps[1,:]), Z0/np.sqrt(eps[2,:]), Z0*0
    l = np.array([args.L1, args.L2])[:,np.newaxis]
    k = np.sqrt(eps)*2*np.pi*f/3e8
    slabstack = SlabStructure(Zlist, l, k)
    R = slabstack.build_gamma()
    T = slabstack.build_tau()
    plt.plot(f/1e9, 20*np.log10(np.abs(R)),"b-", label="S11, L=50 mm")
    #plt.plot(f/1e9, 20*np.log10(np.abs(T)),"r-", label="S21, L=50 mm")
    plt.legend(loc="best").draw_frame(False)
    plt.xlabel("f [GHz]", fontsize=14)
    plt.ylabel("$20(\log|S11|),20(\log|S12|)$", fontsize=14)
    plt.title("Streuung an einer L=50 mm dicken Schicht, $\epsilon$=2.76+0.035i")
    plt.xlim([fmin, fmax])
    plt.grid()
    plt.savefig("streuung_dielektrische_Schicht.pdf", format="pdf")
    plt.show()
