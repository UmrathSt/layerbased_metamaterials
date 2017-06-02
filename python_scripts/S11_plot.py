# -*- coding: utf-8 -*-

from pyx import *
import numpy as np
import sys
from raw_text import raw
text.set(mode="latex")
unit.set(xscale=1)
c = canvas.canvas()
text.set(text.LatexRunner)
text.preamble(r"\usepackage{amsmath}")
unit.set(xscale=1.0)
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--file", action = "store")
parser.add_argument("--xlabel", action = "store")
parser.add_argument("--ylabel", action = "store")
parser.add_argument("--folder", action = "store")
args = parser.parse_args()

data = np.loadtxt(args.folder + "/" + args.file, delimiter = ",")
S11_dB = 20*np.log10(abs(data[:, 1] + 1j*data[:, 2]))


g = graph.graphxy(width=8,
		x = graph.axis.lin(title = args.xlabel),
		y = graph.axis.lin(title = args.ylabel),
		)
g.plot([graph.data.values(x = data[:, 0]/1e9, y = S11_dB)],
       [graph.style.line([color.rgb.black])])


g.writePDFfile(args.folder + "/" + args.file[0:-3] + "pdf")
