clear;
clc;
physical_constants;
addpath("./libraries");

rect_gap = 0;
R1 = 9.5;
R2 = 5.1
w1 = 1.5;
w2 = 0.5;
UCDim = 20;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.6;
number = 10;
fr4_thickness = 2;
for ROhm = [1];
  double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_FR4, ROhm, complemential);

endfor;
