import numpy as np
from matplotlib import pyplot as plt
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("--infile1", action = "store")
parser.add_argument("--infile2", action = "store")
parser.add_argument("--ylabel1", action = "store")
parser.add_argument("--ylabel2", action = "store")
parser.add_argument("--outname", action = "store")

fig = plt.figure()

ax1 = fig.add_subplot(211)
ax2 = fig.add_subplot(212)

dat1 = np.loadtxt(infile1, delimiter=",")
dat2 = np.loadtxt(infile2, delimiter=",")

absS = []
argS = []
f1 = dat1[:,0]/1e9
f2 = dat2[:,0]/1e9
absS.append(np.abs(dat1[1,:]+dat1[2,:]*1j))
absS.append(np.abs(dat2[1,:]+dat2[2,:]*1j))
absS.append(np.abs(dat1[3,:]+dat1[4,:]*1j))
absS.append(np.abs(dat2[3,:]+dat2[4,:]*1j))
argS.append(np.arctan2(dat1[2,:],dat1[1,:]))
argS.append(np.arctan2(dat2[2,:],dat2[1,:]))
argS.append(np.arctan2(dat1[4,:],dat1[3,:]))
argS.append(np.arctan2(dat2[4,:],dat2[3,:]))

ax1.plot(f1, absS[0], "r-", label="S11, %s-pol." %(args.ylabel1))
ax1.plot(f2, absS[1], "b-", label="S11, %s-pol." %(args.ylabel2))
ax1.plot(f1, absS[2], "m-", label="S11, %s-pol." %(args.ylabel1))
ax1.plot(f2, absS[3], "c-", label="S11, %s-pol." %(args.ylabel2))
ax2.plot(f1, absS[0], "r-", label="S21, %s-pol." %(args.ylabel1))
ax2.plot(f2, absS[1], "b-", label="S21, %s-pol." %(args.ylabel2))
ax2.plot(f1, absS[2], "m-", label="S21, %s-pol." %(args.ylabel1))
ax2.plot(f2, absS[3], "c-", label="S21, %s-pol." %(args.ylabel2))
ax2.set_xlabel("$f\; \mathrm{[GHz]}$")
ax1.set_ylabel("$20\log|S_{11},S_{21}|$")
ax2.set_ylabel("$\mathrm{arg}(S_{11},S_{21})$")
fig.tight_layout()

fig.savefig(args.outname, format="pdf")
