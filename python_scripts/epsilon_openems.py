import numpy as np
from scipy.optimize import least_squares

def epsilonOE(w, params):
    """ Return the epsilon in a Lorentz Model
        with plasma frequencies wp, resonance
        frequencies w0 and damping constants gamma
        given in the 1d array params like:
        [wp1, w01, gamma1, wp2, w02, gamms2,...]
        Parameters:
            - w: 1d numpy array of real floats
            - params: 1d array of real floats with
              len(params)%3 = 0
    """
    epsInf = params[0]
    kappa = params[1]
    eps_r = 1j*kappa/w/8.85e-12
    w = w[:,np.newaxis]
    assert len(params.shape) == 1
    assert len(params[2:])% 3 == 0
    parm = params[2:].reshape(3,len(params[2:])//3)
    print("parm: \n", parm)
    parm = parm[np.newaxis,:,:]
    eps_r += epsInf*(1 + np.sum(parm[:,0,:]**2 / 
        (parm[:,1,:]**2 - w**2 - 1j*w/parm[:,2,:]), axis=1))

    return eps_r



def epsilon_wrap(xparam, wi, fi):
    """ Define the numpy arrays of function values
        fi which shall come out at the given xi values
    """
    eps = epsilonOE(wi, xparam)
    return (eps.real-fi.real)**2 + (eps.imag-fi.imag)**2




if __name__ == "__main__":
    from matplotlib import pyplot as plt
    wS = np.array([1e9,
                   5e9,
                   1e10
                   ])
    fS = np.array([4.4 + 1j,
                   4.3 + 1j,
                   4.2 + 1j
                   ])
    x0 = np.array([4.5, 0.1,
                   5e6/6.3, 5e9/6.3, 1e-12,
                   8e10, 5e10, 1e-11
                   ])
    fig = plt.figure()
    ax1 = fig.add_subplot(211)
    bnd = (np.ones(len(x0))*1e-14, np.ones(len(x0))*np.inf)
    ax2 = fig.add_subplot(212)
    w = np.logspace(0,2,100)*1e9
    eps = epsilonOE(w,x0)
    y_lsq = least_squares(epsilon_wrap, x0, args=(wS, fS), bounds = bnd)
    print("eps = \n", eps)
    ax1.semilogx(w, np.real(epsilonOE(w, x0)), "k--", label="Re(eps)")
    ax1.semilogx(w, np.real(epsilonOE(w, y_lsq.x)), "r--", label="Re(eps) lsq")
    ax1.legend(loc="best").draw_frame(False)
    ax2.semilogx(w, np.imag(epsilonOE(w, x0)), "k--", label="Im(eps)")
    ax2.semilogx(w, np.imag(epsilonOE(w, y_lsq.x)), "r--", label="Im(eps) lsq")
    ax1.set_ylim([3,5])
    ax2.set_ylim([0,5])
    ax2.legend(loc="best").draw_frame(False)
    plt.show()
