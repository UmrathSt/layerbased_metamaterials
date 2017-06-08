import numpy as np
from matplotlib import pyplot as plt
from filewalk import fileList
import sys
from matplotlib import rc
#rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
## for Palatino and other serif fonts use:
rc('font',**{'family':'serif','serif':['Palatino']})
rc('text', usetex=True)


argv = sys.argv
print("lenargv = ", len(argv))
if not len(argv) == 3 and not len(argv) == 4:
    raise ValueError("Falsche Anzahl an Parametersn!\n")
source = argv[1]
beginswith = argv[2]
filenames = fileList(source, beginswith) 
# current and voltage as functions of time
fig = plt.figure()
ax1 = fig.add_subplot(211)

cm = plt.get_cmap("rainbow")
col = [cm(val) for val in np.linspace(0,1, len(filenames))]
print(filenames)
data = [np.loadtxt(file_, delimiter=",") for file_ in filenames]
S_parameters = [d[:,1]+1j*d[:,2] for d in data]
minS11 = -10
for i, S in enumerate(S_parameters):
    s11db = 20*np.log10(abs(S))
    minS11 = min(minS11, np.min(s11db))
    label = filenames[i][45:-3].replace("_", "\_")
    print("\nlabel: %s, \n" %label)
    ax1.plot(data[i][:,0]/1e9, s11db, color=col[i],linestyle="-", linewidth=2, label = r"%s" %(label))

ax1.legend(loc="best").draw_frame(False)
ax1.set_xlabel(r"$f\, \mathrm{[GHz]}$")
ax1.set_ylabel(r"$20\,\log(|S_{11}|)$")
ax1.set_title("backscattering of copper-backed double-ring absorber")
ax1.set_ylim([1.1*minS11,0])
annotate_string = r"parameters:"
annotate_string += "\n"
annotate_string += r"square unit-cell, $L_\mathrm{UC}=20$ mm"
annotate_string += "\n"
annotate_string += r"ring 1, $R_1 = 9.8$ mm, $w_1=1.5$ mm"
annotate_string += "\n"
annotate_string += r"ring 2, $R_2 = 5.1$ mm, $w_2=0.5$ mm"
annotate_string += "\n"
annotate_string += r"FR4 substrate $l_z=2$ mm"
ax1.annotate(annotate_string, fontsize = 13, xy=(6,-20))
plt.tight_layout()
plt.savefig("dual-wifi_absorber.pdf", format="pdf")
plt.show()
