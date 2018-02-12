import numpy as np
from matplotlib import pyplot as plt
import argparse
import os


parser = argparse.ArgumentParser(description="Process the basefolder of the optimization")

parser.add_argument('--folder', dest='folder', 
                     help='where is the base of the result files during optimization?)')
parser.add_argument('--start', dest='start', type=int, 
                     help='What is the lowest iteration step you want to display?')

args = parser.parse_args()

print("I am trying to collect the files in folder: ", args.folder, " to compare them.")

path = args.folder

files = []
start_idx = args.start

for filename in os.listdir(path):
    if filename.endswith(".txt"):
        files.append(os.path.join(path, filename))
        continue
    else:
        continue
files.sort()

data = []
for f in files[start_idx:]:
    dat = np.loadtxt(f, delimiter=",")
    fS11 = np.zeros((dat.shape[0],2))
    fS11[:,0] = dat[:,0]
    fS11[:,1] = 1-np.abs(dat[:,1]+1j*dat[:,2])**2
    data.append(fS11)

for i, d in enumerate(data):
    plt.plot(d[:,0]/1e9, d[:,1], label="step %i" %i)

plt.legend(loc="best").draw_frame(False)
plt.xlabel("f [GHz]")
plt.ylabel("absorbed power")
plt.show()
