import numpy as np
from scipy.special import jv
from scipy.special import hankel1 as h1, hankel2 as H2
from scipy.special import h2vp as DH2


def jd(l, x):
    return -l*jv(l+0.5,x) + x*jv(l-0.5,x)

def hd(l, x):
    return -l*h1(l+0.5,x) + x*h1(l-0.5,x)

def hd2(l, x):
    return -l*h2(l-0.5,x) +x*h2(l-1.5,x)

def bl(l, x):
    return -jv(l+0.5,x)/h1(l+0.5,x)

def al(l, x):
    return -jd(l,x)/hd(l,x)

def sigmaPEC(lmax, f, R):
    x = (2*np.pi*f/3e8*R).reshape(1,len(f))
    l = np.arange(1, lmax+1).reshape(lmax,1)
    sigma = np.pi*R**2/x**2*np.abs(((-1)**l*(2*l+1)*(-al(l,x)+bl(l,x))).sum(axis=0))**2 
    return sigma.flatten()


if __name__ == "__main__":
    from matplotlib import pyplot as plt
    f = np.linspace(0.1,92.5,3310)*1e9
    R = 25e-3
    lmax =100 
    l = np.arange(1,lmax+1).reshape(lmax,1)
    x = 2*np.pi*f/3e8*R
    plt.plot(x, (sigmaPEC(lmax, f, R))/(R**2*np.pi), "k-", linewidth=2)
    plt.xlabel("ka", fontsize=14)
    plt.ylabel("RCS [$\mathrm{m}^2$]", fontsize=14)
    plt.show()

