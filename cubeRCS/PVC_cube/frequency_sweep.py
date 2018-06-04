import numpy as np
from matplotlib import pyplot as plt

folder = "eps_2.7657_alpha_%s"

deg = ["0.0", "22.5"]
folders = [folder %d for d in deg]

frequencies = np.linspace(84.75, 92.5, 32)

data = np.zeros((len(folders), len(frequencies), 1441)) 
for i, fol in enumerate(folders):
    for j, freq in enumerate(frequencies):
        data[i,j,:] = np.loadtxt(fol + "/rcs_f_%.2f_GHz.dat" %freq)

fig = plt.figure()
ax1 = fig.add_subplot(111)
colors = ["r","b","g"]
idx = [0, 540, 720]
names = ["vorwärts", "135 ${}^\circ$", "rückwärts"]
for i, index in enumerate(idx):
    c = colors[i]
    ax1.plot(frequencies, 10*np.log10(data[0,:,index]), color=c, linestyle="-", label=r"$\alpha=0.0 {}^\circ$, %s" %names[i], linewidth=2)
    ax1.plot(frequencies, 10*np.log10(data[1,:,index]), color=c, linestyle="--",label=r"$\alpha=22.5 {}^\circ$, %s" %names[i], linewidth=2)
ax1.set_xlabel(r"f [GHz]", fontsize=14)
ax1.set_ylabel(r"RCS [dB]", fontsize=14)
ax1.set_title(r"RCS bei Streuung unter 0, 135 bzw. 180 ${}^\circ$ beim Aspektwinkel $\alpha$")
ax1.set_xlim([84.75,92.5])
for tick in ax1.xaxis.get_major_ticks():
    tick.label.set_fontsize(12)
plt.legend(ncol=2,loc="best").draw_frame(False)
plt.grid()
plt.savefig("frequency_sweep.pdf", format="pdf")
plt.show()
