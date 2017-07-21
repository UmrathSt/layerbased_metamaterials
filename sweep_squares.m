clear;
clc;
physical_constants;
addpath("./libraries");

rect_gap = 0;
R1 = 9.5;
R2 = 5.1
w1 = 1.5;
w2 = 0.5;
UCDim = 24;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.6;
number = 10;
fr4_thickness = 2;
for L2 = [8];
  squares(UCDim, fr4_thickness, 14, L2, eps_FR4, complemential);

endfor;
