# -*- coding: utf-8 -*-

from pyx import *
import numpy as np
import sys
text.set(mode="latex")
unit.set(xscale=1)
c = canvas.canvas()
text.set(text.LatexRunner)
text.preamble(r"\usepackage{amsmath}")
unit.set(xscale=1.0)
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--infile", action = "store")
parser.add_argument("--outfile", action = "store")
parser.add_argument("--Xaxis", action = "store")
parser.add_argument("--Yaxis", action = "store")
parser.add_argument("--xlabel", action = "store")
parser.add_argument("--ylabel", action = "store")
parser.add_argument("--folder", action = "store")
args = parser.parse_args()

xaxis = int(args.Xaxis)
yaxis = int(args.Yaxis)
data = np.loadtxt(args.folder + "/" + args.infile, delimiter = ",")
S11_dB = 20*np.log10(abs(data[:, yaxis] + 1j*data[:, yaxis+1]))


g = graph.graphxy(width=8,
		x = graph.axis.lin(title = args.xlabel),
		y = graph.axis.lin(title = args.ylabel, max=0),
		)
g.plot([graph.data.values(x = data[:, xaxis]/1e9, y = S11_dB)],
       [graph.style.line([color.rgb.black])])


g.writePDFfile(args.folder + "/" + args.outfile[0:-3] + "pdf")
