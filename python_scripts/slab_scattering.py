import numpy as np

def rho(Z1, Z2):
    """ Return the scattering coefficient of an impedance 
        interface:
        Z1 | Z2
    """
    return (Z2-Z1)/(Z2+Z1)

def Gamma_i(rho_i, gamma_ii, li, ki):
    """ Return the scattering coefficient of a stacked 
        slab-structure:
        Z0 | Z1 | ... | ZN
    """
    phase = np.exp(-2j*ki*li)
    gamma_i = (rho_i + gamma_ii*phase) / ( 1 + rho_i*gamma_ii*phase )
    return gamma_i
