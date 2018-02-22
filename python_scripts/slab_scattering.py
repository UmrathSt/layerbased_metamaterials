import numpy as np

class SlabStructure:
    def __init__(self, Z, l, k):
        """ Initialze a slab structure of stacked impedance
            surfaces with different thicknesses
            Z0 | Z1 | Z2 | ... | ZN-1 | ZN
                 l1 | l2 | ... | lN-1  
        """
        self.Z = Z
        self.M = len(Z) - 1 # number of layers
        self.l = l
        self.k = k
        assert len(Z)-2 == len(l) == len(k)
    
    def build_gamma(self):
        """ Get the scattering coefficient of the
            stacked structure by recursion
        """
        rho_i = (self.Z[1:] - self.Z[0:-1]) / (self.Z[1:]+self.Z[0:-1])
        phase = self.k*self.l
        GammaM = rho_i[-1]
        phase = phase[0:-2]
        rho = rho_i[0:-2]
        return get_gamma(rho, GammaM, phase)
        



def rho(Z1, Z2):
    """ Return the scattering coefficient of an impedance 
        interface:
        Z1 | Z2
    """
    return (Z2-Z1)/(Z2+Z1)

def get_gamma(rho_i, gamma_ii, phase):
    """ Return the scattering coefficient of a stacked 
        slab-structure:
        Z0 | Z1 | ... | ZN
    """
    print("Gamma_i called with len(rho_i) = ", len(rho_i))
    if len(phase) == 0:
        return gamma_ii
    phase = np.exp(-2j*phase[-1])
    gamma = (rho_i[-1] + gamma_ii*phase) / ( 1 + rho_i[-1]*gamma_ii*phase )
    return get_gamma(rho_i[:-1], gamma, phase[:-1])

if __name__ == "__main__":
    Zlist = np.array([1,2,3,4])
    l = np.array([2,3])
    k = np.array([1,2])
    slabstack = SlabStructure(Zlist, l, k)
    print(slabstack.build_gamma())
