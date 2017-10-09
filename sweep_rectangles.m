clear;
clc;
physical_constants;
addpath("./libraries");


UCDim = 30;
complemential = 0;
eps_FR4 = 4.15;
tand = 0.015;
number = 10;
#total_FR4_thickness = 12;
fr4_thickness = 0.5;
Lmax = 26;
Lmin = 12;
N = 40;
dL = (Lmax-Lmin)/N;
#layer_thickness = total_FR4_thickness/N;
for total_FR4_thickness = 4;
    L = Lmax
    #layer_thickness = total_FR4_thickness/N;
    rectangles(UCDim, fr4_thickness, N, L, dL, eps_FR4, tand, complemential);
endfor;

