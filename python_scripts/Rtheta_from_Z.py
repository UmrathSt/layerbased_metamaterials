import numpy as np
from matplotlib import pyplot as plt
from matplotlib import rc
## for Palatino and other serif fonts use:
rc('font',**{'family':'serif','serif':['Palatino']})
rc('text', usetex=True)

def Z_slab_theta(Z0, f, epsr, thickness, theta):
    """ Return the orthogonal and parallel impedance of a homogenious 
        non-magnetic slab of relative permittivity epsr and given 
        thickness at incidence angle theta
    """
    cosa = np.sqrt(1-np.sin(theta)**2/epsr)
    tan = np.tan(np.sqrt(epsr)*2*np.pi*f*thickness*cosa)
    Zorth = 1j*Z0*tan
    Zpar  = 1j*Z0*cosa/np.sqrt(epsr)*tan
    return Zorth, Zpar

def Zm(R, Z0, f, epsr, thickness):
    """ Return the impedance of a metamaterial once its
        scattering coefficient R is given and it is 
        embedded in a material of Z0
    """
    Zd = Z_slab_theta(Z0, f, epsr, thickness, 0)
    Zmorth = ( Zd[0]*Z0*(1+R) /
              (Zd[0]*(1-R)-Z0*(1+R))
              )
    Zmpar  = ( Zd[1]*Z0*(1+R) /
              (Zd[1]*(1-R)-Z0*(1+R))
              )
    return Zmorth, Zmpar


def get_R(Z0, Zs, Zm, theta):
    """ Get the reflection cofficient for perpendicular
        and parallel polarization for a metamaterial absorber
        of impedance Zm on top of a substrate with Zm embedded
        in vacuum of Z0
    """
    Rorth = ((Zs[0]*(Zm[0]*np.cos(theta)-Z0)-Zm[0]*Z0)/
             (Zs[0]*(Zm[0]*np.cos(theta)+Z0)+Zm[0]*Z0))
    Rpar  = ((Zs[1]*(Zm[1]-Z0*np.cos(theta))-Zm[1]*Z0*np.cos(theta))/
             (Zs[1]*(Zm[1]+Z0*np.cos(theta))+Zm[1]*Z0*np.cos(theta)))
    return Rorth, Rpar


if __name__ == "__main__":
    epsr = 4.4*(1+0.02j)
    thickness = 3.2e-3
    data = np.loadtxt("metamaterial_data.txt", delimiter=",")
    R0 = data[:,1]+1j*data[:,2]
    R0 *= np.exp(2*1j*(30.965-3.725)*1e-3*2*np.pi*data[:,0]/3e8)
    R0 = R0[:,np.newaxis]
    theta = np.linspace(0,np.pi/2,100)[np.newaxis,:]
    f = data[:,0][:,np.newaxis] 
    Z0 = np.sqrt(4*np.pi*1e-7/8.85e-12).reshape(1,1)
    Zslab = Z_slab_theta(Z0, f, epsr, thickness, theta)
    Zmeta = Zm(R0, Z0, f, epsr, thickness)
    print("Zslab.shape", Zslab[0].shape)
    print("Zmeta.shape", Zmeta[0].shape)
    R = get_R(Z0, Zslab, Zmeta, thickness)
    colors = ["r", "b", "g"]
    for idx in [400, 600, 800]:
        plt.plot(theta[0,:]*180/np.pi, 20*np.log10(np.abs(R[0][idx,:])))
        plt.plot(theta[0,:]*180/np.pi, 20*np.log10(np.abs(R[1][idx,:])))
    #for c, idx in zip(colors, [0,50,99]):
    #    plt.plot(f[:,0]/1e9, 20*np.log10(np.abs(R[0][:,idx])), 
    #            color=c, linestyle="-", label=r"$\theta=%.1f$" %(theta[0,idx]*180/np.pi))
    #    plt.plot(f[:,0]/1e9, 20*np.log10(np.abs(R[1][:,idx])), color=c, linestyle="--")
    #plt.legend(loc="best").draw_frame(False)
    plt.show()
