import numpy as np
from scipy.optimize import least_squares

def epsilon(w, params):
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
    w = w[:,np.newaxis]
    assert len(params.shape) == 1
    assert len(params)%3 == 0
    params = params.reshape(3,len(params)//3)
    params = params[np.newaxis,:,:]
    eps_r = 1 + np.sum(params[:,0,:]**2 / (params[:,1,:]**2 - w**2 - 1j*params[:,2,:]*w), axis=1)
    return eps_r



def epsilon_wrap(xparam, wi, fi):
    """ Define the numpy arrays of function values
        fi which shall come out at the given xi values
    """
    eps = epsilon(wi, xparam)
    return (eps.real-fi.real)**2 + (eps.imag-fi.imag)**2


if __name__ == "__main__":
    from matplotlib import pyplot as plt
    wS = np.array([8e9,      9e9,      11e10,     1.2e10])
    fS = np.array([4.4*(1+0.02j), 4.4*(1+0.02j), 
                   4.4*(1+0.02j), 4.4*(1+0.02j)])
    x0 = np.array([6e10, 1e6, 3e8, 
                   3e9, 0.5e9, 4e9,
                   3e8, 20e9, 2e10,
                   8.5e11, 5e11, 1e12])
    n_params = len(x0)
    bnd = (np.ones(n_params)*0, np.ones(n_params)*np.inf)
    y_lsq = least_squares(epsilon_wrap, x0, args=(wS, fS), bounds=bnd)
    print("Least squares solution: ")
    print("fp: \n", (y_lsq.x)[::3]/(2*np.pi))
    print("f0: \n", (y_lsq.x)[1::3]/(2*np.pi))
    print("tau: \n", ((y_lsq.x)[2::3]/(2*np.pi))**(-1))
    fig = plt.figure()
    ax1 = fig.add_subplot(211)
    ax2 = fig.add_subplot(212)
    w = np.logspace(-1,1.5,100)*1e9
    ax1.semilogx(wS, np.real(fS), "ko", label="aim")
    ax1.semilogx(y_lsq.x[1::3], np.ones(n_params//3), "ro", label="poles")
    ax1.semilogx(w, np.real(epsilon(w, x0)), "k--", label="Re(eps)")
    ax1.semilogx(w, np.real(epsilon(w, y_lsq.x)), "r-", label="Re(eps)")
    ax1.legend(loc="best").draw_frame(False)
    ax1.set_ylim([3,5])
    ax2.loglog(wS, np.imag(fS), "ko", label="aim")
    ax2.loglog(w, np.imag(epsilon(w, x0)), "k--", label="Im(eps)")
    ax2.loglog(w, np.imag(epsilon(w, y_lsq.x)), "b-", label="Im(eps)")
    ax2.legend(loc="best").draw_frame(False)
    plt.show()
