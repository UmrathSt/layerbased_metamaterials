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

def blPEC(l, x):
    return -jv(l+0.5,x)/h1(l+0.5,x)

def alPEC(l, x):
    return -jd(l,x)/hd(l,x)

def mie_general(l, x, epsSp, epsMd, muSp, muMd):
    nSp = np.sqrt(epsSp*muSp)
    nMd = np.sqrt(epsMd*muMd)
    jdSp = jd(l,x*nSp)
    jdMd = jd(l,x*nMd)
    jSp = jv(l+0.5,x*nSp)
    jMd = jv(l+0.5,x*nMd)
    hMd = h1(l+0.5,x*nMd) # caution, h1 is a non-spherical bessel function
    hdMd = hd(l,x*nMd)
    al = - (jdSp*jMd*epsMd - jdMd*jSp*epsSp)/(jdSp*hMd*epsMd - hdMd*jSp*epsSp)
    bl = - (jdSp*jMd* muMd - jdMd*jSp* muSp)/(jdSp*hMd* muMd - hdMd*jSp* muSp)
    return al, bl

def sigmaPEC(lmax, f, R):
    x = (2*np.pi*f/3e8*R).reshape(1,len(f))
    l = np.arange(1, lmax+1).reshape(lmax,1)
    sigma = np.pi*R**2/x**2*np.abs(((-1)**l*(2*l+1)*(-alPEC(l,x)+blPEC(l,x))).sum(axis=0))**2 
    return sigma.flatten()

def sigma(lmax, f, R, epsSp, epsMd, muSp, muMd):
    x = (2*np.pi*f/3e8*R).reshape(1,len(f))
    l = np.arange(1, lmax+1).reshape(lmax,1)
    al, bl = mie_general(l, x, epsSp, epsMd, muSp, muMd)
    sigma = np.pi*R**2/x**2*np.abs(((-1)**l*(2*l+1)*(-al+bl)).sum(axis=0))**2 
    return sigma.flatten()


if __name__ == "__main__":
    from matplotlib import pyplot as plt
    f = np.linspace(1,90,891)*1e9
    R = 25e-3
    lmax =120 
    l = np.arange(1,lmax+1).reshape(lmax,1)
    x = 2*np.pi*f/3e8*R
    area = R**2*np.pi
    to_write = np.zeros((len(f),2))
    to_write[:,0] = f/1e9
    to_write[:,1] = sigmaPEC(lmax, f, R)
    header = 'Mie-theory result for the monostatic RCS [m^2] of a R = 25 mm PEC sphere as a function of frequency [GHz]'
    np.savetxt('monostatic_rcs_mie_R_25mm.dat', to_write, delimiter=",", header=header)
    rsphere_result = np.loadtxt("../cubeRCS/PEC_sphere_refined/second_try/refined_monostatic_rcs_sphere.dat", delimiter=",")
    sphere_result = np.loadtxt("../cubeRCS/PEC_sphere/monostatic_rcs_sphere.dat", delimiter=",")
    #cube_result = np.loadtxt("../cubeRCS/PVC_cube_1-10GHz/alpha_0/monostatic_PVC_cube_rcs_f.dat", delimiter=",")
    #plt.plot(2*np.pi*cube_result[:,0]*0.05*1e9/3e8, 1/area*cube_result[:,1],"bo-", linewidth=2, label="Würfel, L=2R, alpha=0° (openEMS)")
    plt.plot(2*np.pi*sphere_result[:,0]*0.025*1e9/3e8, 1/area*sphere_result[:,1],"ro", markersize=4,linewidth=2, label="PEC Kugel (openEMS)")
    plt.plot(2*np.pi*rsphere_result[::2,0]*0.025*1e9/3e8, 1/area*rsphere_result[::2,1],"g-", markersize=4,linewidth=2, label="PEC Kugel (openEMS r)")
    #plt.plot(x, (sigmaPEC(lmax, f, R))/(R**2*np.pi), "k-", linewidth=2)
    plt.plot(x, (sigma(lmax, f, R, 2.7657+0.035j, 1, 1, 1))/area, "k-", linewidth=2, label="Kugel, R=25 mm (Mie-Theorie)")
    plt.plot(x, (sigmaPEC(lmax, f, R))/area, "r-", linewidth=2, label="PEC Kugel, R=25 mm (Mie-Theorie)")
    plt.xlabel(r"kR", fontsize=14)
    plt.ylabel("monostatischer RCS/($R^2\pi$)", fontsize=14)
    plt.title(r"monostatischer RCS für Würfel und Kugel mit $\epsilon = 2.7657+0.035\mathrm{i}$", fontsize=14)
    plt.legend(loc="best").draw_frame(False)
    plt.ylim([0,16])
    plt.savefig("mieKugel_vs_wuerfel.pdf", format="pdf")
    plt.show()

